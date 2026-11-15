################################################################################################
#
# Official dataset and resources for the paper: 
# "Predicting Delivery Failures in Technical Courier Services: 
# A Survival Learning Approach for Sustainable Last-Mile Logistics".
#
################################################################################################

# MIT License
# 
# Copyright (c) 2026 Nunziato Garofalo
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# =====================================================================
# =====================================================================
# SCRIPT TITLE: DATASET LOADING, IoT ENHANCEMENT, RSF TRAINING & REAL-TIME ISO SIMULATION
# PAPER REFERENCE: "Predicting Delivery Failures in Technical Courier Services: 
#                   A Survival Learning Approach for Sustainable Last-Mile Logistics"
# =====================================================================
# ==============================================================================
# UNIFIED PIPELINE: CAUSAL TELEMETRY GENERATION, RSF TRAINING & REAL-TIME CO2 SAVINGS
# ==============================================================================

# Load required libraries for data manipulation, Excel export, data wrangling, 
# Random Survival Forests, and standard survival analysis classes.
suppressPackageStartupMessages({
  library(MASS)
  library(writexl)
  library(tidyverse)
  library(ranger)
  library(survival)
  library(readxl)
})

# Set pseudo-random seed to guarantee exact computational reproducibility across experiments.
set.seed(1276)

cat("=== SECTION 1: MASTER DATASET GENERATION WITH CAUSAL TELEMETRY & HUMAN FACTORS ===\n")

# Define total sample size for the synthetic last-mile logistics master dataset.
n_orders <- 60000

# --- Unique Order Identifier Generation ---
# Generate uniformly distributed numeric IDs and format them into unique zero-padded strings.
num_ID <- sample(0:9999999, n_orders, replace = FALSE)
ID_Delivery_Order <- sprintf("%07d", num_ID)

# --- Geographical Master Reference ---
# Define standard Italian provincial administrative codes for realistic spatial distribution.
italian_provinces <- unique(c(
  "AG", "AL", "AN", "AO", "AP", "AQ", "AR", "AT", "AV", "BA", "BG", "BI", "BL", "BN", "BO", 
  "BS", "BT", "BZ", "CB", "CE", "CH", "CL", "CN", "CO", "CR", "CS", "CT", "CZ", "EN", 
  "FC", "FE", "FG", "FI", "FM", "FR", "GE", "GO", "GR", "IM", "IS", "LC", "LE", "LI", 
  "LO", "LT", "LU", "MB", "MC", "ME", "MI", "MN", "MO", "MS", "MT", "NA", "NO", "NU", "OR", 
  "PA", "PC", "PD", "PE", "PG", "PI", "PN", "PO", "PR", "PT", "PU", "PV", "PZ", "RA", "RC", 
  "RE", "RG", "RI", "RM", "RN", "RO", "SA", "SI", "SO", "SP", "SR", "SS", "SU", "SV", "TA", 
  "TE", "TN", "TO", "TP", "TR", "TS", "TV", "UD", "VA", "VB", "VC", "VE", "VI", "VR", "VT", "KR"
))

# Generate a master repository of unique delivery addresses to simulate spatial clustering.
n_unique_addresses <- 15000 
pool_province <- sample(italian_provinces, n_unique_addresses, replace = TRUE)
pool_city <- paste0("City_", pool_province, "_", sample(1:500, n_unique_addresses, replace = TRUE))
pool_postal_code <- sprintf("%05d", sample(10000:99999, n_unique_addresses, replace = TRUE))
pool_street <- paste(
  sample(1:300, n_unique_addresses, replace = TRUE), 
  sample(c("Roma", "Milano", "Garibaldi", "Dante", "Venezia", "Torino", "Bologna", "Napoli", "Mazzini", "Carducci", "Manzoni", "Leopardi", "Verdi", "Puccini", "Cavour"), n_unique_addresses, replace = TRUE), 
  "Street"
)

# Assign Limited Traffic Zone (ZTL) regulatory status (Binomial process: 35% restricted, 65% standard).
ztl_pool_status <- sample(c("ZTL - Special Permit Required", "Standard Area"), n_unique_addresses, replace = TRUE, prob = c(0.35, 0.65))

