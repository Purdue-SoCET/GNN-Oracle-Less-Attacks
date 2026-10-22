import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import os
import re
import numpy as np

benchmarks = ['c1355', 'c1908', 'c2670', 'c3540']

results = {
    'Train_Acc': {b: {'Original': 0.0, 'Modified': 0.0} for b in benchmarks},
    'Val_Acc': {b: {'Original': 0.0, 'Modified': 0.0} for b in benchmarks},
    'Test_Acc': {b: {'Original': 0.0, 'Modified': 0.0} for b in benchmarks},
    'Loss': {b: {'Original': 0.0, 'Modified': 0.0} for b in benchmarks},
    'Epochs': {b: {'Original': 0, 'Modified': 0} for b in benchmarks}
}

for filename in benchmarks:
    orig_res = f"res_{filename}_orig.txt"
    mod_res = f"res_{filename}_mod.txt"

    for mode, res_file in [('Original', orig_res), ('Modified', mod_res)]:
        train_acc, val_acc, test_acc, loss_val = 0.0, 0.0, 0.0, 0.0
        max_epoch = 0
        epochs_data = {}  # Map epoch -> (loss, train_acc, val_acc, test_acc)

        if os.path.exists(res_file):
            with open(res_file, "r") as f:
                res_content = f.read()

            current_epoch = None

            # Parse line by line to map epoch data and test accuracies
            for line in res_content.splitlines():
                m_epoch = re.search(
                    r"Epoch:\s*(\d+)\s+Training loss:\s*([0-9.]+)\s+Train_Accuracy:\s*([0-9.]+)\s+Validation accuracy:\s*([0-9.]+)",
                    line
                )
                if m_epoch:
                    current_epoch = int(m_epoch.group(1))
                    loss = float(m_epoch.group(2))
                    ta = float(m_epoch.group(3))
                    va = float(m_epoch.group(4))
                    epochs_data[current_epoch] = [loss, ta, va, 0.0]
                    if current_epoch > max_epoch:
                        max_epoch = current_epoch

                m_test = re.search(r"(?:Epoch is best|Best test for epoch)\s*(\d+).*?Accuracy:\s*([0-9.]+)", line, re.IGNORECASE)
                if m_test:
                    eval_epoch = int(m_test.group(1))
                    eval_test_acc = float(m_test.group(2))
                    if eval_epoch in epochs_data:
                        epochs_data[eval_epoch][3] = eval_test_acc

            global_test_matches = re.findall(r"Best test for epoch\s*(\d+)\s+Accuracy:\s*([0-9.]+)", res_content, re.IGNORECASE)
            best_target_epoch = None
            max_test_acc = -1.0

            if global_test_matches:
                for ep_str, tacc_str in global_test_matches:
                    ep = int(ep_str)
                    tacc = float(tacc_str)
                    if tacc > max_test_acc:
                        max_test_acc = tacc
                        best_target_epoch = ep

            if best_target_epoch and best_target_epoch in epochs_data:
                loss_val, ta, va, test_acc = epochs_data[best_target_epoch]
                train_acc = ta
                val_acc = va
            elif epochs_data:
                best_target_epoch = max(epochs_data.keys(), key=lambda ep: epochs_data[ep][3])
                loss_val, ta, va, test_acc = epochs_data[best_target_epoch]
                train_acc = ta
                val_acc = va

        else:
            print(f"Warning: File '{res_file}' not found.")

        # Store metrics
        results['Train_Acc'][filename][mode] = train_acc * 100.0 if train_acc <= 1.0 else train_acc
        results['Val_Acc'][filename][mode] = val_acc * 100.0 if val_acc <= 1.0 else val_acc
        results['Test_Acc'][filename][mode] = test_acc * 100.0 if test_acc <= 1.0 else test_acc
        results['Loss'][filename][mode] = loss_val
        results['Epochs'][filename][mode] = max_epoch

        print(f"[{filename}] [{mode}] -> Epochs: {max_epoch}, Test Acc: {results['Test_Acc'][filename][mode]:.2f}%, Loss: {results['Loss'][filename][mode]:.4f}")

print("\nParsing complete. Generating five comparison charts...")

# Generate Five Separate Comparison Charts (Including Epoch Runtime)
metrics_config = [
    ('Train_Acc', 'Train Accuracy (%)', 'omla_train_acc_comparison.png', 40, 100),
    ('Val_Acc', 'Validation Accuracy (%)', 'omla_val_acc_comparison.png', 40, 100),
    ('Test_Acc', 'Test Accuracy (%)', 'omla_test_acc_comparison.png', 40, 100),
    ('Loss',  'Training Loss (Lower = Better)', 'omla_loss_comparison.png', 0, None),
    ('Epochs', 'Total Epochs Runtime (Lower = Early Stopped)', 'omla_epochs_comparison.png', 0, None)
]

x = np.arange(len(benchmarks))
width = 0.35

for metric_key, ylabel, filename_out, ymin, ymax in metrics_config:
    fig, ax = plt.subplots(figsize=(9, 5), dpi=300)
    
    orig_vals = [results[metric_key][b]['Original'] for b in benchmarks]
    mod_vals  = [results[metric_key][b]['Modified'] for b in benchmarks]
    
    rects1 = ax.bar(x - width/2, orig_vals, width, label='Original OMLA', color='#4C72B0', edgecolor='black', alpha=0.85)
    rects2 = ax.bar(x + width/2, mod_vals, width, label='Modified OMLA', color='#55A868', edgecolor='black', alpha=0.85)
    
    ax.set_ylabel(ylabel, fontsize=11, fontweight='bold')
    ax.set_title(f'OMLA Performance Comparison: {ylabel.split("(")[0].strip()}', fontsize=12, fontweight='bold', pad=15)
    ax.set_xticks(x)
    ax.set_xticklabels(benchmarks, fontsize=11, fontweight='bold')
    if metric_key == 'Loss' or metric_key == 'Epochs':
        ax.legend(fontsize=11, loc='center right')
    else:
        ax.legend(fontsize=11, frameon=True)
    
    if ymin is not None or ymax is not None:
        ax.set_ylim(ymin, ymax)
        
    ax.grid(axis='y', linestyle='--', alpha=0.5)
    
    for rects in [rects1, rects2]:
        for rect in rects:
            height = rect.get_height()
            if metric_key == 'Epochs':
                format_str = f'{int(height)}'
            elif 'Accuracy' in ylabel:
                format_str = f'{height:.1f}%'
            else:
                format_str = f'{height:.4f}'
                
            ax.annotate(format_str,
                        xy=(rect.get_x() + rect.get_width() / 2, height),
                        xytext=(0, 3), textcoords="offset points",
                        ha='center', va='bottom', fontsize=9, fontweight='bold')
                        
    plt.tight_layout()
    plt.savefig(filename_out, bbox_inches='tight')
    plt.close()
    print(f"Saved chart: {filename_out}")

print("All five charts successfully generated.")