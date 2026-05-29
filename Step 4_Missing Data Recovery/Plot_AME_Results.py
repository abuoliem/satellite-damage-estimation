import matplotlib.pyplot as plt
import numpy as np

# ---------------------------------------------------------
# DATA INPUTS (From "Compare missing rate.xlsx" and R output)
# ---------------------------------------------------------
missing_rates = np.array([10, 20, 30, 40, 50])

# --- Figure 5(c) Data: AAME (%) & Standard Deviation (Sigma) ---
# Note: Values are percentages (e.g., 5.11%)
fhdi_aame = np.array([4.87, 4.72, 4.77, 4.86, 4.84])
fhdi_sigma = np.array([0.0604, 0.0589, 0.0579, 0.0569, 0.0559])

fefi_aame = np.array([4.87, 4.72, 4.77, 4.86, 4.84])
fefi_sigma = np.array([0.0603, 0.0589, 0.0579, 0.0569, 0.0559])

naive_aame = np.array([5.30, 5.31, 5.30, 5.33, 5.29])
naive_sigma = np.array([0.0586, 0.0544, 0.0513, 0.0473, 0.0434])

# Placeholder for DL based on manuscript (~10%). Update with actual DL data!
dl_aame = np.array([5.46, 5.43, 5.18, 5.22, 5.20]) 
dl_sigma = np.array([0.0316, 0.0354, 0.0348, 0.0340, 0.0334])

# --- Figure 5(d) Data: Standard Error (SE) ---
fhdi_se = np.array([0.0028, 0.0019, 0.0016, 0.0013, 0.0012])
fefi_se = np.array([0.0028, 0.0019, 0.0016, 0.0013, 0.0012])

# --- Figure 5(e) Data: Random vs Contiguous AAME at 10% and 50% ---
# Note: Contiguous results were 0.0510 (5.10%) and 0.0545 (5.45%) from the R script
rates_10_50 = np.array([10, 50])

# We extract the 10% and 50% values
fhdi_random = np.array([fhdi_aame[0], fhdi_aame[4]])
fhdi_random_sigma = np.array([fhdi_sigma[0], fhdi_sigma[4]])

fhdi_contiguous = np.array([5.10, 5.45])
# Exact computed sigma for contiguous clouds from R script
fhdi_contiguous_sigma = np.array([0.060177, 0.057064])

fefi_random = np.array([fefi_aame[0], fefi_aame[4]])
fefi_random_sigma = np.array([fefi_sigma[0], fefi_sigma[4]])

fefi_contiguous = np.array([5.02, 5.43])
# Exact computed sigma for contiguous clouds from R script
fefi_contiguous_sigma = np.array([0.060071, 0.056920])

# --- Figure 5(f) Data: Random vs Contiguous SE at 10% and 50% ---
fhdi_se_random = np.array([fhdi_se[0], fhdi_se[4]])
fefi_se_random = np.array([fefi_se[0], fefi_se[4]])

# Exact computed SE for contiguous clouds from R script
fhdi_se_contiguous = np.array([0.002728, 0.001385])
fefi_se_contiguous = np.array([0.002671, 0.001378])


# ---------------------------------------------------------
# FIGURE 5(c): AAME vs Missing Rate with Sigma Error Bars
# ---------------------------------------------------------
plt.figure(figsize=(8, 6))
# Making FHDI thicker and semi-transparent so FEFI can be seen on top of it when they overlap perfectly
plt.errorbar(missing_rates, fhdi_aame, yerr=fhdi_sigma, fmt='o-', label='FHDI', capsize=5, color='blue', linewidth=4, alpha=0.5)
plt.errorbar(missing_rates, fefi_aame, yerr=fefi_sigma, fmt='s--', label='FEFI', capsize=5, color='green', linewidth=2)
plt.errorbar(missing_rates, naive_aame, yerr=naive_sigma, fmt='^-.', label='Naïve', capsize=5, color='red', linewidth=2)
plt.errorbar(missing_rates, dl_aame, yerr=dl_sigma, fmt='d:', label='Deep Learning (DL)', capsize=5, color='black', linewidth=2)

plt.xlabel('Missing Data Rate (%)', fontsize=14, fontweight='bold')
plt.ylabel('Average Absolute Mean Error (AAME %)', fontsize=14, fontweight='bold')
plt.xticks(missing_rates, fontsize=12)
plt.yticks(fontsize=12)
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend(fontsize=12)
plt.tight_layout()
plt.savefig('fig5c_AAME_vs_MissingRate.png', dpi=300)
plt.close()