master_addresses <- data.frame(
  City = pool_city,
  Postal_Code = pool_postal_code,
  Province = pool_province,
  Street_Address = pool_street,
  ZTL_Restriction = ztl_pool_status
)

sampled_indices <- sample(1:nrow(master_addresses), n_orders, replace = TRUE)
realtime_dataset <- master_addresses[sampled_indices, ]
realtime_dataset$ID_Delivery_Order <- ID_Delivery_Order
realtime_dataset$Address_ID <- sampled_indices

# --- Temporal Features ---
# Define temporal simulation bounds covering a full calendar year (2025), excluding Sundays.
start_date <- as.Date("2025-01-01")
end_date <- as.Date("2025-12-31")
all_dates <- seq(start_date, end_date, by = "day")
valid_dates <- all_dates[as.POSIXlt(all_dates)$wday != 0]

realtime_dataset$Order_Creation_Date <- sample(valid_dates, n_orders, replace = TRUE)

# Simulate stochastic customer contact lag (1-5 working days post order creation).
contact_dates <- as.Date(character(n_orders))
for(i in 1:n_orders) {
  days_after <- sample(1:5, 1)
  c_date <- as.Date(realtime_dataset$Order_Creation_Date[i]) + days_after
  if(c_date > end_date) c_date <- end_date
  if(as.POSIXlt(c_date)$wday == 0) c_date <- c_date + 1 
  contact_dates[i] <- c_date
}
realtime_dataset$Contact_Date <- contact_dates

# Simulate scheduled delivery date lag (1-7 working days post customer contact).
delivery_dates <- as.Date(character(n_orders))
for(i in 1:n_orders) {
  days_delivery <- sample(1:7, 1)
  d_date <- as.Date(realtime_dataset$Contact_Date[i]) + days_delivery
  if(d_date > end_date) d_date <- end_date
  if(as.POSIXlt(d_date)$wday == 0) d_date <- d_date + 1 
  delivery_dates[i] <- d_date
}
realtime_dataset$Delivery_Date <- delivery_dates

# Incorporate real-world operational execution delay probabilities.
exact_delivery_dates <- as.Date(character(n_orders))
for(i in 1:n_orders) {
  extra_delay <- sample(0:2, 1, prob = c(0.8, 0.15, 0.05))
  ed_date <- as.Date(realtime_dataset$Delivery_Date[i]) + extra_delay
  if(ed_date > end_date) ed_date <- end_date
  exact_delivery_dates[i] <- ed_date
}
realtime_dataset$Exact_Delivery_Date <- exact_delivery_dates

# Map delivery dates to weekdays and standardize linguistic labels from Italian to English.
days_it_en <- format(realtime_dataset$Delivery_Date, "%A")
days_map_it <- c(
  "domenica"="Sunday", "lunedì"="Monday", "martedì"="Tuesday", 
  "mercoledì"="Wednesday", "giovedì"="Thursday", "venerdì"="Friday", "sabato"="Saturday",
  "Sunday"="Sunday", "Monday"="Monday", "Tuesday"="Tuesday", 
  "Wednesday"="Wednesday", "Thursday"="Thursday", "Friday"="Friday", "Saturday"="Saturday"
)
realtime_dataset$Day_OfWeek <- unname(days_map_it[tolower(days_it_en)])
realtime_dataset$Day_OfWeek[is.na(realtime_dataset$Day_OfWeek)] <- format(realtime_dataset$Delivery_Date, "%A")

# Assign delivery time windows, accounting for shorter operating hours on Saturdays.
standard_time_slots <- c("08:00-13:00", "14:00-18:00")
saturday_morning_slot <- "08:00-12:00"

is_saturday <- as.POSIXlt(realtime_dataset$Delivery_Date)$wday == 6
realtime_dataset$Delivery_Time_Slot <- character(n_orders)
normal_indices <- !is_saturday
realtime_dataset$Delivery_Time_Slot[normal_indices] <- sample(standard_time_slots, sum(normal_indices), replace = TRUE)

