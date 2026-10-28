![NomeBadge](https://img.shields.io/badge/ORCID.ID-0009.0002.2993.6083-green?logo=ORCID)
![NomeBadge](https://img.shields.io/badge/DOI-XX.X/zenodo-blue?) 

![NomeBadge](https://img.shields.io/badge/license-MIT-blue?) ![NomeBadge](https://img.shields.io/badge/license/DATA-CCBY4.0-blue?) ![NomeBadge](https://img.shields.io/badge/script-100%25-blue?logo=R)



# technical-courier-survival-dataset

Official dataset and resources for the paper: "Predicting Delivery Failures in Technical Courier Services: A Survival Learning Approach for Sustainable Last-Mile Logistics".

## 🔭 Overview

This repository contains the complete R source code, statistical analysis pipeline, and machine learning framework used to generate the synthetic dataset (*N* = 60,000) **and to derive all empirical evaluations, survival benchmarks, and results presented in the paper**: *"Predicting Delivery Failures in Technical Courier Services: A Survival Learning Approach for Sustainable Last-Mile Logistics"*.
The codebase is engineered for predictive modeling, delivery failure analysis, inventory depletion tracking, and environmental footprint estimations (CO<sub>2</sub>).
The resulting dataset is provided in both **CSV (`.csv`)** and **Excel (`.xlsx`)** formats within the [`data/`](data/) directory for maximum accessibility, while  the script to generate the synthetic dataset and conducted analyses — including descriptive statistics and survival modeling (**`01-main.R`**, **`02-synthetic_dataset.R`**, **`03-descriptive_analysis.R`**, **`04-survival_analysis.R`**) — are fully detailed within the R script files located in the [`src/`](src/) directory.
* 🎯 **Objective:** This study proposes a dataset and proactive predictive framework based on survival analysis to evaluate and mitigate delivery failure risks in last-mile technical courier services, addressing
operational inefficiency, elevated costs, and redundant emissions.
   * **RQ1.** Which factors exert the greatest influence on the occurrence of failed deliveries in technical courier services?
   * **RQ2.** Are advanced machine learning models capable of accurately predicting the time-dependent risk of delivery failure prior to service execution?
   * **RQ3.** What extent can predictive analytics enhance the sustainability of logistics operations by reducing failed deliveries and minimizing unnecessary vehicle movements?
* 🚀 **Target Audience:** Technical courier services, operations managers, supervisors and sector scientists.
* 💡 **Key Strengths:** This project bridges logistics management and survival analysis by demonstrating how a scalable dataset survival architecture effectively integrates real-time environmental telemetry and non-linear operational constraints in technical logistics, aiming to reduce carbon emissions and significantly enhance last-mile responsiveness and efficiency.

---

## 📜 License

This repository uses a dual-license structure to separate code from datasets:

- **Source Code** (R/Python scripts for data generation and survival analysis): Licensed under the [MIT License](LICENSE).
- **Dataset** (Synthetic data for reproducibility): Licensed under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/) License.

---

## 💬 How to Cite

If you use this dataset, R script, or the associated methodology in your research, please cite both the paper and the repository:

### 1. Academic Article (IJIEOM / Emerald)
> Garofalo, N. (2026). Predicting Delivery Failures in Technical Courier Services: A Survival Learning Approach for Sustainable Last-Mile Logistics. *International Journal of Industrial Engineering and Operations Management*, Emerald Publishing.
```bibtex
@article{Garofalo2026Paper,
  author       = {Nunziato Garofalo},
  title        = {Predicting Delivery Failures in Technical Courier Services: A Survival Learning Approach for Sustainable Last-Mile Logistics},
  journal      = {International Journal of Industrial Engineering and Operations Management},
  publisher    = {Emerald Publishing},
  year         = {2026},
  doi          = {10.1108/IJIEOM-XX-2026-XXXX}
}
```
---

### 2. Dataset & Software Repository (Zenodo / GitHub)
> Garofalo, N. (2026). *Technical Courier Survival Dataset & Predictive Modeling Framework* (Version 1.0.0) [Data set & Code]. Zenodo. https://doi.org/10.5281/zenodo.XXXXXXX 
> Repository source: https://github.com/NunziatoGarofalo/technical-courier-survival-dataset
```bibtex
@misc{Garofalo2026Dataset,
  author       = {Nunziato Garofalo},
  title        = {Technical Courier Survival Dataset \& Predictive Modeling Framework},
  year         = {2026},
  publisher    = {Zenodo},
  version      = {1.0.0},
  doi          = {10.5281/zenodo.XXXXXXX},
  url          = {[https://doi.org/10.5281/zenodo.XXXXXXX](https://doi.org/10.5281/zenodo.XXXXXXX)}
}
```

---

## 📊 Dataset & Variable Description

Below is the exhaustive mathematical and operational specification for every feature generated within the dataset.

### 1. Primary Identifiers & Geography

- **`ID_Delivery_Order`** (*Categorical / String*)  
  Unique 7-digit zero-padded order identifier generated via sampling without replacement.

- **`City`** (*Categorical*)  
  Synthetic municipality name formatted as `<City>_<Province>_<ID>`.

- **`Postal_Code`** (*Categorical*)  
  5-digit synthetic Italian postal code (`CAP`).

- **`Province`** (*Categorical*)  
  Two-letter Italian provincial code sampled from a master pool of 107 official administrative codes.

- **`Street_Address`** (*Categorical*)  
  Synthetic street address combining street numbers and major Italian street naming conventions.

- **`ZTL_Restriction`** (*Binary / Categorical*)  
  Indicates whether the address falls within a Limited Traffic Zone (*ZTL in Italy*).

---

### 2. Temporal & Scheduling Features

- **`Order_Creation_Date`** (*Date*)  
  Order placement date sampled uniformly across valid working days (excluding Sundays) in calendar year 2025.

- **`Contact_Date`** (*Date*)  
  Date of customer contact, modeled as a discrete stochastic lag.

- **`Delivery_Date`** (*Date*)  
  Scheduled delivery date post customer contact.

- **`Day_OfWeek`** (*Categorical*)  
  Standardized day-of-week string extracted from `Delivery_Date`.

- **`Delivery_Time_Slot`** (*Categorical*)  
  Scheduled window (`08:00–13:00`, `14:00–18:00` on weekdays; adjusted `08:00–12:00` window for 45% of Saturday deliveries).

- **`Exact_Delivery_Date`** (*Date*)  
  Exact delivery date execution incorporating operational delays.

- **`Exact_Delivery_Time`** (*Time String*)  
  Exact arrival time modeled within the time slot duration via a Poisson process.

---

### 3. Customer Communication Features

- **`Contact_Attempts`** (*Discrete Integer*)  
  Number of contact attempts prior to scheduling.

- **`Contact_Time_Slot`** (*Categorical*)  
  Assigned customer contact window (`09:00–13:00`, `15:00–19:00`).

- **`Exact_Contact_Time`** (*Time String*)  
  Exact time of contact customer according contact time slot scheduled.

- **`Appointment_Confirmation_Received`** (*Categorical*)  
  Indicates whether the delivery appointment was confirmed (`"YES"`, `"NOT"`, `"NOT_ORGANIZED"`).

---

### 4. Product, Inventory & Operational Specifications

- **`Product_Size`** (*Categorical*)  
  Package dimension tier (`"Small"`, `"Medium"`, `"Large"`, `"Bulky"`).

- **`Product_Item`** (*Categorical*)  
  Specific product item description mapped conditionally to `Product_Size`.

- **`Service_Type`** (*Categorical*)  
  Service level requested: `"Delivery Only"` (35%) vs. `"Delivery & Installation"` (65%).

- **`Personnel_Required`** (*Discrete Integer*)  
  Delivery crew size required (1 or 2 operators), conditioned on size tier and service complexity.

- **`Product_Code`** (*Categorical*)  
  SKU identifier sampled from 100 pooled codes per size tier (e.g., `SKU-S-001`).

- **`Stock_Quantity`** (*Discrete Non-negative Integer*)  
  Dynamic inventory balance per SKU updated chronologically over order creation dates.

---

### 5. Environmental & Exogenous Factors

- **`Temperature_C`** (*Continuous Numeric*)  
  Ambient microclimate temperature (°C) synthesized using regional baselines, seasonal monthly offsets, diurnal peak hour adjustments, and Gaussian noise.

---

### 6. Operational Failure & Outcome Mechanisms

- **`Censorship_Indicator`** (*Binary*)  
  Administrative cutoff indicator for survival/event-history analysis: 0 if the record falls in the last 25% chronologically (Right-Censored), and 1 otherwise (Fully Observed).

- **`Delivery_Status`** (*Categorical*)  
  Final operational outcome (`"Successful"`, `"Failed"`, `"Censored"`).

- **`Failure_Reason`** (*Categorical*)  
  Root cause classification assigned dynamically based on thermal stress conditions, stockouts, ZTL permit status, and operational constraints.

- **`Technical_Installation_Detail`** (*Categorical*)  
  Detailed failure cause for installation issues.

---

### 7. Distances, Workload & Carbon Footprint

- **`Delivery_Distance_KM`** (*Continuous Numeric*)  
  Distance from local hub to customer destination, modeled via truncated normal distribution.

- **`Delivery_Distance_HUB_Km`** (*Continuous Numeric*)  
  Extra distance from central HUB to customer when a faillure recorded.

- **`kgCO2`** (*Continuous Numeric*)  
  Estimated carbon emissions (kg CO<sub>2</sub>) based on vehicle mileage and return trips due to failed road deliveries (baseline emission factor E = 0.257kg CO<sub>2</sub>\km).

- **`Cumulative_Completed_Deliveries`** (*Discrete Integer*)  
  Driver workload progression within time slot modeled via a dynamic Poisson.

- **`Prior_Address_Failures`** (*Discrete Non-negative Integer*)  
  Sequential historical failure count per unique street address up to order creation time.
---

## 🔎 Data Preview

Below is an extract showing a complete sample record with all 33 columns generated by the R script:

| ID_Delivery_Order | Order_Creation_Date | Censorship_Indicator | City | Postal_Code | Province | Street_Address | Contact_Date | Contact_Time_Slot | Exact_Contact_Time | Contact_Attempts | Appointment_Confirmation_Received | Delivery_Date | Day_OfWeek | ZTL_Restriction | Delivery_Time_Slot | Exact_Delivery_Date | Exact_Delivery_Time | Cumulative_Completed_Deliveries | Prior_Address_Failures | Product_Size | Product_Item | Service_Type | Personnel_Required | Product_Code | Stock_Quantity | Delivery_Distance_KM | Delivery_Status | Failure_Reason | Technical_Installation_Detail | Delivery_Distance_HUB_Km | kgCO2 | Temperature_C |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **4829104** | 2025-03-12 | 1 | City_MI_124 | 20121 | MI | 45 Garibaldi Street | 2025-03-15 | 09:00-13:00 | 10:15 | 1 | YES | 2025-03-20 | Thursday | Standard Area | 08:00-13:00 | 2025-03-20 | 09:45 | 4 | 0 | Large | Washing Machine | Delivery & Installation | 2 | SKU-L-042 | 54 | 18 | Successful | None | None | 22 | 4.63 | 14.2 |

---

## 🔬 Usage

To replicate the synthetic dataset generation process locally, follow these instructions:

### 1. 🛠️ Prerequisites
Ensure you have [R](https://www.r-project.org/) (version 4.0 or higher recommended) and an IDE such as [RStudio / Posit](https://posit.co/) installed on your system.

### 2. ⚙️ Install Required Dependencies
Open your R console and execute the following command to install the necessary packages.

```R
# --- A. Data Manipulation & IO ---
pkg_data_manipulation <- c("dplyr", "plyr", "tidyverse", "MASS", "writexl", "readxl")

# --- B. Statistical Survival Analysis & Machine Learning ---
pkg_survival_ml       <- c("survival", "survminer", "glmnet", "pec", "ranger", "xgboost", "timeROC", "DALEX")

# --- C. Visualization, Theming & Exploratory Plots ---
pkg_visualization     <- c("ggplot2", "viridis", "ggpubr", "ggcorrplot", "GGally", "gridGraphics", "reshape2")

# --- D. Reporting & Environment Integration ---
pkg_reporting         <- c("xtable", "reticulate")

all_packages <- unique(c(pkg_data_manipulation, pkg_survival_ml, pkg_visualization, pkg_reporting))

# Automated check and installation routine for missing packages
installed_packages <- all_packages %in% rownames(installed.packages())
if (any(!installed_packages)) {
  cat("Installing missing packages...\n")
  install.packages(all_packages[!installed_packages], dependencies = TRUE)
}
```

### 3. 📦 Package Versions Used
To ensure full reproducibility, the analysis was tested with the following package versions:

| Package | Version | Package | Version | Package | Version | Package | Version |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `DALEX` | 2.4.3 | `dplyr` | 1.1.4 | `forcats` | 1.0.1 | `GGally` | 2.1.2 |
| `ggplot2` | 3.4.2 | `ggcorrplot` | 0.1.4.1 | `ggpubr` | 0.6.0 | `glmnet` | 4.1-8 |
| `gridGraphics` | 0.5-1 | `lubridate` | 1.9.3 | `MASS` | 7.3-58.1 | `Matrix` | 1.5-1 |
| `pec` | 2023.04.12 | `plyr` | 1.8.9 | `prodlim` | 2023.08.28 | `purrr` | 1.0.2 |
| `ranger` | 0.16.0 | `readr` | 2.1.5 | `readxl` | 1.4.3 | `reshape2` | 1.4.4 |
| `reticulate` | 1.36.1 | `stringr` | 1.6.0 | `survival` | 3.6-4 | `survminer` | 0.5.1 |
| `tibble` | 3.2.1 | `tidyverse` | 2.0.0 | `tidyr` | 1.3.1 | `timeROC` | 0.4.1 |
| `viridis` | 0.6.5 | `viridisLite` | 0.4.3 | `writexl` | 1.5.0 | `xgboost` | 1.7.7.1 |
| `xtable` | 1.8-8 | | | | | | |

<details>
<summary><b>📦 View Namespace Dependencies (Loaded via Namespace)</b></summary>

For complete low-level reproducibility, here are the additional underlying packages loaded via namespace:

| Package | Version | Package | Version | Package | Version | Package | Version |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `abind` | 1.4-8 | `backports` | 1.4.1 | `broom` | 1.0.13 | `car` | 3.1-5 |
| `carData` | 3.0-6 | `cellranger` | 1.1.0 | `cli` | 3.6.2 | `codetools` | 0.2-18 |
| `compiler` | 4.2.2 | `data.table` | 1.15.4 | `digest` | 0.6.35 | `farver` | 2.1.1 |
| `foreach` | 1.5.2 | `Formula` | 1.2-6 | `future` | 1.33.2 | `future.apply` | 1.10.0 |
| `generics` | 0.1.4 | `globals` | 0.20.0 | `glue` | 1.7.0 | `gridExtra` | 2.3.1 |
| `ggsignif` | 0.6.4 | `gtable` | 0.3.6 | `hms` | 1.1.4 | `iterators` | 1.0.14 |
| `jsonlite` | 1.8.8 | `km.ci` | 0.5-6 | `KMsurv` | 0.1-6 | `knitr` | 1.42 |
| `lattice` | 0.20-45 | `lava` | 1.8.1 | `lifecycle` | 1.0.5 | `listenv` | 1.1.0 |
| `magrittr` | 2.0.3 | `mvtnorm` | 1.2-4 | `numDeriv` | 2016.8-1.1 | `parallel` | 4.2.2 |
| `parallelly` | 1.37.1 | `pillar` | 1.11.1 | `pkgconfig` | 2.0.3 | `png` | 0.1-8 |
| `R6` | 2.6.1 | `RColorBrewer` | 1.1-3 | `Rcpp` | 1.0.12 | `reshape` | 0.8.10 |
| `rlang` | 1.1.3 | `rstatix` | 0.7.3 | `rstudioapi` | 0.19.0 | `scales` | 1.4.0 |
| `shape` | 1.4.6.1 | `splines` | 4.2.2 | `stringi` | 1.8.3 | `survMisc` | 0.5.6 |
| `timechange` | 0.3.0 | `timereg` | 2.0.5 | `tidyselect` | 1.2.1 | `tools` | 4.2.2 |
| `tzdb` | 0.4.0 | `vctrs` | 0.6.5 | `withr` | 3.0.3 | `xfun` | 0.43 |
| `zoo` | 1.8-12 | | | | | | |

</details>

### 4. ⚙️ Setting a Random Seed
To ensure full reproducibility of the synthetic dataset generation and any randomized algorithms (such as machine learning models), specific `set.seed()` calls have been embedded directly into the execution flow of the script:

```R
# Example of global seed initialization within the workflow
set.seed(123456789)
# Example of local seed initialization within the workflow
set.seed(1276)
```

### 5. 🖥️ Running the Complete Pipeline with Automated Master Script
To make replication effortless, the project is structured as an automated pipeline orchestrated by a single master script. 
Open your R project workspace, set it to the root directory of the repository, and execute the **`01-main.R`** (see [`src/01-main.R`](src/01-main.R)).
The master script is fully automated: it will automatically check for any missing packages, install them along with their dependencies, set the global random seed, and sequentially orchestrate the entire pipeline:

```R
# Execute the complete end-to-end pipeline automatically
source("01-main.R")
```
---

## 📚 References & Dependencies

This project builds upon established statistical and machine learning methodologies for survival analysis, as well as several open-source R and Python packages. 
For a complete and detailed list of all theoretical literature and software dependencies used throughout the analysis, please refer to the [REFERENCES.md](REFERENCES.md) file.







