#!/usr/bin/env python3
"""
Note: This obviously requires the help of AI (ft. Gemini and Claude), but might only work to convert from GRAPLock version to the desired format of the source code, in addition to possible hidden discreprancies during conversion

WHAT THIS DOES
  1. Renames key inputs keyinputN -> KEYINPUTN (the Perl parser's key
     detection is a case-sensitive substring match on "KEYINPUT"; lowercase
     names are silently never recognised as keys).
  2. Converts plain gates to named-port form:
        not  g(out, in)        -> INV_X1  g ( .A(in), .ZN(out) );
        nand g(out, a, b)      -> NAND2_X1 g ( .A1(a), .A2(b), .ZN(out) );
        nor  g(out, a, b)      -> NOR2_X1  g ( .A1(a), .A2(b), .ZN(out) );
        and  g(out, a, b)      -> AND2_X1  g ( .A1(a), .A2(b), .ZN(out) );
        or   g(out, a, b)      -> OR2_X1   g ( .A1(a), .A2(b), .Z(out) );
     (n-input gates with more than 2 inputs are supported: extra inputs get
     A3, A4, ... pins, which the Perl parser already recognises.)
  3. Detects the recurring 6-line 2:1 function-select key-locking block:
        <g1> n1(o1, a, b);
        <g2> n2(o2, a, b);
        not  n3(nk, KEYINPUTi);
        and  n4(x1, nk, o1);
        and  n5(x2, KEYINPUTi, o2);
        or   n6(out, x1, x2);
     and collapses it into ONE pseudo-cell:
        MUXKEY2_X1 n1 ( .A1(a), .A2(b), .K(KEYINPUTi), .Z(out) );
     This preserves the REAL function (out = K ? g2(a,b) : g1(a,b)); it is
     NOT a disguised XOR/XNOR, because the two functions are not generally
     equivalent to an XOR/XNOR of a single signal. See the accompanying
     patch notes for what Main_*.py / netlist_to_subgraphs.pl need in order
     to recognise this new cell type -- it is NOT understood out of the box.

USAGE
    python3 convert_netlist.py input.v output.v
    python3 convert_netlist.py input.v output.v --report report.json

LIMITATIONS / WHAT TO CHECK BY HAND
  * Only handles the exact 6-line block shape shown above (g1/g2 in
    {nand,nor,and,or}, in that structural order). If your locking tool used
    a different block shape (e.g. a true 2:1 MUX with a 'mux' primitive,
    or 3+ gate variants), the block won't be recognised and will be left as
    plain gates -- inspect the --report output for "unmatched_key_regions".
  * Assumes gate instance names are unique (true of the sample you shared).
  * Does not touch module port declarations, `input`/`output`/`wire`
    statements, or comments -- only gate instantiation statements.
  * Does NOT attempt logic resynthesis of any kind.
"""
import argparse
import json
import re
import sys

PRIM_RE = re.compile(
    r'^\s*(not|nand|nor|and|or|buf|xor|xnor)\s+(\w+)\s*\(\s*([^;]+?)\s*\)\s*;',
    re.MULTILINE)

MODULE_HDR_RE = re.compile(r'^\s*(module|endmodule|input|output|wire)\b')


def split_args(s):
    return [a.strip() for a in s.split(',')]


def parse_gates(text):
    """Return list of dicts: {type, name, out, ins, span:(start,end)}."""
    gates = []
    for m in PRIM_RE.finditer(text):
        gtype, name, args = m.group(1), m.group(2), m.group(3)
        parts = split_args(args)
        out, ins = parts[0], parts[1:]
        gates.append(dict(type=gtype, name=name, out=out, ins=ins,
                          start=m.start(), end=m.end(), raw=m.group(0)))
    return gates