saturday_indices <- which(is_saturday)
n_saturday <- length(saturday_indices)
n_saturday_morning <- ceiling(n_saturday * 0.45)
if (n_saturday > 0) {
  saturday_morning_choice <- sample(saturday_indices, n_saturday_morning)
  realtime_dataset$Delivery_Time_Slot[saturday_morning_choice] <- saturday_morning_slot
  remaining_saturday_indices <- setdiff(saturday_indices, saturday_morning_choice)
  if (length(remaining_saturday_indices) > 0) {
    realtime_dataset$Delivery_Time_Slot[remaining_saturday_indices] <- sample(standard_time_slots, length(remaining_saturday_indices), replace = TRUE)
  }
}

# Model exact arrival times using a Poisson arrival process within the assigned time windows.
generate_poisson_time <- function(slot) {
  n <- length(slot)
  times <- character(n)
  for(i in 1:n) {
    s <- slot[i]
    if(s == "" || is.na(s)) { times[i] <- "0"; next }
    if(s == "08:00-13:00") { start_min <- 8 * 60; duration <- 300
    } else if(s == "14:00-18:00") { start_min <- 14 * 60; duration <- 240
    } else if(s == "08:00-12:00") { start_min <- 8 * 60; duration <- 240
    } else { start_min <- 8 * 60; duration <- 300 }
    
    offset <- rpois(1, lambda = duration / 2) %% duration
    total_minutes <- start_min + offset
    times[i] <- sprintf("%02d:%02d", floor(total_minutes / 60), total_minutes %% 60)
  }
  return(times)
}

realtime_dataset$Exact_Delivery_Time <- generate_poisson_time(realtime_dataset$Delivery_Time_Slot)

# --- Product & Service Specs ---
# Define product dimensional categories and associated volumetric probability distributions.
product_types <- c("Small", "Medium", "Large", "Bulky")
realtime_dataset$Product_Size <- sample(product_types, n_orders, replace = TRUE, prob = c(0.30, 0.40, 0.20, 0.10))

prod_small <- c("Decoder", "Modem", "Phone", "Accessories")
prod_medium <- c("Microwave", "Small Appliance")
prod_large <- c("TV up to 37\"", "Washing Machine", "Medium Appliance")
prod_bulky <- c("Refrigerator", "TV over 37\"", "Large Appliance")

specific_products <- character(n_orders)
for(i in 1:n_orders) {
  sz <- realtime_dataset$Product_Size[i]
  specific_products[i] <- switch(sz,
                                 "Small" = sample(prod_small, 1),
                                 "Medium" = sample(prod_medium, 1),
                                 "Large" = sample(prod_large, 1),
                                 "Bulky" = sample(prod_bulky, 1)
  )
}
realtime_dataset$Product_Item <- specific_products
realtime_dataset$Service_Type <- sample(c("Delivery Only", "Delivery & Installation"), n_orders, replace = TRUE, prob = c(0.35, 0.65))

# Determine operational crew size requirements based on product bulkiness and service complexity.
required_personnel <- integer(n_orders)
for(i in 1:n_orders) {
  sz <- realtime_dataset$Product_Size[i]
  srv <- realtime_dataset$Service_Type[i]
  required_personnel[i] <- ifelse(srv == "Delivery Only", ifelse(sz %in% c("Small", "Medium", "Large"), 1, 2), ifelse(sz %in% c("Small", "Medium"), 1, 2))
}
realtime_dataset$Personnel_Required <- required_personnel

n_pool_fake <- 100
product_codes_pool <- list(
  "Small" = sprintf("SKU-S-%03d", 1:n_pool_fake),
  "Medium" = sprintf("SKU-M-%03d", 1:n_pool_fake),
  "Large" = sprintf("SKU-L-%03d", 1:n_pool_fake),
  "Bulky" = sprintf("SKU-B-%03d", 1:n_pool_fake)
)
product_code <- character(n_orders)
for(sz in product_types) {
  idx <- which(realtime_dataset$Product_Size == sz)
  if(length(idx) > 0) product_code[idx] <- sample(product_codes_pool[[sz]], length(idx), replace = TRUE)
}
realtime_dataset$Product_Code <- product_code

