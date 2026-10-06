// Verilog
// ctrl
// Ninputs 2
// Noutputs 19
// NtotalGates 249
// AND2 89
// OR2 5
// NOR2 80
// NOT1 75

module top ( 
    \opcode[0] , \opcode[1] , \opcode[2] , \opcode[3] , \opcode[4] ,
    \op_ext[0] , \op_ext[1] ,
    \sel_reg_dst[0] , \sel_reg_dst[1] , \sel_alu_opB[0] , \sel_alu_opB[1] ,
    \alu_op[0] , \alu_op[1] , \alu_op[2] , \alu_op_ext[0] ,
    \alu_op_ext[1] , \alu_op_ext[2] , \alu_op_ext[3] , halt, reg_write,
    sel_pc_opA, sel_pc_opB, beqz, bnez, bgez, bltz, jump, Cin, invA, invB,
    sign, mem_write, sel_wb  );
  input  \opcode[0] , \opcode[1] , \opcode[2] , \opcode[3] , \opcode[4] ,
    \op_ext[0] , \op_ext[1] ;
  output \sel_reg_dst[0] , \sel_reg_dst[1] , \sel_alu_opB[0] ,
    \sel_alu_opB[1] , \alu_op[0] , \alu_op[1] , \alu_op[2] ,
    \alu_op_ext[0] , \alu_op_ext[1] , \alu_op_ext[2] , \alu_op_ext[3] ,
    halt, reg_write, sel_pc_opA, sel_pc_opB, beqz, bnez, bgez, bltz, jump,
    Cin, invA, invB, sign, mem_write, sel_wb;
  wire n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
    n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n63, n64,
    n65, n66, n67, n68, n69, n71, n72, n73, n74, n75, n76, n77, n78, n80,
    n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94,
    n95, n96, n97, n99, n100, n101, n102, n103, n104, n106, n107, n108,
    n109, n110, n111, n112, n113, n114, n115, n117, n118, n119, n120, n121,
    n123, n124, n125, n126, n127, n128, n129, n131, n132, n134, n135, n136,
    n137, n139, n140, n141, n142, n143, n145, n146, n147, n148, n149, n150,
    n151, n153, n154, n156, n158, n159, n160, n161, n162, n164, n165, n166,
    n167, n169, n170, n171, n173, n174, n175, n177, n179, n180, n181, n182,
    n183, n184, n185, n186, n188, n189, n190, n191, n192, n193, n194, n195,
    n197, n198, n200, n201, n202, n203, n205, n206, n207;
  wire inv_opcode_1_0 , inv_opcode_1_1 , inv_n45_2 , inv_n47_3 , inv_n53_4 , inv_opcode_3_5 , inv_n58_6 , inv_n59_7 , inv_n60_8 , inv_n36_9 ;
  wire inv_n64_10 , inv_n66_11 , inv_n57_12 , inv_n45_13 , inv_n53_14 , inv_opcode_0_15 , inv_op_ext_1_16 , inv_n36_17 , inv_op_ext_0_18 , inv_n36_19 ;
  wire inv_n88_20 , inv_n90_21 , inv_n92_22 , inv_n53_23 , inv_n95_24 , inv_n96_25 , inv_n100_26 , inv_n54_27 , inv_n103_28 , inv_n44_29 ;
  wire inv_n44_30 , inv_n58_31 , inv_n110_32 , inv_n52_33 , inv_n74_34 , inv_n120_35 , inv_n124_36 , inv_opcode_2_37 , inv_n125_38 , inv_n45_39 ;
  wire inv_n134_40 , inv_n135_41 , inv_opcode_1_42 , inv_n64_43 , inv_n150_44 , inv_n109_45 , inv_n153_46 , inv_n154_47 , inv_n140_48 , inv_n156_49 ;
  wire inv_n161_50 , inv_n162_51 , inv_n65_52 , inv_n166_53 , inv_n167_54 , inv_n164_55 , inv_n169_56 , inv_n170_57 , inv_n171_58 , inv_n159_59 ;
  wire inv_n173_60 , inv_n174_61 , inv_n175_62 , inv_n58_63 , inv_n177_64 , inv_n88_65 , inv_n65_66 , inv_n180_67 , inv_n51_68 , inv_n185_69 ;
  wire inv_n190_70 , inv_n191_71 , inv_n192_72 , inv_n90_73 , inv_n96_74 ;
  not NOT_0 (inv_opcode_1_0 , \opcode[1] );
  and AND_0 (n35 , \opcode[0] , inv_opcode_1_0 );
  and AND_1 (n36 , \opcode[3] , \opcode[4] );
  and AND_2 (n37 , n35 , n36 );
  and AND_3 (n38 , \opcode[1] , \opcode[3] );
  and AND_4 (n39 , \opcode[4] , n38 );
  nor NOR_0 (n40 , n37 , n39 );
  nor NOR_1 (n41 , \opcode[2] , n40 );
  not NOT_1 (inv_opcode_1_1 , \opcode[1] );
  and AND_5 (n42 , inv_opcode_1_1 , \opcode[3] );
  and AND_6 (n43 , \opcode[4] , n42 );
  nor NOR_2 (n44 , \opcode[3] , \opcode[4] );
  nor NOR_3 (n45 , n36 , n44 );
  not NOT_2 (inv_n45_2 , n45 );
  and AND_7 (n46 , \opcode[1] , inv_n45_2 );
  nor NOR_4 (n47 , n43 , n46 );
  not NOT_3 (inv_n47_3 , n47 );
  and AND_8 (n48 , \opcode[2] , inv_n47_3 );
  or OR_0 (\sel_reg_dst[0] , n41 , n48 );
  nor NOR_5 (n50 , \opcode[0] , n36 );
  nor NOR_6 (n51 , \opcode[0] , n50 );
  nor NOR_7 (n52 , \opcode[1] , n51 );
  nor NOR_8 (n53 , \opcode[3] , n44 );
  not NOT_4 (inv_n53_4 , n53 );
  and AND_9 (n54 , \opcode[1] , inv_n53_4 );
  nor NOR_9 (n55 , n52 , n54 );
  nor NOR_10 (n56 , \opcode[2] , n55 );
  not NOT_5 (inv_opcode_3_5 , \opcode[3] );
  and AND_10 (n57 , inv_opcode_3_5 , \opcode[4] );
  nor NOR_11 (n58 , \opcode[3] , n57 );
  not NOT_6 (inv_n58_6 , n58 );
  and AND_11 (n59 , \opcode[1] , inv_n58_6 );
  not NOT_7 (inv_n59_7 , n59 );
  and AND_12 (n60 , \opcode[1] , inv_n59_7 );
  not NOT_8 (inv_n60_8 , n60 );
  and AND_13 (n61 , \opcode[2] , inv_n60_8 );
  nor NOR_12 (\sel_reg_dst[1] , n56 , n61 );
  nor NOR_13 (n63 , \opcode[0] , n45 );
  not NOT_9 (inv_n36_9 , n36 );
  and AND_14 (n64 , \opcode[3] , inv_n36_9 );
  not NOT_10 (inv_n64_10 , n64 );
  and AND_15 (n65 , \opcode[0] , inv_n64_10 );
  nor NOR_14 (n66 , n63 , n65 );
  not NOT_11 (inv_n66_11 , n66 );
  and AND_16 (n67 , \opcode[1] , inv_n66_11 );
  nor NOR_15 (n68 , n52 , n67 );
  nor NOR_16 (n69 , \opcode[2] , n68 );
  nor NOR_17 (\sel_alu_opB[0] , \opcode[2] , n69 );
  nor NOR_18 (n71 , \opcode[0] , \opcode[3] );
  not NOT_12 (inv_n57_12 , n57 );
  and AND_17 (n72 , inv_n57_12 , n71 );
  not NOT_13 (inv_n45_13 , n45 );
  and AND_18 (n73 , \opcode[0] , inv_n45_13 );
  nor NOR_19 (n74 , n72 , n73 );
  nor NOR_20 (n75 , \opcode[1] , n74 );
  nor NOR_21 (n76 , n54 , n75 );
  nor NOR_22 (n77 , \opcode[2] , n76 );
  not NOT_14 (inv_n53_14 , n53 );
  and AND_19 (n78 , \opcode[2] , inv_n53_14 );
  nor NOR_23 (\sel_alu_opB[1] , n77 , n78 );
  not NOT_15 (inv_opcode_0_15 , \opcode[0] );
  and AND_20 (n80 , inv_opcode_0_15 , \opcode[3] );
  and AND_21 (n81 , \opcode[4] , \op_ext[0] );
  and AND_22 (n82 , n80 , n81 );
  not NOT_16 (inv_op_ext_1_16 , \op_ext[1] );
  and AND_23 (n83 , \opcode[3] , inv_op_ext_1_16 );
  not NOT_17 (inv_n36_17 , n36 );
  and AND_24 (n84 , inv_n36_17 , n83 );
  not NOT_18 (inv_op_ext_0_18 , \op_ext[0] );
  and AND_25 (n85 , \opcode[3] , inv_op_ext_0_18 );
  not NOT_19 (inv_n36_19 , n36 );
  and AND_26 (n86 , inv_n36_19 , n85 );
  and AND_27 (n87 , \opcode[3] , \op_ext[0] );
  nor NOR_24 (n88 , n86 , n87 );
  not NOT_20 (inv_n88_20 , n88 );
  and AND_28 (n89 , \op_ext[1] , inv_n88_20 );
  nor NOR_25 (n90 , n84 , n89 );
  not NOT_21 (inv_n90_21 , n90 );
  and AND_29 (n91 , \opcode[0] , inv_n90_21 );
  nor NOR_26 (n92 , n82 , n91 );
  not NOT_22 (inv_n92_22 , n92 );
  and AND_30 (n93 , \opcode[1] , inv_n92_22 );
  nor NOR_27 (n94 , \opcode[2] , n93 );
  not NOT_23 (inv_n53_23 , n53 );
  and AND_31 (n95 , \opcode[0] , inv_n53_23 );
  not NOT_24 (inv_n95_24 , n95 );
  and AND_32 (n96 , \opcode[0] , inv_n95_24 );
  not NOT_25 (inv_n96_25 , n96 );
  and AND_33 (n97 , \opcode[2] , inv_n96_25 );
  nor NOR_28 (\alu_op[0] , n94 , n97 );
  and AND_34 (n99 , \opcode[3] , \op_ext[1] );
  nor NOR_29 (n100 , n84 , n99 );
  not NOT_26 (inv_n100_26 , n100 );
  and AND_35 (n101 , \opcode[1] , inv_n100_26 );
  nor NOR_30 (n102 , \opcode[2] , n101 );
  not NOT_27 (inv_n54_27 , n54 );
  and AND_36 (n103 , \opcode[1] , inv_n54_27 );
  not NOT_28 (inv_n103_28 , n103 );
  and AND_37 (n104 , \opcode[2] , inv_n103_28 );
  nor NOR_31 (\alu_op[1] , n102 , n104 );
  nor NOR_32 (n106 , \opcode[1] , n36 );
  not NOT_29 (inv_n44_29 , n44 );
  and AND_38 (n107 , inv_n44_29 , n106 );
  not NOT_30 (inv_n44_30 , n44 );
  and AND_39 (n108 , inv_n44_30 , n50 );
  not NOT_31 (inv_n58_31 , n58 );
  and AND_40 (n109 , \opcode[0] , inv_n58_31 );
  nor NOR_33 (n110 , n108 , n109 );
  not NOT_32 (inv_n110_32 , n110 );
  and AND_41 (n111 , \opcode[1] , inv_n110_32 );
  nor NOR_34 (n112 , n107 , n111 );
  nor NOR_35 (n113 , \opcode[2] , n112 );
  and AND_42 (n114 , \opcode[2] , \opcode[3] );
  and AND_43 (n115 , \opcode[4] , n114 );
  or OR_1 (\alu_op[2] , n113 , n115 );
  nor NOR_36 (n117 , \opcode[1] , \opcode[2] );
  not NOT_33 (inv_n52_33 , n52 );
  and AND_44 (n118 , inv_n52_33 , n117 );
  not NOT_34 (inv_n74_34 , n74 );
  and AND_45 (n119 , \opcode[1] , inv_n74_34 );
  nor NOR_37 (n120 , n37 , n119 );
  not NOT_35 (inv_n120_35 , n120 );
  and AND_46 (n121 , \opcode[2] , inv_n120_35 );
  or OR_2 (\alu_op_ext[0] , n118 , n121 );
  nor NOR_38 (n123 , \opcode[0] , n53 );
  nor NOR_39 (n124 , \opcode[0] , n123 );
  not NOT_36 (inv_n124_36 , n124 );
  and AND_47 (n125 , \opcode[1] , inv_n124_36 );
  not NOT_37 (inv_opcode_2_37 , \opcode[2] );
  and AND_48 (n126 , \opcode[1] , inv_opcode_2_37 );
  not NOT_38 (inv_n125_38 , n125 );
  and AND_49 (n127 , inv_n125_38 , n126 );
  and AND_50 (n128 , \opcode[1] , \opcode[2] );
  not NOT_39 (inv_n45_39 , n45 );
  and AND_51 (n129 , inv_n45_39 , n128 );
  or OR_3 (\alu_op_ext[1] , n127 , n129 );
  nor NOR_40 (n131 , n106 , n125 );
  nor NOR_41 (n132 , \opcode[2] , n131 );
  nor NOR_42 (\alu_op_ext[2] , n61 , n132 );
  nor NOR_43 (n134 , n80 , n109 );
  not NOT_40 (inv_n134_40 , n134 );
  and AND_52 (n135 , \opcode[1] , inv_n134_40 );
  nor NOR_44 (n136 , \opcode[2] , n107 );
  not NOT_41 (inv_n135_41 , n135 );
  and AND_53 (n137 , inv_n135_41 , n136 );
  nor NOR_45 (\alu_op_ext[3] , n78 , n137 );
  nor NOR_46 (n139 , \opcode[0] , n58 );
  nor NOR_47 (n140 , \opcode[0] , n139 );
  nor NOR_48 (n141 , \opcode[1] , n140 );
  nor NOR_49 (n142 , \opcode[1] , n141 );
  nor NOR_50 (n143 , \opcode[2] , n142 );
  nor NOR_51 (halt , \opcode[2] , n143 );
  nor NOR_52 (n145 , \opcode[1] , n134 );
  nor NOR_53 (n146 , n59 , n145 );
  nor NOR_54 (n147 , \opcode[2] , n146 );
  not NOT_42 (inv_opcode_1_42 , \opcode[1] );
  and AND_54 (n148 , inv_opcode_1_42 , \opcode[4] );
  not NOT_43 (inv_n64_43 , n64 );
  and AND_55 (n149 , \opcode[1] , inv_n64_43 );
  nor NOR_55 (n150 , n148 , n149 );
  not NOT_44 (inv_n150_44 , n150 );
  and AND_56 (n151 , \opcode[2] , inv_n150_44 );
  or OR_4 (reg_write , n147 , n151 );
  not NOT_45 (inv_n109_45 , n109 );
  and AND_57 (n153 , \opcode[0] , inv_n109_45 );
  not NOT_46 (inv_n153_46 , n153 );
  and AND_58 (n154 , \opcode[2] , inv_n153_46 );
  not NOT_47 (inv_n154_47 , n154 );
  and AND_59 (sel_pc_opA , \opcode[2] , inv_n154_47 );
  not NOT_48 (inv_n140_48 , n140 );
  and AND_60 (n156 , \opcode[2] , inv_n140_48 );
  not NOT_49 (inv_n156_49 , n156 );
  and AND_61 (sel_pc_opB , \opcode[2] , inv_n156_49 );
  nor NOR_56 (n158 , \opcode[0] , n64 );
  nor NOR_57 (n159 , \opcode[0] , n158 );
  nor NOR_58 (n160 , \opcode[1] , n159 );
  nor NOR_59 (n161 , \opcode[1] , n160 );
  not NOT_50 (inv_n161_50 , n161 );
  and AND_62 (n162 , \opcode[2] , inv_n161_50 );
  not NOT_51 (inv_n162_51 , n162 );
  and AND_63 (beqz , \opcode[2] , inv_n162_51 );
  not NOT_52 (inv_n65_52 , n65 );
  and AND_64 (n164 , \opcode[0] , inv_n65_52 );
  nor NOR_60 (n165 , \opcode[1] , n164 );
  nor NOR_61 (n166 , \opcode[1] , n165 );
  not NOT_53 (inv_n166_53 , n166 );
  and AND_65 (n167 , \opcode[2] , inv_n166_53 );
  not NOT_54 (inv_n167_54 , n167 );
  and AND_66 (bnez , \opcode[2] , inv_n167_54 );
  not NOT_55 (inv_n164_55 , n164 );
  and AND_67 (n169 , \opcode[1] , inv_n164_55 );
  not NOT_56 (inv_n169_56 , n169 );
  and AND_68 (n170 , \opcode[1] , inv_n169_56 );
  not NOT_57 (inv_n170_57 , n170 );
  and AND_69 (n171 , \opcode[2] , inv_n170_57 );
  not NOT_58 (inv_n171_58 , n171 );
  and AND_70 (bgez , \opcode[2] , inv_n171_58 );
  not NOT_59 (inv_n159_59 , n159 );
  and AND_71 (n173 , \opcode[1] , inv_n159_59 );
  not NOT_60 (inv_n173_60 , n173 );
  and AND_72 (n174 , \opcode[1] , inv_n173_60 );
  not NOT_61 (inv_n174_61 , n174 );
  and AND_73 (n175 , \opcode[2] , inv_n174_61 );
  not NOT_62 (inv_n175_62 , n175 );
  and AND_74 (bltz , \opcode[2] , inv_n175_62 );
  not NOT_63 (inv_n58_63 , n58 );
  and AND_75 (n177 , \opcode[2] , inv_n58_63 );
  not NOT_64 (inv_n177_64 , n177 );
  and AND_76 (jump , \opcode[2] , inv_n177_64 );
  and AND_77 (n179 , \opcode[0] , \opcode[1] );
  not NOT_65 (inv_n88_65 , n88 );
  and AND_78 (n180 , inv_n88_65 , n179 );
  not NOT_66 (inv_n65_66 , n65 );
  and AND_79 (n181 , n35 , inv_n65_66 );
  nor NOR_62 (n182 , \opcode[2] , n181 );
  not NOT_67 (inv_n180_67 , n180 );
  and AND_80 (n183 , inv_n180_67 , n182 );
  not NOT_68 (inv_n51_68 , n51 );
  and AND_81 (n184 , \opcode[1] , inv_n51_68 );
  nor NOR_63 (n185 , n106 , n184 );
  not NOT_69 (inv_n185_69 , n185 );
  and AND_82 (n186 , \opcode[2] , inv_n185_69 );
  nor NOR_64 (Cin , n183 , n186 );
  and AND_83 (n188 , \op_ext[0] , n36 );
  nor NOR_65 (n189 , \op_ext[1] , n188 );
  nor NOR_66 (n190 , \op_ext[1] , n189 );
  not NOT_70 (inv_n190_70 , n190 );
  and AND_84 (n191 , \opcode[0] , inv_n190_70 );
  not NOT_71 (inv_n191_71 , n191 );
  and AND_85 (n192 , \opcode[0] , inv_n191_71 );
  not NOT_72 (inv_n192_72 , n192 );
  and AND_86 (n193 , \opcode[1] , inv_n192_72 );
  nor NOR_67 (n194 , n165 , n193 );
  nor NOR_68 (n195 , \opcode[2] , n194 );
  nor NOR_69 (invA , \opcode[2] , n195 );
  not NOT_73 (inv_n90_73 , n90 );
  and AND_87 (n197 , inv_n90_73 , n179 );
  nor NOR_70 (n198 , \opcode[2] , n197 );
  nor NOR_71 (invB , n186 , n198 );
  nor NOR_72 (n200 , \opcode[1] , n124 );
  not NOT_74 (inv_n96_74 , n96 );
  and AND_88 (n201 , \opcode[1] , inv_n96_74 );
  nor NOR_73 (n202 , n200 , n201 );
  nor NOR_74 (n203 , \opcode[2] , n202 );
  nor NOR_75 (mem_write , \opcode[2] , n203 );
  nor NOR_76 (n205 , \opcode[1] , n96 );
  nor NOR_77 (n206 , \opcode[1] , n205 );
  nor NOR_78 (n207 , \opcode[2] , n206 );
  nor NOR_79 (sel_wb , \opcode[2] , n207 );
  assign sign = 1'b1 ;
endmodule
