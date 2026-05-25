# Training-Free Post-Disaster Damage Estimation

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository contains the code, data, and models for the paper:
**"Training-Free Post-Disaster Damage Estimation with Incomplete Satellite Images by Integrating Open Data and Fractional Hot Deck Imputation"**

## 📖 Overview
Rapid and accurate building damage assessment is critical for post-disaster emergency response. This project introduces a novel, training-free framework that:
1. Utilizes **Shannon Entropy Difference ($\Delta H$)** between pre- and post-disaster satellite imagery to identify structural damage.
2. Integrates with pre-trained semantic segmentation models (DeepLabV3) to isolate damage signals and filter out environmental noise.
3. Addresses the critical issue of missing data (e.g., due to dense cloud cover) by employing advanced statistical imputation methods, specifically **Fractional Hot Deck Imputation (FHDI)** and **Fully Efficient Fractional Imputation (FEFI)**.

The framework is tested on varied real-world disaster scenarios, including Hurricane Laura (Lake Charles, Louisiana).

---

## 📂 Repository Structure

```text
├── images/                                       # Pre- and post-disaster satellite images
├── merged_x_prime_y_prime_with_features.csv      # Processed feature dataset
├── entropy-primary work_50.ipynb                 # Jupyter Notebook: Calculates $\Delta H$, applies DeepLabV3, and simulates cloud cover
├── FHDI_FEFI_NAIVE_5times.R                      # R script for running FHDI/FEFI imputation with random missingness
└── README.md
```

---

## ⚙️ Installation & Requirements

### Python Dependencies
The image processing and entropy calculations are performed in a Jupyter Notebook using Python 3.9+. Please ensure the following key packages are installed in your environment:
* `jupyter`, `pandas`, `numpy`, `matplotlib`, `scikit-learn`, `opencv-python`, `torch`, `torchvision`

### R Dependencies
The fractional imputation scripts require R. Please ensure you have the `FHDI` package installed:
```R
install.packages("FHDI")
```

---

## 🚀 Quick Start / Usage

### 1. Entropy Calculation & Data Preparation
Open and run the Jupyter Notebook to calculate $\Delta H$, apply the DeepLabV3 filter, and prepare the dataset:
```bash
jupyter notebook "entropy-primary work_50.ipynb"
```

### 2. Run Imputation
Run the R script to apply random missingness and evaluate FHDI, FEFI, and Naïve imputation methods:
```bash
Rscript FHDI_FEFI_NAIVE_5times.R
```

---

## 💾 Data Availability
*   **Raw Images:** Pre- and post-disaster satellite imagery (from Maxar Technologies and NOAA) are included in the `images/` directory.
*   **Feature Dataset:** The fully processed numerical features used for the imputation experiments are provided directly in the file `merged_x_prime_y_prime_with_features.csv`.
*   **Source:** The original satellite imagery and building footprints were sourced from the Maxar Open Data Program, NOAA, and Microsoft Building Footprints.

---

## 📝 Citation
Our paper is currently under review (invited for second review) at *Scientific Reports*. If you find this code or framework useful in your research, please consider citing our paper:

```bibtex
@article{abuoliem2026,
  title={Training-Free Post-Disaster Damage Estimation with Incomplete Satellite Images by Integrating Open Data and Fractional Hot Deck Imputation},
  author={Abuoliem, Dima and Ardiles-Cruz, Erika and Ceylan, Halil and Kim, Sunghwan and Kim, Jae Kwang and Cho, In Ho},
  journal={Scientific Reports},
  year={2026},
  note={Under review (Invited for second review)}
}
```

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