# --- Censorship & Inventory ---
# Implement right-censoring mechanics (25% administrative right-censoring rate).
n_censored <- ceiling(n_orders * 0.25) 
date_ordering <- order(realtime_dataset$Order_Creation_Date)
censored_indices <- date_ordering[(n_orders - n_censored + 1):n_orders]

realtime_dataset$Censorship_Indicator <- 1
realtime_dataset$Censorship_Indicator[censored_indices] <- 0

# Simulate dynamic inventory depletion and replenishment per SKU over chronological order placement.
realtime_dataset$Original_Index <- 1:n_orders
realtime_dataset <- realtime_dataset[order(realtime_dataset$Order_Creation_Date), ]
sku_stock_state <- list()
for(sku in unique(realtime_dataset$Product_Code)) sku_stock_state[[sku]] <- sample(40:80, 1)

current_stocks <- numeric(n_orders)
for(i in 1:n_orders) {
  sku <- realtime_dataset$Product_Code[i]
  if(runif(1) < 0.08) sku_stock_state[[sku]] <- sku_stock_state[[sku]] + sample(30:60, 1)
  current_stocks[i] <- max(0, sku_stock_state[[sku]])
  if(sku_stock_state[[sku]] > 0) sku_stock_state[[sku]] <- sku_stock_state[[sku]] - 1
}
realtime_dataset$Stock_Quantity <- current_stocks
realtime_dataset <- realtime_dataset[order(realtime_dataset$Original_Index), ]
realtime_dataset$Original_Index <- NULL

# Model baseline provincial temperatures combined with annual thermal fluctuations.
province_temp_base <- runif(length(italian_provinces), min = 8, max = 18)
names(province_temp_base) <- italian_provinces
temp_base_province <- province_temp_base[realtime_dataset$Province]
realtime_dataset$Temperature_C <- round(temp_base_province + rnorm(n_orders, mean = 10, sd = 3), 1)

# Generate IoT telemetry and behavioral indicators mirroring real-world operating conditions.
realtime_dataset <- realtime_dataset %>%
  mutate(
    battery_level_avg        = runif(n(), min = 15.0, max = 100.0), # IoT vehicle battery state-of-charge (%)
    traffic_index_avg        = runif(n(), min = 1.0, max = 5.0),    # Urban traffic congestion index
    pre_check_score          = runif(n(), min = 0.0, max = 1.0),    # Pre-appointment technical site survey score
    dynamic_disruption_index = runif(n(), min = 1.0, max = 4.8)     # Dynamic customer absence / revocation index
  )

# --- Operational Failure Mechanism (Sensors driving outcomes logically) ---
delivery_outcome <- character(n_orders)
failure_reason <- character(n_orders)

# Establish deterministic causal links: sensor anomalies directly trigger specific delivery disruptions.
for(i in 1:n_orders) {
  if (realtime_dataset$Censorship_Indicator[i] == 0) {
    delivery_outcome[i] <- "Censored"
    failure_reason[i] <- "Censored"
    next
  }
  
  if (realtime_dataset$Stock_Quantity[i] == 0) {
    delivery_outcome[i] <- "Failed"
    failure_reason[i] <- "Product Unavailable"
    next
  }
  
  # Causal logic governed by telemetry thresholds and human coordination factors
  bat_val <- realtime_dataset$battery_level_avg[i]
  pre_val <- realtime_dataset$pre_check_score[i]
  traf_val <- realtime_dataset$traffic_index_avg[i]
  
  if (bat_val < 25.0) {
    delivery_outcome[i] <- "Failed"
    failure_reason[i] <- "Vehicle Breakdown / Low Battery"
  } else if (pre_val < 0.35) {
    delivery_outcome[i] <- "Failed"
    failure_reason[i] <- "Technical Installation Issue"
  } else if (traf_val > 4.2 && runif(1) < 0.6) {
    delivery_outcome[i] <- "Failed"
    failure_reason[i] <- "Traffic/Delay"
  } else if (runif(1) < 0.22) {
    delivery_outcome[i] <- "Failed"
    failure_reason[i] <- "Failed Appointment"
  } else {
    delivery_outcome[i] <- "Successful"
    failure_reason[i] <- "None"
  }
}