def named_port_str(cell, inst_name, ins, out, out_pin):
    pins = []
    if len(ins) == 1:
        pins.append('.A(%s)' % ins[0])
    else:
        for i, sig in enumerate(ins, start=1):
            pins.append('.A%d(%s)' % (i, sig))
    pins.append('.%s(%s)' % (out_pin, out))
    return '  %s %s ( %s );' % (cell, inst_name, ', '.join(pins))


CELL_MAP = {
    # gtype : (cell_name_prefix, output_pin)
    'not':  ('INV_X1', 'ZN'),
    'buf':  ('BUF_X1', 'Z'),
    'nand': ('NAND2_X1', 'ZN'),
    'nor':  ('NOR2_X1', 'ZN'),
    'and':  ('AND2_X1', 'ZN'),   # matches the AND2_X2/.ZN convention seen in the author's file
    'or':   ('OR2_X1', 'Z'),
    'xor':  ('XOR2_X1', 'Z'),
    'xnor': ('XNOR2_X1', 'ZN'),
}


def convert_plain_gate(g):
    cell, out_pin = CELL_MAP[g['type']]
    return named_port_str(cell, g['name'], g['ins'], g['out'], out_pin)


def try_match_muxkey_block(gates, idx):
    """
    Try to match gates[idx:idx+6] against the 6-gate key-mux pattern:
      g0: <t0> n0(o0, a, b)
      g1: <t1> n1(o1, a, b)        same a,b as g0
      g2: not  n2(nk, KEYINPUTi)
      g3: and  n3(x1, nk, o0)      or (nk, o1) -- order not fixed
      g4: and  n4(x2, KEYINPUTi, o_other)
      g5: or   n5(out, x1, x2)
    Returns (match_dict, n_gates_consumed) or (None, 0).
    """
    if idx + 6 > len(gates):
        return None, 0
    g0, g1, g2, g3, g4, g5 = gates[idx:idx + 6]

    if g0['type'] not in ('nand', 'nor', 'and', 'or'):
        return None, 0
    if g1['type'] not in ('nand', 'nor', 'and', 'or'):
        return None, 0
    if set(g0['ins']) != set(g1['ins']) or len(g0['ins']) != 2:
        return None, 0
    if g2['type'] != 'not':
        return None, 0
    key_sig = g2['ins'][0]
    if 'KEYINPUT' not in key_sig.upper():
        return None, 0
    not_key_out = g2['out']

    if g3['type'] != 'and' or g4['type'] != 'and':
        return None, 0
    # g3 should combine not_key_out with one of {g0.out, g1.out}
    g3_ins = set(g3['ins'])
    g4_ins = set(g4['ins'])
    if not_key_out not in g3_ins:
        return None, 0
    if key_sig not in g4_ins and key_sig not in [i for i in g4['ins']]:
        return None, 0

    o_from_g3 = (g3_ins - {not_key_out})
    o_from_g4 = (g4_ins - {key_sig})
    if len(o_from_g3) != 1 or len(o_from_g4) != 1:
        return None, 0
    o_from_g3 = o_from_g3.pop()
    o_from_g4 = o_from_g4.pop()
    if {o_from_g3, o_from_g4} != {g0['out'], g1['out']}:
        return None, 0

    if g5['type'] != 'or':
        return None, 0
    if set(g5['ins']) != {g3['out'], g4['out']}:
        return None, 0

    # which of g0/g1 is selected when key==0 vs key==1
    # g4 uses key_sig directly -> its paired gate output is selected when key==1
    g_key1 = g0 if o_from_g4 == g0['out'] else g1
    g_key0 = g1 if g_key1 is g0 else g0

    match = dict(
        inst_name=g0['name'],
        a=g0['ins'][0], b=g0['ins'][1],
        key=key_sig,
        out=g5['out'],
        func_key0=g_key0['type'],
        func_key1=g_key1['type'],
        start=g0['start'], end=g5['end'],
    )
    return match, 6


