![NomeBadge](https://img.shields.io/badge/ORCID%20ID-0009–0002–2993–6083-green?logo=ORCID)
![NomeBadge](https://img.shields.io/badge/DOI-XX.X/zenodo-blue?) 
![NomeBadge](https://img.shields.io/badge/license-MIT-blue?) ![NomeBadge](https://img.shields.io/badge/license—DATA-CC%20BY%204.0-blue?) 
![NomeBadge](https://img.shields.io/badge/github-repo-blue?logo=github) ![NomeBadge](https://img.shields.io/badge/script-100%25-blue?logo=R)



# technical-courier-survival-dataset

Official dataset and resources for the paper: *"Predicting Delivery Failures in Technical Courier Services: A Survival Learning Approach for Sustainable Last-Mile Logistics"*; an Original Research Article published by Emerald Publishing: International Journal ....

![NomeBadge](https://img.shields.io/badge/EmeraldPublishing—DOI-XX.X/-green?)

## 🔭 Overview

This repository contains the complete R source code, statistical analysis pipeline, and machine learning framework used to generate the synthetic dataset (*N* = 60,000) **and to derive all empirical evaluations, survival benchmarks, and results presented in the paper**: *"Predicting Delivery Failures in Technical Courier Services: A Survival Learning Approach for Sustainable Last-Mile Logistics"*.
The codebase is engineered for predictive modeling, delivery failure analysis, inventory depletion tracking, and environmental footprint estimations (CO<sub>2</sub>).
The resulting dataset is provided in both **CSV (`.csv`)** and **Excel (`.xlsx`)** formats within the [`data/`](data/) directory for maximum accessibility, while  the script to generate the synthetic dataset and conducted analyses — including descriptive statistics and survival modeling (**`01-main.R`**, **`02-synthetic_dataset.R`**, **`03-descriptive_analysis.R`**, **`04-survival_analysis.R`**, **`05-multy_level_stress_testing_and_sensitivity_analysis.R`**) — are fully detailed within the R script files located in the [`src/`](src/) directory.
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
- **Dataset** (Synthetic data for reproducibility): Licensed under the [Creative Commons Attribution 4.0 International (CC BY 4.0) License](https://creativecommons.org/licenses/by/4.0/).

---

## 💬 How to Cite

If you use this dataset, R script, or the associated methodology in your research, please cite both the paper and the repository:

### 1. Original Research Article (IJIEOM / Emerald)
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

<details>
<summary><b>1. ✨View Primary Identifiers & Geography Features</b></summary>
<br>
<p>Overview of identification and spatial features along with their generative models:</p>
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse: collapse; width: 100%; table-layout: fixed;">
  <colgroup>
    <col style="width: 22%;">
    <col style="width: 10%;">
    <col style="width: 33%;">
    <col style="width: 35%;">
  </colgroup>
  <thead>
    <tr style="background-color: #f2f2f2;">
      <th style="padding: 6px 8px;">Variable Name </th>
      <th style="padding: 6px 8px;">Type</th>
      <th style="padding: 6px 8px;">Description</th>
      <th style="padding: 6px 8px;">Mathematical / Statistical Model (Derivation)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="padding: 4px 8px;"><code>ID_Delivery_Order</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Unique delivery order identifier (zero-padded 7-digit format).</td>
      <td style="padding: 4px 8px;">Discrete uniform random sampling without replacement from integer space [0, 9999999] combined with zero-padding string formatting: ID = sprintf("%07d", X).</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>City</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Destination city based on the Italian reference pool.</td>
      <td style="padding: 4px 8px;">Stochastic string concatenation of provincial prefixes with a uniformly sampled integer index ranging from 1 to 500.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Postal_Code</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Associated postal code (5-digit ZIP code).</td>
      <td style="padding: 4px 8px;">Discrete uniform sampling from the integer range [10000, 99999] mapped to zero-padded 5-digit strings.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Province</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Italian provincial administrative code (e.g., MI, RM, NA).</td>
      <td style="padding: 4px 8px;">Discrete uniform random sampling with replacement from a master pool of 107 official administrative codes.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Street_Address</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Simulated street address and street name.</td>
      <td style="padding: 4px 8px;">Cartesian combination of uniform random integers [1, 300] and categorical sampling from a predefined pool of major Italian street names.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>ZTL_Restriction</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Limited Traffic Zone regulatory status (ZTL / Standard Area).</td>
      <td style="padding: 4px 8px;">Bernoulli trial (Binomial process) with fixed success probability p = 0.35 for restricted regulatory zones and 0.65 for standard areas.</td>
    </tr>
  </tbody>
</table>
</details>

<details>
<summary><b>2. ✨View Temporal & Scheduling Features</b></summary>
<br>
<p>Overview of temporal tracking and operational scheduling variables:</p>
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse: collapse; width: 100%; table-layout: fixed;">
  <colgroup>
    <col style="width: 22%;">
    <col style="width: 10%;">
    <col style="width: 33%;">
    <col style="width: 35%;">
  </colgroup>
  <thead>
    <tr style="background-color: #f2f2f2;">
      <th style="padding: 6px 8px;">Variable Name </th>
      <th style="padding: 6px 8px;">Type</th>
      <th style="padding: 6px 8px;">Description</th>
      <th style="padding: 6px 8px;">Mathematical / Statistical Model (Derivation)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="padding: 4px 8px;"><code>Order_Creation_Date</code></td>
      <td style="padding: 4px 8px;">Date</td>
      <td style="padding: 4px 8px;">Order creation date (year 2025, excluding Sundays).</td>
      <td style="padding: 4px 8px;">Uniform discrete temporal sampling across all working days of calendar year 2025 (filtering out day-of-week index corresponding to Sundays).</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Contact_Date</code></td>
      <td style="padding: 4px 8px;">Date</td>
      <td style="padding: 4px 8px;">Customer contact date for planning (1-5 working days lag).</td>
      <td style="padding: 4px 8px;">Stochastic forward lag modeled via uniform discrete sampling on interval [1, 5] days, with weekend adjustment shift to Monday.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Delivery_Date</code></td>
      <td style="padding: 4px 8px;">Date</td>
      <td style="padding: 4px 8px;">Scheduled delivery date.</td>
      <td style="padding: 4px 8px;">Stochastic forward lag modeled via uniform discrete sampling on interval [1, 7] days post-contact, with weekend adjustment shift to Monday.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Exact_Delivery_Date</code></td>
      <td style="padding: 4px 8px;">Date</td>
      <td style="padding: 4px 8px;">Actual execution date of delivery (incorporating operational lag).</td>
      <td style="padding: 4px 8px;">Stochastic perturbation offset sampled from discrete distribution with probabilities P(Δ = 0) = 0.80, P(Δ = 1) = 0.15, P(Δ = 2) = 0.05.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Day_OfWeek</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Day of the week for delivery (standardized in English).</td>
      <td style="padding: 4px 8px;">Deterministic string extraction from <code>Delivery_Date</code> mapped via an English-Italian localization dictionary.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Delivery_Time_Slot</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Planned delivery time window (handling Saturday constraints).</td>
      <td style="padding: 4px 8px;">Conditional categorical assignment with specialized weekend scheduling rules (e.g., restricted 45% probability window for Saturday mornings).</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Exact_Delivery_Time</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Exact arrival time estimated via a Poisson process.</td>
      <td style="padding: 4px 8px;">Homogeneous Poisson process arrival time simulation: offset modeled via t = t_start + ((rpois(lambda = duration / 2)) %% duration).</td>
    </tr>
  </tbody>
</table>
</details>

<details>
<summary><b>3. ✨View Customer Communication Features</b></summary>
<br>
<p>Overview of customer interaction and appointment scheduling metrics:</p>
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse: collapse; width: 100%; table-layout: fixed;">
  <colgroup>
    <col style="width: 22%;">
    <col style="width: 10%;">
    <col style="width: 33%;">
    <col style="width: 35%;">
  </colgroup>
  <thead>
    <tr style="background-color: #f2f2f2;">
      <th style="padding: 6px 8px;">Variable Name </th>
      <th style="padding: 6px 8px;">Type</th>
      <th style="padding: 6px 8px;">Description</th>
      <th style="padding: 6px 8px;">Mathematical / Statistical Model (Derivation)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="padding: 4px 8px;"><code>Contact_Attempts</code></td>
      <td style="padding: 4px 8px;">Integer</td>
      <td style="padding: 4px 8px;">Number of contact attempts made prior to confirmation (1-4).</td>
      <td style="padding: 4px 8px;">Discrete empirical probability distribution: P(X=1) = 0.80, P(X=2) = 0.09, P(X=3) = 0.06, P(X=4) = 0.05.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Contact_Time_Slot</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Scheduled time window for phone contact.</td>
      <td style="padding: 4px 8px;">Discrete uniform sampling from standard communication time slots (<code>09:00-13:00</code>, <code>15:00-19:00</code>).</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Exact_Contact_Time</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Actual contact time (includes a 20% out-of-slot probability).</td>
      <td style="padding: 4px 8px;">Mixture model combining uniform slot-bounded Poisson arrival (80% weight) and anomalous out-of-slot hour sampling (20% weight).</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Appointment_Confirmation_Received</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Appointment confirmation indicator (YES / NOT / NOT_ORGANIZED).</td>
      <td style="padding: 4px 8px;">Conditional state machine based on administrative censoring and failure flags, with Bernoulli trial resolution (P(YES) = 0.85).</td>
    </tr>
  </tbody>
</table>
</details>

<details>
<summary><b>4. ✨View Product, Inventory & Operational Specifications</b></summary>
<br>
<p>Overview of product categories, service requirements, and stock balances:</p>
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse: collapse; width: 100%; table-layout: fixed;">
  <colgroup>
    <col style="width: 22%;">
    <col style="width: 10%;">
    <col style="width: 33%;">
    <col style="width: 35%;">
  </colgroup>
  <thead>
    <tr style="background-color: #f2f2f2;">
      <th style="padding: 6px 8px;">Variable Name </th>
      <th style="padding: 6px 8px;">Type</th>
      <th style="padding: 6px 8px;">Description</th>
      <th style="padding: 6px 8px;">Mathematical / Statistical Model (Derivation)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="padding: 4px 8px;"><code>Product_Size</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Product dimension tier (Small, Medium, Large, Bulky).</td>
      <td style="padding: 4px 8px;">Categorical distribution with empirical probability weights: P(Small) = 0.30, P(Med) = 0.40, P(Large) = 0.20, P(Bulky) = 0.10.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Product_Item</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Specific product description mapped to size tier.</td>
      <td style="padding: 4px 8px;">Stratified conditional categorical sampling mapped strictly to the corresponding <code>Product_Size</code> parent tier.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Service_Type</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Requested service level (Delivery Only vs. Delivery & Installation).</td>
      <td style="padding: 4px 8px;">Bernoulli trial with success probability p = 0.65 for "Delivery & Installation" and 0.35 for "Delivery Only".</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Personnel_Required</code></td>
      <td style="padding: 4px 8px;">Integer</td>
      <td style="padding: 4px 8px;">Required delivery crew size (1 or 2 operators).</td>
      <td style="padding: 4px 8px;">Deterministic logical rules mapping operational complexity, combining service type and package size tier.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Product_Code</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Stock Keeping Unit (SKU) identifier.</td>
      <td style="padding: 4px 8px;">Stratified uniform random sampling from 100 pre-generated unique SKU code pools per dimensional tier (e.g., <code>SKU-S-001</code>).</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Stock_Quantity</code></td>
      <td style="padding: 4px 8px;">Integer</td>
      <td style="padding: 4px 8px;">Dynamic inventory balance per SKU updated chronologically.</td>
      <td style="padding: 4px 8px;">Stochastic inventory balance model: chronological depletion (Stock_t = Stock_{t-1} - 1) with Poisson/uniform replenishment triggers (p = 0.08).</td>
    </tr>
  </tbody>
</table>
</details>

<details>
<summary><b>5. ✨View Environmental & Exogenous Factors</b></summary>
<br>
<p>Overview of ambient environmental parameters:</p>
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse: collapse; width: 100%; table-layout: fixed;">
  <colgroup>
    <col style="width: 22%;">
    <col style="width: 10%;">
    <col style="width: 33%;">
    <col style="width: 35%;">
  </colgroup>
  <thead>
    <tr style="background-color: #f2f2f2;">
      <th style="padding: 6px 8px;">Variable Name </th>
      <th style="padding: 6px 8px;">Type</th>
      <th style="padding: 6px 8px;">Description</th>
      <th style="padding: 6px 8px;">Mathematical / Statistical Model (Derivation)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="padding: 4px 8px;"><code>Temperature_C</code></td>
      <td style="padding: 4px 8px;">Numeric</td>
      <td style="padding: 4px 8px;">Ambient microclimate temperature (°C).</td>
      <td style="padding: 4px 8px;">Additive microclimate model: T = Base_Prov + Offset_Month + Adjustment_Hour + ε, where ε ~ Normal(0, 1.2^2).</td>
    </tr>
  </tbody>
</table>
</details>

<details>
<summary><b>6. ✨View Operational Failure & Outcome Mechanisms</b></summary>
<br>
<p>Overview of censoring, operational status, and failure cause mechanics:</p>
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse: collapse; width: 100%; table-layout: fixed;">
  <colgroup>
    <col style="width: 22%;">
    <col style="width: 10%;">
    <col style="width: 33%;">
    <col style="width: 35%;">
  </colgroup>
  <thead>
    <tr style="background-color: #f2f2f2;">
      <th style="padding: 6px 8px;">Variable Name </th>
      <th style="padding: 6px 8px;">Type</th>
      <th style="padding: 6px 8px;">Description</th>
      <th style="padding: 6px 8px;">Mathematical / Statistical Model (Derivation)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="padding: 4px 8px;"><code>Censorship_Indicator</code></td>
      <td style="padding: 4px 8px;">Integer</td>
      <td style="padding: 4px 8px;">Administrative cutoff indicator for survival/event analysis (0/1).</td>
      <td style="padding: 4px 8px;">Deterministic percentile quantile thresholding based on temporal sorting order (flagging the final chronological 25% as right-censored).</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Delivery_Status</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Final operational outcome (Successful, Failed, Censored).</td>
      <td style="padding: 4px 8px;">Stochastic state machine governed by inventory levels, right-censoring flags, and thermal-stress failure risk thresholds.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Failure_Reason</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Root cause classification for delivery failures.</td>
      <td style="padding: 4px 8px;">Conditional decision tree incorporating stockout status, regulatory ZTL constraints, and temperature-dependent failure probabilities.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Technical_Installation_Detail</code></td>
      <td style="padding: 4px 8px;">String</td>
      <td style="padding: 4px 8px;">Detailed failure cause for installation issues.</td>
      <td style="padding: 4px 8px;">Conditional categorical assignment restricted strictly to records where <code>Failure_Reason == "Technical Installation Issue"</code>.</td>
    </tr>
  </tbody>
</table>
</details>

<details>
<summary><b>7. ✨View Distances, Workload & Carbon Footprint</b></summary>
<br>
<p>Overview of spatial distances, driver workload, carbon emission calculations, and historical address counts:</p>
<table border="1" cellpadding="4" cellspacing="0" style="border-collapse: collapse; width: 100%; table-layout: fixed;">
  <colgroup>
    <col style="width: 22%;">
    <col style="width: 10%;">
    <col style="width: 33%;">
    <col style="width: 35%;">
  </colgroup>
  <thead>
    <tr style="background-color: #f2f2f2;">
      <th style="padding: 6px 8px;">Variable Name </th>
      <th style="padding: 6px 8px;">Type</th>
      <th style="padding: 6px 8px;">Description</th>
      <th style="padding: 6px 8px;">Mathematical / Statistical Model (Derivation)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="padding: 4px 8px;"><code>Delivery_Distance_KM</code></td>
      <td style="padding: 4px 8px;">Numeric</td>
      <td style="padding: 4px 8px;">Delivery distance in kilometers (1-40 km).</td>
      <td style="padding: 4px 8px;">Truncated Gaussian distribution: d ~ max(1, min(40, Normal(20, 7^2))), rounded to the nearest integer.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Delivery_Distance_HUB_Km</code></td>
      <td style="padding: 4px 8px;">Numeric</td>
      <td style="padding: 4px 8px;">Distance from central hub to customer destination.</td>
      <td style="padding: 4px 8px;">Truncated Gaussian distribution: d_hub ~ max(1, min(50, Normal(25, 10^2))), mapped via sampled address indices.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>kgCO2</code></td>
      <td style="padding: 4px 8px;">Numeric</td>
      <td style="padding: 4px 8px;">Estimated carbon emissions (kg CO2) based on mileage.</td>
      <td style="padding: 4px 8px;">Deterministic physical emission function: E = beta * Distance, with baseline emission factor beta = 0.257 kg CO2/km and return-trip adjustments for road failures.</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Cumulative_Completed_Deliveries</code></td>
      <td style="padding: 4px 8px;">Integer</td>
      <td style="padding: 4px 8px;">Driver's dynamic workload (completed deliveries within the slot).</td>
      <td style="padding: 4px 8px;">Non-homogeneous Poisson/accumulator process conditioned on time-slot progression ratio: lambda(t) = max(0.5, progress * max_deliv).</td>
    </tr>
    <tr>
      <td style="padding: 4px 8px;"><code>Prior_Address_Failures</code></td>
      <td style="padding: 4px 8px;">Integer</td>
      <td style="padding: 4px 8px;">Sequential historical failure count per unique street address up to order creation time.</td>
      <td style="padding: 4px 8px;">Cumulative rolling aggregation function grouped by unique address ID up to order creation timestamp: FailureCount_i = sum(Fail_j for j &lt; i).</td>
    </tr>
  </tbody>
</table>
</details>

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

### 6. 🔬 Multi-Level Stress-Testing and Sensitivity Analysis
To rigorously evaluate the resilience, stability, and predictive discrimination of the Telemetry-Enhanced Random Survival Forest (RSF) framework, the repository includes a dedicated multi-level stress-testing pipeline (see [`src/05-multy_level_stress_testing_and_sensitivity_analysis.R`](src/05-multy_level_stress_testing_and_sensitivity_analysis.R)). Rather than relying solely on standard out-of-sample validation, this module systematically injects controlled, progressive stochastic perturbations into the logistics ecosystem to simulate extreme real-world operational degradation:
* **Microclimatic Stress Scaling:** Simulates severe heatwave scenarios by incrementally amplifying ambient temperatures (&Delta;T) across random subsets of delivery orders.
* **Spatial & Environmental Deterioration:** Scales delivery route detours dynamically, observing how proportional carbon footprint metrics (kgCO2) evolve under routing friction.
* **Regulatory & Urban Bottlenecks:** Forces operational delivery failures under constrained urban access profiles (e.g., restricted LTZ zones combined with thermal stress thresholds).

Key Objectives of the Sensitivity Analysis: 
- **Robustness Quantification:** Tracks how the Out-of-Bag (OOB) C-index evolves and holds steady (exhibiting an upward resilience trend) across escalating stress intensity factors (&gamma; &isin; [1, 3]).
* **Feature Hierarchy Shifts (VIMP):** Monitors how permutation-based Variable Importance metrics shift dynamically, proving the critical role of real-time telemetry (<code>Temperature_C</code>, <code>kgCO2</code>) during crisis scenarios.
* **Reproducible Validation:** The summary table reporting the results of the Random Survival Forest model is presented below:

| Perturbation Factor (gamma) | OOB C-Index | Top Predictor | Temperature VIMP | CO2 VIMP |
| :--- | :---: | :---: | :---: | :---: |
| **1.0** | 0.7145 | Temperature_C | 0.2125 | 0.003193 |
| **1.5** | 0.7217 | Temperature_C | 0.2217 | 0.003629 |
| **2.0** | 0.7266 | Temperature_C | 0.2227 | 0.003655 |
| **2.5** | 0.7307 | Temperature_C | 0.2262 | 0.004007 |
| **3.0** | 0.7338 | Temperature_C | 0.2247 | 0.004286 |

---

## 📚 References & Dependencies

This project builds upon established statistical and machine learning methodologies for survival analysis, as well as several open-source R and Python packages. 
For a complete and detailed list of all theoretical literature and software dependencies used throughout the analysis, please refer to the [REFERENCES.md](REFERENCES.md) file.