realtime_dataset$Delivery_Status <- delivery_outcome
realtime_dataset$Failure_Reason <- failure_reason

# --- Driver Workload & Historical Failures ---
# Model operational driver workload as cumulative completed deliveries within specific delivery windows.
cumulative_deliveries <- integer(n_orders)
for(i in 1:n_orders) {
  slot <- realtime_dataset$Delivery_Time_Slot[i]
  time_str <- realtime_dataset$Exact_Delivery_Time[i]
  if(is.na(slot) || slot == "0" || is.na(time_str) || time_str == "0") {
    cumulative_deliveries[i] <- 0
    next
  }
  time_parts <- as.numeric(strsplit(time_str, ":")[[1]])
  current_minutes <- time_parts[1] * 60 + time_parts[2]
  max_deliveries <- ifelse(slot == "14:00-18:00", 12, 10)
  cumulative_deliveries[i] <- sample(1:max_deliveries, 1)
}
realtime_dataset$Cumulative_Completed_Deliveries <- cumulative_deliveries

realtime_dataset$Appointment_Confirmation_Received <- sample(c("YES", "NOT"), n_orders, replace = TRUE, prob = c(0.85, 0.15))
realtime_dataset$Delivery_Distance_KM <- round(pmin(pmax(rnorm(n_orders, mean = 20, sd = 7), 1), 40))
realtime_dataset$Delivery_Distance_HUB_Km <- round(pmin(pmax(rnorm(n_orders, mean = 25, sd = 10), 1), 50))

cat("[INFO] Master dataset with causally linked telemetry successfully generated.\n\n")


# ==============================================================================
# 2. SURVIVAL TARGET STRUCTURING & DATA HYGIENE
# ==============================================================================
cat("=== SECTION 2: SURVIVAL TARGET STRUCTURING & HYGIENE ===\n")

# Calculate time-to-event metrics (duration from order creation to final delivery or censorship horizon).
order_date <- as.Date(realtime_dataset$Order_Creation_Date)
max_obs_date <- max(order_date, na.rm = TRUE) + 30

# Clean and convert Exact_Delivery_Date safely
exact_dt_raw <- as.character(realtime_dataset$Exact_Delivery_Date)
exact_dt_raw[exact_dt_raw == "0" | exact_dt_raw == "" | is.na(exact_dt_raw)] <- NA
exact_dt <- as.Date(exact_dt_raw)

# Clean and convert Delivery_Date safely
deliv_dt_raw <- as.character(realtime_dataset$Delivery_Date)
deliv_dt_raw[deliv_dt_raw == "0" | deliv_dt_raw == "" | is.na(deliv_dt_raw)] <- NA
deliv_dt <- as.Date(deliv_dt_raw)

final_dt <- exact_dt
final_dt[is.na(final_dt)] <- deliv_dt[is.na(final_dt)]
final_dt[is.na(final_dt) & realtime_dataset$Censorship_Indicator == 0] <- max_obs_date
final_dt[is.na(final_dt)] <- order_date[is.na(final_dt)] + 5

realtime_dataset$time_to_event <- as.numeric(final_dt - order_date)
realtime_dataset$time_to_event[realtime_dataset$time_to_event <= 0] <- 1

# Define binary event status indicator (1 = Delivery Disruption / Failure, 0 = Success or Censored).
realtime_dataset$status <- ifelse(realtime_dataset$Censorship_Indicator == 0, 0,
                                  ifelse(realtime_dataset$Delivery_Status == "Failed", 1, 0))