def convert(text, report):
    gates = parse_gates(text)
    out_pieces = []
    cursor = 0
    i = 0
    n_plain = 0
    n_muxkey = 0
    unmatched = []

    while i < len(gates):
        match, consumed = try_match_muxkey_block(gates, i)
        if match:
            out_pieces.append(text[cursor:match['start']])
            # NOTE: the author's Perl parser requires a gate-instantiation line
            # to end in ';' followed only by whitespace (its regex anchors on
            # \;\s*$). A trailing same-line comment breaks that match and the
            # gate is silently dropped from the whole netlist with no error.
            # So the key0/key1 note goes on its OWN comment line, not inline.
            note = '  // %s: key=0 -> %s(a,b), key=1 -> %s(a,b)' % (
                match['inst_name'], match['func_key0'], match['func_key1'])
            line = ('  MUXKEY2_X1 %s ( .A1(%s), .A2(%s), .K(%s), .Z(%s) );'
                    % (match['inst_name'], match['a'], match['b'],
                       match['key'], match['out']))
            out_pieces.append(note + '\n' + line)
            cursor = match['end']
            n_muxkey += 1
            i += consumed
        else:
            g = gates[i]
            # heuristic: a lone 'not'/'and'/'or'/'nand'/'nor' that LOOKS like
            # the start of a key block (next gate shares its inputs) but
            # failed to match fully -> flag for manual review
            if g['type'] in ('nand', 'nor', 'and', 'or') and i + 1 < len(gates):
                g_next = gates[i + 1]
                if (g_next['type'] in ('nand', 'nor', 'and', 'or')
                        and set(g['ins']) == set(g_next['ins'])
                        and len(g['ins']) == 2):
                    unmatched.append(dict(name=g['name'], line_start=g['start']))
            out_pieces.append(text[cursor:g['start']])
            out_pieces.append(convert_plain_gate(g))
            cursor = g['end']
            n_plain += 1
            i += 1

    out_pieces.append(text[cursor:])
    converted = ''.join(out_pieces)

    # rename keyinputN -> KEYINPUTN (word-boundary, case-insensitive match on
    # the literal prefix, preserving the numeric suffix)
    converted = re.sub(r'\bkeyinput(\d+)\b', r'KEYINPUT\1', converted, flags=re.IGNORECASE)

    report.update(
        n_plain_gates_converted=n_plain,
        n_muxkey_blocks_collapsed=n_muxkey,
        unmatched_key_regions=unmatched,
    )
    return converted


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('input', help='input .v netlist (positional-port primitives)')
    ap.add_argument('output', help='output .v netlist (named-port, author-compatible)')
    ap.add_argument('--report', help='optional path to write a JSON conversion report')
    args = ap.parse_args()

    with open(args.input) as f:
        text = f.read()

    report = {}
    converted = convert(text, report)

    with open(args.output, 'w') as f:
        f.write(converted)

    print("Converted %s -> %s" % (args.input, args.output))
    print("  plain gates converted      : %d" % report['n_plain_gates_converted'])
    print("  mux-key blocks collapsed   : %d" % report['n_muxkey_blocks_collapsed'])
    if report['unmatched_key_regions']:
        print("  WARNING: %d region(s) looked like a key block but did not "
              "fully match -- inspect these by hand:"
              % len(report['unmatched_key_regions']))
        for u in report['unmatched_key_regions'][:20]:
            print("    instance '%s' near offset %d" % (u['name'], u['line_start']))
        if len(report['unmatched_key_regions']) > 20:
            print("    ... and %d more" % (len(report['unmatched_key_regions']) - 20))

    if args.report:
        with open(args.report, 'w') as f:
            json.dump(report, f, indent=2)
        print("Report written to", args.report)

    if report['n_muxkey_blocks_collapsed'] > 0:
        print("\nNOTE: MUXKEY2_X1 is a NEW cell type the original Perl parser and\n"
              "Python feature vector do not know about. See the patch notes before\n"
              "running netlist_to_subgraphs.pl on this output.")

if __name__ == '__main__':
    main()