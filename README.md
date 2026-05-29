# Training-Free Post-Disaster Damage Estimation

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository contains the code, data, and models for the paper:
**"Training-Free Post-Disaster Damage Estimation with Incomplete Satellite Images by Integrating Open Data and Fractional Hot Deck Imputation"**

## 📖 Overview
Analyzing satellite imagery is an essential step after a severe natural disaster for monitoring the level of damage and making the best decision. This repository provides the code and data for a fast post-disaster damage framework incorporating the remote sensing of imagery, entropy calculation, object detection using an advanced machine learning (ML) model, and missing data curation. The present framework includes a combination of open-source data for high-resolution imagery, digital elevation model (DEM), building footprint, and dual-polarization synthetic aperture radar (SAR) components. 

For damage estimation at the building level, the first phase of the proposed framework is feature collection from open-source platforms. This is followed by the entropy difference calculation ($\Delta H$) between the pre-disaster and post-disaster imagery. These collected features are essential for predicting real-world scenarios where data may be missed, for example, by massive cloud cover after the disaster, which prevents the estimation of the damage level by satellite. 

In the current study, missing values were simulated in the target variable ($\Delta H$), followed by curing and imputation methods for predicting the missing values. The imputation methods used in this study are the Fractional Hot Deck Imputation (FHDI) and Fully Efficient Fractional Imputation (FEFI), with a Naïve method and a Deep Learning (DL) model used for validation. The selected study area is Lake Charles, Louisiana, which was impacted by the severe Hurricane Laura (2020).

---

## 📂 Repository Structure

The code and data are organized to directly map to the 4-step framework outlined in the paper's methodology:

### Step 1: Multi-modal and Multiphysics Data Generation
*   **[Google Earth Engine (GEE)] `GEE_Sentinel1_SAR_Extraction.js` — Google Earth Engine script used to extract Sentinel-1 Synthetic Aperture Radar (SAR) dual-polarization (VV/VH) pre- and post-disaster data.
*   **[Digital Elevation Model (DEM)](https://maps.ga.lsu.edu/lidar2000/#3009354ne):** Provides the elevation value ($z$) for each grid cell (Source: Louisiana Statewide Lidar GIS agencies).
*   **[Microsoft Building Footprints (GMOB)](https://github.com/microsoft/USBuildingFootprints):** Provides building footprints used to calculate the Building Area Ratio (BAR) per cell.
*   **[OpenStreetMap (OSM) / overpass-turbo](https://overpass-turbo.eu/):** Provides supplementary spatial infrastructures and city boundaries.
*   *(Note: All spatial features are extracted, clipped, and merged to generate **File 1**).*

### Step 2: Rapid Damage Estimation
*   `Images/` — Directory for pre- and post-disaster satellite images (Download required).
*   `Coordinate Transformation.ipynb` — Coordinate Transformation script.
*   `Entropy-Damage Detection.ipynb` — Damage Detection Logic: Calculates the $\Delta H$ index and applies DeepLabV3 filtering (Generates **File 2**).

### Step 3: Data Integration
*   `Generating the Final File.ipynb` — Runs closest coordinate checking (KDTree) to assign features from File 1 to File 2.
*   `Final File.csv` — The **Final File** containing the merged damage indices and spatial features.

### Step 4: Missing Data Recovery
*   `Missing data recovery.R` — Identifies missing data and runs Fractional Hot Deck Imputation (FHDI) and Fully Efficient Fractional Imputation (FEFI).
*   `DL_Baseline_Model.ipynb` — Deep Learning model used as a validation baseline.
*   `Plot_AME_Results.py` — Python script used to plot the Absolute Mean Error (AME) results (Figure 5) across all imputation methods.

---

## ⚙️ Installation & Requirements

### Python Dependencies
The Python pipeline (image processing, spatial KDTree merges, and Deep Learning validation) requires Python 3.9+. Please ensure the following key packages are installed in your environment:
* `jupyter`, `pandas`, `numpy`, `matplotlib`, `scipy`, `scikit-learn`, `opencv-python`, `torch`, `torchvision`, `tensorflow`, `scikeras`

### R Dependencies
The fractional imputation scripts require R. Please ensure you have the `FHDI` package installed:
```R
install.packages("FHDI")
```

---
## 📝 Citation
Our paper is currently under review (invited for second review) at *Scientific Reports*. If you find this code or framework useful in your research, please consider citing our paper:

```bibtex
@article{abuoliem2026,
  title={Training-Free Post-Disaster Damage Estimation with Incomplete Satellite Images by Integrating Open Data and Fractional Hot Deck Imputation},
  author={Abuoliem, Dima and Ardiles-Cruz, Erika and Ceylan, Halil and Kim, Sunghwan and Kim, Jae Kwang and Cho, In},
  journal={Scientific Reports},
  year={2026},
  note={Under review (Invited for second review)}
}
```

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