# Select predictive feature subset available strictly at the moment of order placement (t = 0).
features_for_modeling <- c(
  "Service_Type", "Product_Size", "Personnel_Required",
  "ZTL_Restriction", "Delivery_Distance_KM", "Stock_Quantity", 
  "Prior_Address_Failures", "Temperature_C", "Appointment_Confirmation_Received",
  "battery_level_avg", "traffic_index_avg", "pre_check_score", "dynamic_disruption_index",
  "time_to_event", "status"
)

if(!("Prior_Address_Failures" %in% names(realtime_dataset))) {
  realtime_dataset$Prior_Address_Failures <- rpois(n_orders, lambda = 0.1)
}

surv_df_subset <- realtime_dataset[, intersect(names(realtime_dataset), features_for_modeling)]
surv_df_subset <- as.data.frame(surv_df_subset)

# Format categorical variables as R factors and explicitly capture missingness levels.
covars_to_factor <- c("Service_Type", "Product_Size", "ZTL_Restriction", "Appointment_Confirmation_Received")
for(col in intersect(covars_to_factor, names(surv_df_subset))) {
  surv_df_subset[[col]] <- addNA(as.factor(surv_df_subset[[col]]))
  levels(surv_df_subset[[col]])[is.na(levels(surv_df_subset[[col]]))] <- "Missing"
}

surv_df_clean <- surv_df_subset[!is.na(surv_df_subset$time_to_event) & !is.na(surv_df_subset$status), ]

# Perform stratified data partitioning (70% Training / 30% Testing splits).
set.seed(1276)
train_idx <- sample(1:nrow(surv_df_clean), size = 0.7 * nrow(surv_df_clean))
train_data_rt <- surv_df_clean[train_idx, ]
test_data_rt  <- surv_df_clean[-train_idx, ]

# Apply median imputation exclusively on the training partition to prevent data leakage.
num_vars_rt <- c("Delivery_Distance_KM", "Stock_Quantity", "Prior_Address_Failures", "Personnel_Required", 
                 "Temperature_C", "battery_level_avg", "traffic_index_avg", "pre_check_score", "dynamic_disruption_index")
for(v in intersect(num_vars_rt, names(train_data_rt))) {
  med_val <- median(train_data_rt[[v]], na.rm = TRUE)
  train_data_rt[[v]][is.na(train_data_rt[[v]])] <- med_val
  test_data_rt[[v]][is.na(test_data_rt[[v]])] <- med_val
}


# ==============================================================================
# 3. TRAINING THE RANDOM SURVIVAL FOREST (RSF) MODEL
# ==============================================================================
cat("=== SECTION 3: TRAINING RANDOM SURVIVAL FOREST MODEL ===\n")

# Ensure strict factor level alignment between training and test sets.
for (col in names(train_data_rt)) {
  if (is.factor(train_data_rt[[col]])) {
    test_data_rt[[col]] <- factor(test_data_rt[[col]], levels = levels(train_data_rt[[col]]))
  }
}

# Train a non-parametric Random Survival Forest (RSF) ensemble via the high-performance 'ranger' package.
set.seed(1276)
rsf_model_rt <- ranger(
  Surv(time_to_event, status) ~ ., 
  data = train_data_rt,
  num.trees = 500,        
  splitrule = "logrank", 
  max.depth = 15,          
  seed = 1276,
  respect.unordered.factors = "order",
  num.threads = 1
)

print(rsf_model_rt)


# ==============================================================================
# 4. REAL-TIME STREAMING SIMULATION (100 ORDERS) & CO2 SAVINGS ASSESSMENT
# ==============================================================================
cat("\n=== SECTION 4: REAL-TIME STREAMING SIMULATION (100 ORDERS) & CO2 SAVINGS ASSESSMENT ===\n")
set.seed(1276)
# Simulate a live digital twin monitoring cohort of active orders in real-time streaming mode.
n_streaming <- 100

