# technical-courier-survival-dataset

Official dataset and resources for the paper: "Predicting Delivery Failures in Technical Courier Services: A Survival Learning Approach for Sustainable Last-Mile Logistics".

## Overview

This repository contains the R source code used to generate a realistic, large-scale synthetic dataset (*N* = 60,000) simulating last-mile logistics operations across Italian administrative provinces. The dataset is engineered for predictive modeling, delivery failure analysis, inventory depletion tracking, and environmental footprint estimations (CO<sub>2</sub>).

---

## Dataset Schema & Variable Description

Below is the exhaustive mathematical and operational specification for every feature generated within the dataset.

### 1. Primary Identifiers & Geography

- **`ID_Delivery_Order`** (*Categorical / String*)  
  Unique 7-digit zero-padded order identifier generated via sampling without replacement ($ID_i \sim \text{Uniform}(0, 9999999)$, formatted as `%07d`).

- **`City`** (*Categorical*)  
  Synthetic municipality name formatted as `City_<Province>_<ID>`.

- **`Postal_Code`** (*Categorical*)  
  5-digit synthetic Italian postal code (`CAP`), sampled from $\text{Uniform}(10000, 99999)$.

- **`Province`** (*Categorical*)  
  Two-letter Italian provincial code sampled from a master pool of $107$ official administrative codes ($P$).

- **`Street_Address`** (*Categorical*)  
  Synthetic street address combining street numbers ($n \in [1, 300]$) and major Italian street naming conventions.

- **`ZTL_Restriction`** (*Binary / Categorical*)  
  Indicates whether the address falls within a Limited Traffic Zone (*Zona a Traffico Limitato*): `$ZTL_i \sim \text{Bernoulli}(p = 0.35)$`.

---

### 2. Temporal & Scheduling Features

- **`Order_Creation_Date`** (*Date*)  
  Order placement date sampled uniformly across valid working days (excluding Sundays) in calendar year $2025$.

- **`Contact_Date`** (*Date*)  
  Date of customer contact, modeled as a discrete stochastic lag: $\text{Contact\_Date}_i = \text{Order\_Creation\_Date}_i + \Delta t_{\text{contact}}$, where $\Delta t_{\text{contact}} \sim \text{Uniform}(\{1, \dots, 5\})$.

- **`Delivery_Date`** (*Date*)  
  Scheduled delivery date post customer contact: $\text{Delivery\_Date}_i = \text{Contact\_Date}_i + \Delta t_{\text{delivery}}$, where $\Delta t_{\text{delivery}} \sim \text{Uniform}(\{1, \dots, 7\})$.

- **`Day_OfWeek`** (*Categorical*)  
  Standardized English day-of-week string extracted from `Delivery_Date`.

- **`Delivery_Time_Slot`** (*Categorical*)  
  Scheduled window (`08:00–13:00`, `14:00–18:00` on weekdays; adjusted `08:00–12:00` window for $45\%$ of Saturday deliveries).

- **`Exact_Delivery_Date`** (*Date*)  
  Actual delivery date execution incorporating operational delays: $\text{Exact\_Delivery\_Date}_i = \text{Delivery\_Date}_i + \delta$, with $\delta \in \{0, 1, 2\}$ and $P(\delta) = \{0.80, 0.15, 0.05\}$.

- **`Exact_Delivery_Time`** (*Time String*)  
  Exact arrival time modeled within the time slot duration $D$ via a Poisson process: $t_{\text{offset}} = X \pmod D$, where $X \sim \text{Poisson}(\lambda = D / 2)$.

---

### 3. Customer Communication Features

- **`Contact_Attempts`** (*Discrete Integer*)  
  Number of contact attempts prior to scheduling ($c \in \{1, 2, 3, 4\}$ with probabilities $P = \{0.80, 0.09, 0.06, 0.05\}$).

- **`Contact_Time_Slot`** (*Categorical*)  
  Assigned customer contact window (`09:00–13:00`, `15:00–19:00`).

- **`Exact_Contact_Time`** (*Time String*)  
  Exact call timestamp incorporating a $20\%$ out-of-slot call probability ($U(0,1) < 0.20$).

- **`Appointment_Confirmation_Received`** (*Categorical*)  
  Indicates whether the delivery appointment was confirmed (`"SI"`, `"NO"`, `"NOT_ORGANIZED"`).

---

### 4. Product, Inventory & Operational Specifications

- **`Product_Size`** (*Categorical*)  
  Package dimension tier (`"Small"`, `"Medium"`, `"Large"`, `"Bulky"`), sampled with probabilities $P = \{0.30, 0.40, 0.20, 0.10\}$.

- **`Product_Item`** (*Categorical*)  
  Specific product item description mapped conditionally to `Product_Size`.

- **`Service_Type`** (*Categorical*)  
  Service level requested: `"Delivery Only"` ($35\%$) vs. `"Delivery & Installation"` ($65\%$).

- **`Personnel_Required`** (*Discrete Integer*)  
  Delivery crew size required ($1$ or $2$ operators), conditioned on size tier and service complexity.

- **`Product_Code`** (*Categorical*)  
  SKU identifier sampled from $100$ pooled codes per size tier (e.g., `SKU-S-001`).

- **`Stock_Quantity`** (*Discrete Non-negative Integer*)  
  Dynamic inventory balance $S_t$ per SKU updated chronologically over order creation dates: $S_{t} = \max(0, S_{t-1} + R_t - 1)$, where $R_t \sim \text{Uniform}(30, 60)$ if $U(0,1) < 0.08$ else $0$.