# ---------------------------------------------------------
# FIGURE 5(d): Standard Error (SE) vs Missing Rate
# ---------------------------------------------------------
plt.figure(figsize=(8, 6))
plt.plot(missing_rates, fhdi_se, marker='o', label='FHDI', color='blue', linewidth=2, linestyle='-')
plt.plot(missing_rates, fefi_se, marker='s', label='FEFI', color='green', linewidth=2, linestyle='--')

plt.xlabel('Missing Data Rate (%)', fontsize=14, fontweight='bold')
plt.ylabel('Standard Error (SE)', fontsize=14, fontweight='bold')
plt.xticks(missing_rates, fontsize=12)
plt.yticks(np.arange(0, 0.004, 0.001), fontsize=12)
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend(fontsize=12)
plt.tight_layout()
plt.savefig('fig5d_SE_vs_MissingRate.png', dpi=300)
plt.close()


# ---------------------------------------------------------
# FIGURE 5(e): Random vs Contiguous Gap Comparison (Line Plot)
# ---------------------------------------------------------
plt.figure(figsize=(8, 6))

# Thicker transparent line for FHDI Random so FEFI Random (dashed) shows on top
plt.errorbar(rates_10_50, fhdi_random, yerr=fhdi_random_sigma, fmt='o-', label='FHDI (Random)', capsize=5, color='blue', linewidth=4, alpha=0.5)
plt.errorbar(rates_10_50, fefi_random, yerr=fefi_random_sigma, fmt='s--', label='FEFI (Random)', capsize=5, color='green', linewidth=2)

# Solid red for FHDI contiguous, dashed orange for FEFI contiguous
plt.errorbar(rates_10_50, fhdi_contiguous, yerr=fhdi_contiguous_sigma, fmt='o-', label='FHDI (Contiguous Clouds)', capsize=5, color='red', linewidth=2)
plt.errorbar(rates_10_50, fefi_contiguous, yerr=fefi_contiguous_sigma, fmt='s--', label='FEFI (Contiguous Clouds)', capsize=5, color='orange', linewidth=2)

plt.xlabel('Missing Data Rate (%)', fontsize=14, fontweight='bold')
plt.ylabel('Average Absolute Mean Error (AAME %)', fontsize=14, fontweight='bold')
plt.xticks(rates_10_50, fontsize=12, fontweight='bold')
plt.yticks(fontsize=12)
plt.legend(fontsize=12, loc='upper left')
plt.grid(True, linestyle='--', alpha=0.7)
plt.tight_layout()
plt.savefig('fig5e_Random_vs_Contiguous_LinePlot.png', dpi=300)
plt.close()


# ---------------------------------------------------------
# FIGURE 5(e): Random vs Contiguous SE Comparison (Bar Chart)
# ---------------------------------------------------------
x = np.arange(len(rates_10_50))
width = 0.2  # Width of bars

plt.figure(figsize=(8, 6))

rects1 = plt.bar(x - 1.5*width, fhdi_se_random, width, label='FHDI (Random)', color='blue', alpha=0.7)
rects2 = plt.bar(x - 0.5*width, fhdi_se_contiguous, width, label='FHDI (Contiguous Clouds)', color='red')
rects3 = plt.bar(x + 0.5*width, fefi_se_random, width, label='FEFI (Random)', color='green', alpha=0.7)
rects4 = plt.bar(x + 1.5*width, fefi_se_contiguous, width, label='FEFI (Contiguous Clouds)', color='orange')

# Add values on top of bars
plt.bar_label(rects1, fmt='%.4f', padding=3, fontsize=9)
plt.bar_label(rects2, fmt='%.4f', padding=3, fontsize=9)
plt.bar_label(rects3, fmt='%.4f', padding=3, fontsize=9)
plt.bar_label(rects4, fmt='%.4f', padding=3, fontsize=9)

plt.xlabel('Missing Data Scenario', fontsize=14, fontweight='bold')
plt.ylabel('Standard Error (SE)', fontsize=14, fontweight='bold')
plt.xticks(x, ['10% Missing Rate', '50% Missing Rate'], fontsize=12, fontweight='bold')
plt.yticks(np.arange(0, 0.004, 0.001), fontsize=12)
plt.legend(fontsize=12, loc='upper right')
plt.grid(axis='y', linestyle='--', alpha=0.7)
plt.tight_layout()
plt.savefig('fig5f_SE_Random_vs_Contiguous_BarChart.png', dpi=300)
plt.close()

print("Success! Generated fig5c, fig5d, fig5e, and fig5f plots.")