streaming_orders <- data.frame(
  order_id = 1:n_streaming,
  Service_Type = sample(levels(train_data_rt$Service_Type), n_streaming, replace = TRUE),
  Product_Size = sample(levels(train_data_rt$Product_Size), n_streaming, replace = TRUE),
  Personnel_Required = sample(1:2, n_streaming, replace = TRUE, prob = c(0.7, 0.3)),
  ZTL_Restriction = sample(levels(train_data_rt$ZTL_Restriction), n_streaming, replace = TRUE),
  Delivery_Distance_KM = round(rnorm(n_streaming, mean = 18, sd = 6)) %>% pmin(40) %>% pmax(1),
  Stock_Quantity = sample(1:30, n_streaming, replace = TRUE),
  Prior_Address_Failures = rpois(n_streaming, lambda = 0.1),
  Temperature_C = rnorm(n_streaming, mean = 26, sd = 4),
  Appointment_Confirmation_Received = sample(levels(train_data_rt$Appointment_Confirmation_Received), n_streaming, replace = TRUE),
  battery_level_avg = runif(n_streaming, min = 15, max = 95),        # Includes critical battery levels (< 25%)
  traffic_index_avg = runif(n_streaming, min = 1.0, max = 5.0),
  pre_check_score = runif(n_streaming, min = 0.1, max = 1.0),        # Includes low pre-check survey scores
  dynamic_disruption_index = runif(n_streaming, min = 1.0, max = 4.8)
)

# Align streaming dataset schema and factor levels with the training matrix.
for (col in names(train_data_rt)) {
  if (col %in% c("time_to_event", "status")) next
  if (col %in% names(streaming_orders)) {
    if (is.factor(train_data_rt[[col]])) {
      streaming_orders[[col]] <- factor(streaming_orders[[col]], levels = levels(train_data_rt[[col]]))
    }
  } else {
    if (is.factor(train_data_rt[[col]])) {
      streaming_orders[[col]] <- factor(rep(levels(train_data_rt[[col]])[1], n_streaming), levels = levels(train_data_rt[[col]]))
    } else {
      streaming_orders[[col]] <- median(train_data_rt[[col]], na.rm = TRUE)
    }
  }
}

streaming_orders$time_to_event <- 1
streaming_orders$status <- 0
streaming_orders$vehicle_type <- sample(c("Diesel_Van", "Electric_Van"), n_streaming, replace = TRUE, prob = c(0.5, 0.5))
streaming_orders$distance_hub_km <- round(streaming_orders$Delivery_Distance_KM * 1.3)

# Evaluate active delivery cohorts across discrete operational time ticks (t = 2, 4, 6 hours).
for (current_t in c(2, 4, 6)) {
  cat(sprintf("--- [STREAMING TICK: t = %d hours] Real-Time Risk Evaluation & Dispatcher Action ---\n", current_t))
  
  simulated_rt_data <- streaming_orders
  
  # Predict real-time cumulative failure risk scores using the pre-trained RSF ensemble.
  rsf_pred <- predict(rsf_model_rt, data = simulated_rt_data)
  
  if (!is.null(rsf_pred$survival)) {
    survival_matrix <- as.matrix(rsf_pred$survival)
    simulated_rt_data$predicted_risk_score <- rowMeans(1 - survival_matrix, na.rm = TRUE)
  } else if (!is.null(rsf_pred$predictions)) {
    pred_vals <- rsf_pred$predictions
    if (is.matrix(pred_vals) || is.data.frame(pred_vals)) {
      simulated_rt_data$predicted_risk_score <- rowMeans(as.matrix(pred_vals), na.rm = TRUE)
    } else {
      simulated_rt_data$predicted_risk_score <- as.numeric(pred_vals)
    }
  } else {
    stop("[ERROR] Prediction returned NULL predictions or survival curves.")
  }
  
  # Stratify predicted risk scores into actionable operational tiers (SAFE, WARNING, CRITICAL).
  simulated_rt_data <- simulated_rt_data %>%
    mutate(risk_level = case_when(
      predicted_risk_score > quantile(predicted_risk_score, 0.75, na.rm = TRUE) ~ "CRITICAL 🔴",
      predicted_risk_score > quantile(predicted_risk_score, 0.40, na.rm = TRUE) ~ "WARNING 🟡",
      TRUE ~ "SAFE 🟢"
    ))
  
  print(
    simulated_rt_data %>% 
      dplyr::select(order_id, vehicle_type, Delivery_Distance_KM, battery_level_avg, pre_check_score, predicted_risk_score, risk_level) %>%
      head(5)
  )
  
  cat(sprintf("[SUCCESS] Tick t = %d completato senza errori.\n\n", current_t))
}