---

### 5. Environmental & Exogenous Factors

- **`Temperature_C`** (*Continuous Numeric*)  
  Ambient microclimate temperature (°C) synthesized using regional baselines $T_{\text{prov}}$, seasonal monthly offsets $T_{\text{season}}$, diurnal peak hour adjustments $T_{\text{diurnal}}$, and Gaussian noise $\epsilon$: $T_i = T_{\text{prov}} + T_{\text{season}} + T_{\text{diurnal}} + \epsilon_i$, with $\epsilon_i \sim \mathcal{N}(\mu = 0, \sigma^2 = 1.44)$.

---

### 6. Operational Failure & Outcome Mechanisms

- **`Censorship_Indicator`** (*Binary*)  
  Administrative cutoff indicator for survival/event-history analysis: $C_i = 0$ if the record falls in the last $25\%$ chronologically (Right-Censored), and $1$ otherwise (Fully Observed).

- **`Delivery_Status`** (*Categorical*)  
  Final operational outcome (`"Successful"`, `"Failed"`, `"Censored"`).

- **`Failure_Reason`** (*Categorical*)  
  Root cause classification assigned dynamically based on thermal stress conditions ($T_i > 37.5\text{°C}$ or $T_i < -1.0\text{°C}$), stockouts ($S_t = 0$), ZTL permit status, and operational constraints.

- **`Technical_Installation_Detail`** (*Categorical*)  
  Detailed failure cause for installation issues (`"None"`, `"electrical/hydraulic system modification required"`, etc.).

---

### 7. Distances, Workload & Carbon Footprint

- **`Delivery_Distance_KM`** (*Continuous Numeric*)  
  Distance from local hub to customer destination ($\text{km}$), modeled via truncated normal distribution: $d_{\text{delivery}} \sim \mathcal{N}(\mu = 20, \sigma^2 = 49)$, constrained to $[1, 40]$.

- **`Delivery_Distance_HUB_Km`** (*Continuous Numeric*)  
  Distance from central regional HUB to local facility ($\text{km}$): $d_{\text{hub}} \sim \mathcal{N}(\mu = 25, \sigma^2 = 100)$, constrained to $[1, 50]$.

- **`kgCO2`** (*Continuous Numeric*)  
  Estimated carbon emissions (kg CO<sub>2</sub>) based on vehicle mileage and return trips due to failed road deliveries (baseline emission factor $E = 0.257\text{ kg CO}_2/\text{km}$):  
  - $\text{CO}_2 = 0.257 \cdot d_{\text{delivery}}$ if Successful  
  - $\text{CO}_2 = 0.257 \cdot (d_{\text{hub}} + d_{\text{delivery}})$ if Failed on Road  
  - $\text{CO}_2 = 0$ if Upstream Failure / Censored

- **`Cumulative_Completed_Deliveries`** (*Discrete Integer*)  
  Driver workload progression within time slot modeled via a dynamic Poisson intensity parameter $\lambda_{\text{workload}}(t)$.

- **`Prior_Address_Failures`** (*Discrete Non-negative Integer*)  
  Sequential historical failure count per unique street address up to order creation time $t$: $F_i = \sum_{k < i} \mathbb{I}(\text{Delivery\_Status}_k = \text{"Failed"} \land \text{Address}_k = \text{Address}_i)$.

---

## Data Preview (Sample Extract)

Below is an extract showing a complete sample record with all 33 columns generated by the R script:

| ID_Delivery_Order | Order_Creation_Date | Censorship_Indicator | City | Postal_Code | Province | Street_Address | Contact_Date | Contact_Time_Slot | Exact_Contact_Time | Contact_Attempts | Appointment_Confirmation_Received | Delivery_Date | Day_OfWeek | ZTL_Restriction | Delivery_Time_Slot | Exact_Delivery_Date | Exact_Delivery_Time | Cumulative_Completed_Deliveries | Prior_Address_Failures | Product_Size | Product_Item | Service_Type | Personnel_Required | Product_Code | Stock_Quantity | Delivery_Distance_KM | Delivery_Status | Failure_Reason | Technical_Installation_Detail | Delivery_Distance_HUB_Km | kgCO2 | Temperature_C |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **4829104** | 2025-03-12 | 1 | City_MI_124 | 20121 | MI | 45 Garibaldi Street | 2025-03-15 | 09:00-13:00 | 10:15 | 1 | SI | 2025-03-20 | Thursday | Standard Area | 08:00-13:00 | 2025-03-20 | 09:45 | 4 | 0 | Large | Washing Machine | Delivery & Installation | 2 | SKU-L-042 | 54 | 18 | Successful | None | None | 22 | 4.63 | 14.2 |

---

## Usage

To replicate the synthetic dataset generation process locally, follow these instructions:

### 1. Prerequisites
Ensure you have [R](https://www.r-project.org/) (version 4.0 or higher recommended) and an IDE such as [RStudio / Posit](https://posit.co/) installed on your system.

### 2. Install Required Dependencies
Open your R console and execute the following command to install the necessary packages.

---

## 📜 License

This repository uses a dual-license structure to separate code from datasets:

- **Source Code** (R/Python scripts for data generation and survival analysis): Licensed under the [MIT License](LICENSE).
- **Dataset** (Synthetic data for reproducibility): Licensed under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/) License.