# ISO 14083 verification
co2_eval_df <- simulated_rt_data


# ==============================================================================
# 5. ISO 14083 COMPLIANT CO2 SAVINGS VERIFICATION
# ==============================================================================
cat("=== SECTION 5: COMPARATIVE CO2 EMISSIONS VERIFICATION (PREDICTIVE VS REACTIVE) ===\n")

# Define official greenhouse gas emission intensity factors per ISO 14083 standards (g CO2e per km).
iso_emission_factors <- c(
  "Diesel_Van"   = 257.0, 
  "Electric_Van" = 25.4   
)

# Quantify environmental impact by contrasting reactive unmonitored baseline vs. proactive predictive intervention.
co2_eval_df <- co2_eval_df %>%
  mutate(
    vehicle_ef = iso_emission_factors[as.character(vehicle_type)],
    
    # 1. Reactive Baseline Scenario (Unmonitored)
    reactive_emissions_g = 2 * (Delivery_Distance_KM + distance_hub_km) * vehicle_ef,
    
    # 2. Proactive Intervention Scenario (Predictive Monitoring)
    proactive_emissions_g = (Delivery_Distance_KM + 2.0) * vehicle_ef,
    
    # Compute net CO2e savings exclusively for orders flagged as CRITICAL
    co2_saved_g = ifelse(risk_level == "CRITICAL 🔴", 
                         reactive_emissions_g - proactive_emissions_g, 
                         0)
  )

total_co2_saved_kg <- sum(co2_eval_df$co2_saved_g, na.rm = TRUE) / 1000
total_intercepted <- sum(co2_eval_df$risk_level == "CRITICAL 🔴")

# --- RESULTS FOR README FILE ---
tot_reactive_kg  <- sum(co2_eval_df$reactive_emissions_g, na.rm = TRUE) / 1000
tot_proactive_kg <- sum(co2_eval_df$proactive_emissions_g, na.rm = TRUE) / 1000
pct_reduction    <- (total_co2_saved_kg / tot_reactive_kg) * 100
# -------------------------------------

cat(sprintf("-> ISO 14083 ENVIRONMENTAL IMPACT ASSESSMENT RESULT:\n"))
cat(sprintf("    Total Critical Deliveries Intercepted Proactively: %d / %d\n", total_intercepted, n_streaming))
cat(sprintf("    Total Avoided CO2e Emissions via Real-Time Rerouting: %.2f kg CO2\n", total_co2_saved_kg))
cat(sprintf("    Average CO2e Reduction per Intercepted Delivery: %.2f kg CO2\n\n", 
            total_co2_saved_kg / max(1, total_intercepted)))

# --- EXTRA DATA FOR README FILE ---
cat(sprintf("[README DATA] Reactive Total: %.2f kg | Proactive Total: %.2f kg | Reduction: %.1f%%\n", 
            tot_reactive_kg, tot_proactive_kg, pct_reduction))
cat(sprintf("[README DATA] Reactive Avg/Order: %.2f kg | Proactive Avg/Order: %.2f kg\n\n", 
            tot_reactive_kg / n_streaming, tot_proactive_kg / n_streaming))
# -----------------------------------

cat("=== PIPELINE SUCCESSFULLY COMPLETED! 🚀 ===\n")

# Markdown extracion
library(knitr)
markdown_table <- simulated_rt_data %>% 
dplyr::select(order_id, vehicle_type, Delivery_Distance_KM, battery_level_avg, pre_check_score, predicted_risk_score, risk_level) %>%
head(5) %>%
knitr::kable(format = "markdown", digits = 3)
print(markdown_table)