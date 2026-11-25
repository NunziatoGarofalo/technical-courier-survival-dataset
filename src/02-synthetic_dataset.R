
################################################################################################
#
# Official dataset and resources for the paper: 
# "Predicting Delivery Failures in Technical Courier Services: 
# A Survival Learning Approach for Sustainable Last-Mile Logistics".
#
################################################################################################
# SYNTHETIC DATASET GENERATION: LAST-MILE LOGISTICS and TECHNICAL COURIER SIMULATION
# 
# Description:
#   This R script generates a comprehensive, structurally complex synthetic dataset 
#   tailored for last-mile logistics optimization, predictive modeling, and failure analysis. 
#   It incorporates stochastic processes, temporal scheduling logic, spatial distributions, 
#   CO2 emissions, microclimate temperature modeling, inventory dynamics, and right-censoring 
#   mechanisms.
#
# Required R Libraries:
#   - MASS: Provides functions for multivariate and univariate statistical distributions 
#           and data generation (utilized for simulating continuous physical variables and 
#           environmental variations).
#   - writexl: Enables fast, dependency-free export of data frames into structured Microsoft 
#              Excel (.xlsx) file formats for subsequent analysis or reporting.
#
# Author: Nunziato Garofalo
# Reproducibility Seed: 1276
################################################################################################
#
# MIT License
# 
# Copyright (c) 2026 Anonymous Author
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
#
################################################################################################
# -------------------------------------------------------------------------------------
# Creative Commons Attribution 4.0 International (CC BY 4.0)
# 
# The datasets contained in this repository (e.g., files in the data/ directory) 
# are licensed under the Creative Commons Attribution 4.0 International License.
# 
# To view a copy of this license, visit: http://creativecommons.org/licenses/by/4.0/
# 
# or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
# -------------------------------------------------------------------------------------

########################
# REQUIRED LIBRARIES
########################
# - MASS: Provides functions for multivariate and univariate normal data generation 
#         (e.g., simulating continuous physical measurements and environmental variations).
# - writexl: Enables fast, dependency-free export of data frames into Excel (.xlsx) format.
library(MASS)    
library(writexl) 

# Display current session environment and package dependencies for replication purposes
sessionInfo()

###############################################################################
# 1. INITIALIZATION & REPRODUCIBILITY CONFIGURATION
###############################################################################

# Set pseudo-random number generator seed to guarantee exact computational reproducibility
set.seed(1276)

# Define total sample size (number of synthetic delivery orders to generate)
n_orders <- 60000

# --- Unique Order Identifier Generation ---
# Generate a uniformly distributed pool of numeric IDs and format them into zero-padded strings
num_ID <- sample(0:9999999, n_orders, replace = FALSE)
ID_Delivery_Order <- sprintf("%07d", num_ID)


###############################################################################
# 2. GEOGRAPHICAL MASTER REFERENCE DATA CONSTRUCTION
###############################################################################

# Define standard Italian provincial administrative codes for spatial localization
italian_provinces <- unique(c(
  "AG", "AL", "AN", "AO", "AP", "AQ", "AR", "AT", "AV", "BA", "BG", "BI", "BL", "BN", "BO", 
  "BS", "BT", "BZ", "CB", "CE", "CH", "CL", "CN", "CO", "CR", "CS", "CT", "CZ", "EN", 
  "FC", "FE", "FG", "FI", "FM", "FR", "GE", "GO", "GR", "IM", "IS", "LC", "LE", "LI", 
  "LO", "LT", "LU", "MB", "MC", "ME", "MI", "MN", "MO", "MS", "MT", "NA", "NO", "NU", "OR", 
  "PA", "PC", "PD", "PE", "PG", "PI", "PN", "PO", "PR", "PT", "PU", "PV", "PZ", "RA", "RC", 
  "RE", "RG", "RI", "RM", "RN", "RO", "SA", "SI", "SO", "SP", "SR", "SS", "SU", "SV", "TA", 
  "TE", "TN", "TO", "TP", "TR", "TS", "TV", "UD", "VA", "VB", "VC", "VE", "VI", "VR", "VT", "KR"
))

# Generate a master pool of unique delivery addresses (N = 15,000) to simulate spatial clustering
n_unique_addresses <- 15000 
pool_province <- sample(italian_provinces, n_unique_addresses, replace = TRUE)
pool_city <- paste0("City_", pool_province, "_", sample(1:500, n_unique_addresses, replace = TRUE))
pool_postal_code <- sprintf("%05d", sample(10000:99999, n_unique_addresses, replace = TRUE))
pool_street <- paste(
  sample(1:300, n_unique_addresses, replace = TRUE), 
  sample(c("Roma", "Milano", "Garibaldi", "Dante", "Venezia", "Torino", "Bologna", "Napoli", "Mazzini", "Carducci", "Manzoni", "Leopardi", "Verdi", "Puccini", "Cavour"), n_unique_addresses, replace = TRUE), 
  "Street"
)

# Assign Limited Traffic Zone (ZTL) regulatory status (Binomial process with 35% probability for restricted access)
ztl_pool_status <- sample(c("ZTL - Special Permit Required", "Standard Area"), n_unique_addresses, replace = TRUE, prob = c(0.35, 0.65))

master_addresses <- data.frame(
  City = pool_city,
  Postal_Code = pool_postal_code,
  Province = pool_province,
  Street_Address = pool_street,
  ZTL_Restriction = ztl_pool_status
)

# Sample delivery locations from the master address pool to introduce realistic spatial repetition
sampled_indices <- sample(1:nrow(master_addresses), n_orders, replace = TRUE)

logistics_dataset <- master_addresses[sampled_indices, ]
logistics_dataset$ID_Delivery_Order <- ID_Delivery_Order
logistics_dataset$Address_ID <- sampled_indices


###############################################################################
# 3. TEMPORAL FEATURES & OPERATIONAL SCHEDULING LOGIC
###############################################################################

# Define temporal simulation bounds (Full calendar year 2025)
start_date <- as.Date("2025-01-01")
end_date <- as.Date("2025-12-31")
all_dates <- seq(start_date, end_date, by = "day")
valid_dates <- all_dates[as.POSIXlt(all_dates)$wday != 0] # Exclude Sundays (non-working days)

logistics_dataset$Order_Creation_Date <- sample(valid_dates, n_orders, replace = TRUE)

# Generate contact scheduling dates (Stochastic lag of 1-5 working days post order creation)
contact_dates <- as.Date(character(n_orders))
for(i in 1:n_orders) {
  days_after <- sample(1:5, 1)
  c_date <- as.Date(logistics_dataset$Order_Creation_Date[i]) + days_after
  if(c_date > end_date) c_date <- end_date
  if(as.POSIXlt(c_date)$wday == 0) c_date <- c_date + 1 # Shift Sunday to Monday
  contact_dates[i] <- c_date
}
logistics_dataset$Contact_Date <- contact_dates

# Generate scheduled delivery dates (Stochastic lag of 1-7 working days post customer contact)
delivery_dates <- as.Date(character(n_orders))
for(i in 1:n_orders) {
  days_delivery <- sample(1:7, 1)
  d_date <- as.Date(logistics_dataset$Contact_Date[i]) + days_delivery
  if(d_date > end_date) d_date <- end_date
  if(as.POSIXlt(d_date)$wday == 0) d_date <- d_date + 1 # Shift Sunday to Monday
  delivery_dates[i] <- d_date
}
logistics_dataset$Delivery_Date <- delivery_dates

# Generate actual/exact execution dates (Incorporating real-world operational delivery lag probabilities)
exact_delivery_dates <- as.Date(character(n_orders))
for(i in 1:n_orders) {
  extra_delay <- sample(0:2, 1, prob = c(0.8, 0.15, 0.05))
  ed_date <- as.Date(logistics_dataset$Delivery_Date[i]) + extra_delay
  if(ed_date > end_date) ed_date <- end_date
  exact_delivery_dates[i] <- ed_date
}
logistics_dataset$Exact_Delivery_Date <- exact_delivery_dates

# Day-of-week extraction and linguistic standardization (Italian to English mapping)
days_it_en <- format(logistics_dataset$Delivery_Date, "%A")
days_map_it <- c(
  "domenica"="Sunday", "lunedì"="Monday", "martedì"="Tuesday", 
  "mercoledì"="Wednesday", "giovedì"="Thursday", "venerdì"="Friday", "sabato"="Saturday",
  "Sunday"="Sunday", "Monday"="Monday", "Tuesday"="Tuesday", 
  "Wednesday"="Wednesday", "Thursday"="Thursday", "Friday"="Friday", "Saturday"="Saturday"
)
logistics_dataset$Day_OfWeek <- unname(days_map_it[tolower(days_it_en)])
logistics_dataset$Day_OfWeek[is.na(logistics_dataset$Day_OfWeek)] <- format(logistics_dataset$Delivery_Date, "%A")

# Delivery time slot assignment (Accounting for weekend operational constraints and shorter Saturday windows)
standard_time_slots <- c("08:00-13:00", "14:00-18:00")
saturday_morning_slot <- "08:00-12:00"

is_saturday <- as.POSIXlt(logistics_dataset$Delivery_Date)$wday == 6
logistics_dataset$Delivery_Time_Slot <- character(n_orders)

normal_indices <- !is_saturday
logistics_dataset$Delivery_Time_Slot[normal_indices] <- sample(standard_time_slots, sum(normal_indices), replace = TRUE)

saturday_indices <- which(is_saturday)
n_saturday <- length(saturday_indices)
n_saturday_morning <- ceiling(n_saturday * 0.45)
if (n_saturday > 0) {
  saturday_morning_choice <- sample(saturday_indices, n_saturday_morning)
  logistics_dataset$Delivery_Time_Slot[saturday_morning_choice] <- saturday_morning_slot
  
  remaining_saturday_indices <- setdiff(saturday_indices, saturday_morning_choice)
  if (length(remaining_saturday_indices) > 0) {
    logistics_dataset$Delivery_Time_Slot[remaining_saturday_indices] <- sample(standard_time_slots, length(remaining_saturday_indices), replace = TRUE)
  }
}

# Stochastic modeling of exact arrival times using a Poisson arrival process within assigned windows
generate_poisson_time <- function(slot) {
  n <- length(slot)
  times <- character(n)
  
  for(i in 1:n) {
    s <- slot[i]
    if(s == "" || is.na(s)) {
      times[i] <- "0"
      next
    }
    if(s == "08:00-13:00") {
      start_min <- 8 * 60; duration <- 300
    } else if(s == "14:00-18:00") {
      start_min <- 14 * 60; duration <- 240
    } else if(s == "08:00-12:00") {
      start_min <- 8 * 60; duration <- 240
    } else {
      start_min <- 8 * 60; duration <- 300
    }
    
    offset <- rpois(1, lambda = duration / 2) %% duration
    total_minutes <- start_min + offset
    hour <- floor(total_minutes / 60)
    minute <- total_minutes %% 60
    times[i] <- sprintf("%02d:%02d", hour, minute)
  }
  return(times)
}

logistics_dataset$Exact_Delivery_Time <- generate_poisson_time(logistics_dataset$Delivery_Time_Slot)


###############################################################################
# 4. CUSTOMER COMMUNICATION FEATURES
###############################################################################

# Simulate contact attempts distribution prior to appointment confirmation
contact_probabilities <- c(0.80, 0.09, 0.06, 0.05)
logistics_dataset$Contact_Attempts <- sample(1:4, n_orders, replace = TRUE, prob = contact_probabilities)

contact_slots <- c("09:00-13:00", "15:00-19:00")
logistics_dataset$Contact_Time_Slot <- sample(contact_slots, n_orders, replace = TRUE)

# Generate exact contact timestamps, incorporating a 20% out-of-slot probability (early/late calls)
contact_times <- character(n_orders)
for(i in 1:n_orders) {
  out_of_slot <- runif(1) < 0.20
  if(out_of_slot) {
    extra_hour <- sample(c(6, 7, 20, 21), 1)
    extra_minute <- sample(0:59, 1)
    contact_times[i] <- sprintf("%02d:%02d", extra_hour, extra_minute)
  } else {
    slot_c <- logistics_dataset$Contact_Time_Slot[i]
    start_min <- ifelse(slot_c == "09:00-13:00", 9 * 60, 15 * 60)
    duration <- 240
    offset <- rpois(1, lambda = duration / 2) %% duration
    total_minutes <- start_min + offset
    hour <- floor(total_minutes / 60)
    minute <- total_minutes %% 60
    contact_times[i] <- sprintf("%02d:%02d", hour, minute)
  }
}
logistics_dataset$Exact_Contact_Time <- contact_times


###############################################################################
# 5. PRODUCT SPECIFICATIONS & RESOURCE ALLOCATION
###############################################################################

# Define product dimensional categories and probabilities
product_types <- c("Small", "Medium", "Large", "Bulky")
product_probabilities <- c(0.30, 0.40, 0.20, 0.10)
logistics_dataset$Product_Size <- sample(product_types, n_orders, replace = TRUE, prob = product_probabilities)

# Map categorical item descriptions based on physical size tiers
prod_small <- c("Decoder", "Modem", "Phone", "Accessories")
prod_medium <- c("Microwave", "Small Appliance")
prod_large <- c("TV up to 37\"", "Washing Machine", "Medium Appliance")
prod_bulky <- c("Refrigerator", "TV over 37\"", "Large Appliance")

specific_products <- character(n_orders)
for(i in 1:n_orders) {
  sz <- logistics_dataset$Product_Size[i]
  specific_products[i] <- switch(sz,
                                 "Small" = sample(prod_small, 1),
                                 "Medium" = sample(prod_medium, 1),
                                 "Large" = sample(prod_large, 1),
                                 "Bulky" = sample(prod_bulky, 1)
  )
}
logistics_dataset$Product_Item <- specific_products

# Define service types (Delivery only vs. Delivery & Installation)
services <- c("Delivery Only", "Delivery & Installation")
logistics_dataset$Service_Type <- sample(services, n_orders, replace = TRUE, prob = c(0.35, 0.65))

# Determine required operational crew size based on product dimensions and service complexity
required_personnel <- integer(n_orders)
for(i in 1:n_orders) {
  sz <- logistics_dataset$Product_Size[i]
  srv <- logistics_dataset$Service_Type[i]
  if(srv == "Delivery Only") {
    required_personnel[i] <- ifelse(sz %in% c("Small", "Medium", "Large"), 1, 2)
  } else { 
    required_personnel[i] <- ifelse(sz %in% c("Small", "Medium"), 1, 2)
  }
}
logistics_dataset$Personnel_Required <- required_personnel

# Assign Stock Keeping Unit (SKU) identifiers stratified by product class
n_pool_fake <- 100
product_codes_pool <- list(
  "Small" = sprintf("SKU-S-%03d", 1:n_pool_fake),
  "Medium" = sprintf("SKU-M-%03d", 1:n_pool_fake),
  "Large" = sprintf("SKU-L-%03d", 1:n_pool_fake),
  "Bulky" = sprintf("SKU-B-%03d", 1:n_pool_fake)
)

product_code <- character(n_orders)
for(sz in product_types) {
  idx <- which(logistics_dataset$Product_Size == sz)
  n_subset <- length(idx)
  if(n_subset > 0) {
    pool_subset <- product_codes_pool[[sz]]
    product_code[idx] <- sample(pool_subset, n_subset, replace = TRUE)
  }
}
logistics_dataset$Product_Code <- product_code


###############################################################################
# 6. RIGHT-CENSORING MECHANISM (ADMINISTRATIVE CUTOFF)
###############################################################################

# Implement right-censoring to simulate real-world unobserved or pending outcomes (25% censoring rate)
n_censored <- ceiling(n_orders * 0.25) 
date_ordering <- order(logistics_dataset$Order_Creation_Date)
censored_indices <- date_ordering[(n_orders - n_censored + 1):n_orders]

logistics_dataset$Censorship_Indicator <- 1
logistics_dataset$Censorship_Indicator[censored_indices] <- 0


###############################################################################
# 7. DYNAMIC INVENTORY SIMULATION (DEPLETION & REPLENISHMENT)
###############################################################################

logistics_dataset$Original_Index <- 1:n_orders
logistics_dataset <- logistics_dataset[order(logistics_dataset$Order_Creation_Date), ]

sku_stock_state <- list()
all_skus <- unique(logistics_dataset$Product_Code)
for(sku in all_skus) {
  sku_stock_state[[sku]] <- sample(40:80, 1)
}

# Simulate chronological inventory depletion per SKU with stochastic stock replenishment triggers (8% probability)
current_stocks <- numeric(n_orders)
for(i in 1:n_orders) {
  sku <- logistics_dataset$Product_Code[i]
  if(runif(1) < 0.08) { 
    sku_stock_state[[sku]] <- sku_stock_state[[sku]] + sample(30:60, 1)
  }
  
  current_stocks[i] <- max(0, sku_stock_state[[sku]])
  if(sku_stock_state[[sku]] > 0) {
    sku_stock_state[[sku]] <- sku_stock_state[[sku]] - 1
  }
}
logistics_dataset$Stock_Quantity <- current_stocks

logistics_dataset <- logistics_dataset[order(logistics_dataset$Original_Index), ]
logistics_dataset$Original_Index <- NULL


###############################################################################
# 8. MICROCLIMATE TEMPERATURE MODELING & CAUSAL DEPENDENCIES
###############################################################################

# Establish baseline regional temperatures across Italian provinces
province_temp_base <- runif(length(italian_provinces), min = 8, max = 18)
names(province_temp_base) <- italian_provinces
temp_base_province <- province_temp_base[logistics_dataset$Province]

exact_date_char <- as.character(logistics_dataset$Exact_Delivery_Date)
deliv_date_char <- as.character(logistics_dataset$Delivery_Date)
crea_date_char <- as.character(logistics_dataset$Order_Creation_Date)

temp_ref_date_pre <- as.Date(rep(NA, n_orders))
valid_exact_idx_pre <- which(exact_date_char != "0" & !is.na(logistics_dataset$Exact_Delivery_Date))
if(length(valid_exact_idx_pre) > 0) {
  temp_ref_date_pre[valid_exact_idx_pre] <- as.Date(logistics_dataset$Exact_Delivery_Date[valid_exact_idx_pre])
}
idx_zero_date_pre <- which(is.na(temp_ref_date_pre))
if(length(idx_zero_date_pre) > 0) {
  valid_deliv_idx_pre <- idx_zero_date_pre[deliv_date_char[idx_zero_date_pre] != "0" & !is.na(logistics_dataset$Delivery_Date[idx_zero_date_pre])]
  if(length(valid_deliv_idx_pre) > 0) {
    temp_ref_date_pre[valid_deliv_idx_pre] <- as.Date(logistics_dataset$Delivery_Date[valid_deliv_idx_pre])
  }
}
idx_zero_date2_pre <- which(is.na(temp_ref_date_pre))
if(length(idx_zero_date2_pre) > 0) {
  temp_ref_date_pre[idx_zero_date2_pre] <- as.Date(logistics_dataset$Order_Creation_Date[idx_zero_date2_pre])
}

# Apply seasonal monthly temperature offsets to simulate realistic annual thermal variance
delivery_months <- as.POSIXlt(temp_ref_date_pre)$mon + 1
seasonal_offset <- c(-5, -3, 3, 9, 15, 20, 23, 22, 16, 10, 4, -4) 
seasonal_temp <- temp_base_province + seasonal_offset[delivery_months]

# Incorporate diurnal temperature variations based on delivery execution window
delivery_hours <- as.numeric(substr(logistics_dataset$Exact_Delivery_Time, 1, 2))
delivery_hours[is.na(delivery_hours) | logistics_dataset$Exact_Delivery_Time == "0"] <- 10
is_rush_hour <- delivery_hours >= 12 & delivery_hours <= 16
time_adjustment <- ifelse(is_rush_hour, 3.5, -1.5)

# Generate final ambient temperature using additive Gaussian noise
raw_temperature <- seasonal_temp + time_adjustment + rnorm(n_orders, mean = 0, sd = 1.2)


###############################################################################
# 9. OPERATIONAL FAILURE MECHANISMS & OUTCOME SIMULATION
###############################################################################

delivery_outcome <- character(n_orders)
failure_reason <- character(n_orders)

base_motives_pool <- c(
  "Failed Appointment", 
  "Technical Installation Issue", 
  "Product Unavailable", 
  "Bad Weather", 
  "Traffic/Delay"
)

base_motives_weights <- c(0.31, 0.19, 0.14, 0.23, 0.13)

# Iterate through records to model multi-factorial operational failures and environmental dependencies
for(i in 1:n_orders) {
  if (logistics_dataset$Censorship_Indicator[i] == 0) {
    delivery_outcome[i] <- "Censored"
    failure_reason[i] <- "Censored (Out of Period / No Confirmation)"
    next
  }
  
  if (logistics_dataset$Stock_Quantity[i] == 0) {
    delivery_outcome[i] <- "Failed"
    failure_reason[i] <- "Product Unavailable"
    next
  }
  
  # Temperature-dependent failure risk model (higher failure probability under extreme thermal stress)
  t_val <- raw_temperature[i]
  p_fail_base <- 0.27
  if(t_val > 37.5 || t_val < -1.0) {
    p_fail <- 0.85 
  } else if(t_val > 35.0 || t_val < 2.0) {
    p_fail <- 0.50
  } else {
    p_fail <- p_fail_base
  }
  
  is_failed_i <- runif(1) < p_fail
  
  if(!is_failed_i) {
    delivery_outcome[i] <- "Successful"
    failure_reason[i] <- "None"
  } else {
    delivery_outcome[i] <- "Failed"
    
    if(t_val > 37.5 || t_val < -1.0) {
      chosen_motive <- "Bad Weather"
    } else if(logistics_dataset$ZTL_Restriction[i] == "ZTL - Special Permit Required" && runif(1) < 0.40) {
      chosen_motive <- "ZTL Permit Missing"
    } else {
      filtered_pool <- setdiff(base_motives_pool, "Product Unavailable")
      filtered_weights <- base_motives_weights[base_motives_pool != "Product Unavailable"]
      filtered_weights <- filtered_weights / sum(filtered_weights)
      chosen_motive <- sample(filtered_pool, 1, prob = filtered_weights)
    }
    
    if(chosen_motive == "Technical Installation Issue" && logistics_dataset$Service_Type[i] != "Delivery & Installation") {
      alternative_motives <- setdiff(base_motives_pool, c("Technical Installation Issue", "Product Unavailable"))
      alternative_weights <- base_motives_weights[!(base_motives_pool %in% c("Technical Installation Issue", "Product Unavailable"))]
      alternative_weights <- alternative_weights / sum(alternative_weights)
      chosen_motive <- sample(alternative_motives, 1, prob = alternative_weights)
    }
    
    failure_reason[i] <- chosen_motive
    
    # Adjust feature states conditionally upon specific failure classifications
    if(chosen_motive == "Failed Appointment") {
      logistics_dataset$Contact_Attempts[i] <- sample(2:4, 1)
      logistics_dataset$Delivery_Date[i] <- as.Date(NA)
      logistics_dataset$Day_OfWeek[i] <- "0"
      logistics_dataset$Delivery_Time_Slot[i] <- "0"
      logistics_dataset$Exact_Delivery_Date[i] <- as.Date(NA)
      logistics_dataset$Exact_Delivery_Time[i] <- "0"
    }
    
    if(chosen_motive == "Bad Weather") {
      logistics_dataset$Exact_Delivery_Date[i] <- as.Date(NA)
      logistics_dataset$Exact_Delivery_Time[i] <- "0"
    }
    
    if(chosen_motive == "Traffic/Delay") {
      logistics_dataset$Delivery_Date[i] <- as.Date(NA)
      logistics_dataset$Exact_Delivery_Time[i] <- "0"
      
      delay_days <- sample(1:3, 1)
      ref_date <- logistics_dataset$Exact_Delivery_Date[i]
      if(!is.na(ref_date)) {
        logistics_dataset$Exact_Delivery_Date[i] <- ref_date + delay_days
      }
      if(logistics_dataset$Contact_Attempts[i] == 1) {
        logistics_dataset$Contact_Attempts[i] <- sample(2:4, 1)
      }
    }
  }
}

logistics_dataset$Delivery_Status <- delivery_outcome
logistics_dataset$Failure_Reason <- failure_reason

# Format missing/censored temporal records for robust data handling
logistics_dataset$Delivery_Date[censored_indices] <- NA
logistics_dataset$Exact_Delivery_Date[censored_indices] <- NA
logistics_dataset$Exact_Delivery_Time[censored_indices] <- "0"
logistics_dataset$Day_OfWeek[censored_indices] <- "0"
logistics_dataset$Delivery_Time_Slot[censored_indices] <- "0"

logistics_dataset$Delivery_Date_char <- as.character(logistics_dataset$Delivery_Date)
logistics_dataset$Delivery_Date_char[is.na(logistics_dataset$Delivery_Date_char)] <- "0"

logistics_dataset$Exact_Delivery_Date_char <- as.character(logistics_dataset$Exact_Delivery_Date)
logistics_dataset$Exact_Delivery_Date_char[is.na(logistics_dataset$Exact_Delivery_Date_char)] <- "0"

logistics_dataset$Delivery_Date <- logistics_dataset$Delivery_Date_char
logistics_dataset$Exact_Delivery_Date <- logistics_dataset$Exact_Delivery_Date_char

logistics_dataset$Delivery_Date_char <- NULL
logistics_dataset$Exact_Delivery_Date_char <- NULL

logistics_dataset$Order_Creation_Date <- as.character(logistics_dataset$Order_Creation_Date)
logistics_dataset$Contact_Date <- as.character(logistics_dataset$Contact_Date)

failed_indices <- which(logistics_dataset$Delivery_Status == "Failed")
for(i in failed_indices) {
  if(logistics_dataset$Delivery_Date[i] == "0" || is.na(logistics_dataset$Delivery_Date[i])) {
    logistics_dataset$Delivery_Date[i] <- as.character(logistics_dataset$Exact_Delivery_Date[i])
  }
  logistics_dataset$Exact_Delivery_Time[i] <- "0"
}

# Appointment confirmation indicator setup
appointment_conf <- character(n_orders)
for(i in 1:n_orders) {
  if(logistics_dataset$Censorship_Indicator[i] == 0) {
    appointment_conf[i] <- "NOT_ORGANIZED"
  } else if(logistics_dataset$Failure_Reason[i] == "Failed Appointment") {
    appointment_conf[i] <- "NOT"
  } else {
    appointment_conf[i] <- sample(c("YES", "NOT"), 1, prob = c(0.85, 0.15))
  }
}
logistics_dataset$Appointment_Confirmation_Received <- appointment_conf


###############################################################################
# 10. SPATIAL DISTANCES & ENVIRONMENTAL FOOTPRINT CALCULATION
###############################################################################

# Generate delivery distances constrained to a realistic range (1-40 km via bounded Gaussian distribution)
delivery_distance_km <- round(rnorm(n_orders, mean = 20, sd = 7))
delivery_distance_km <- pmin(pmax(delivery_distance_km, 1), 40)
logistics_dataset$Delivery_Distance_KM <- delivery_distance_km

# Distance from primary logistics hub
master_addresses$Delivery_Distance_HUB_Km <- pmin(pmax(round(rnorm(nrow(master_addresses), mean = 25, sd = 10)), 1), 50)
logistics_dataset$Delivery_Distance_HUB_Km <- master_addresses$Delivery_Distance_HUB_Km[sampled_indices]

# CO2 emissions estimation using a standard emission factor (0.257 kg CO2/km)
kg_co2_val <- numeric(n_orders)

idx_success <- which(logistics_dataset$Delivery_Status == "Successful")
idx_cens <- which(logistics_dataset$Delivery_Status == "Censored")
idx_fail_upstream <- which(logistics_dataset$Failure_Reason %in% c("Product Unavailable", "Failed Appointment"))
idx_fail_road <- which(logistics_dataset$Failure_Reason %in% c("ZTL Permit Missing", "Traffic/Delay", "Bad Weather", "Technical Installation Issue"))

kg_co2_val[idx_success] <- 0.257 * logistics_dataset$Delivery_Distance_KM[idx_success]
kg_co2_val[idx_cens] <- 0 
kg_co2_val[idx_fail_upstream] <- 0
kg_co2_val[idx_fail_road] <- 0.257 * (logistics_dataset$Delivery_Distance_HUB_Km[idx_fail_road] + logistics_dataset$Delivery_Distance_KM[idx_fail_road])

logistics_dataset$kgCO2 <- kg_co2_val

final_temperature <- round(raw_temperature, 1)
final_temperature[logistics_dataset$Censorship_Indicator == 0] <- NA
logistics_dataset$Temperature_C <- final_temperature

# Annotate technical installation failures with specific descriptive categories
tech_issues_pool_en <- c(
  "electrical/hydraulic system modification required", 
  "electrical/hydraulic system upgrade required"
)

technical_details <- rep("None", n_orders)
idx_tech_issue <- which(logistics_dataset$Failure_Reason == "Technical Installation Issue")
if(length(idx_tech_issue) > 0) {
  technical_details[idx_tech_issue] <- sample(tech_issues_pool_en, length(idx_tech_issue), replace = TRUE)
}
logistics_dataset$Technical_Installation_Detail <- technical_details


###############################################################################
# 11. OPERATIONAL DRIVER WORKLOAD & HISTORICAL LAG FEATURE ENGINEERING
###############################################################################

# Simulate driver workload (cumulative completed deliveries within a time slot)
cumulative_deliveries <- integer(n_orders)
for(i in 1:n_orders) {
  slot <- logistics_dataset$Delivery_Time_Slot[i]
  time_str <- logistics_dataset$Exact_Delivery_Time[i]
  
  if(is.na(slot) || slot == "0" || is.na(time_str) || time_str == "0") {
    cumulative_deliveries[i] <- 0
    next
  }
  
  time_parts <- as.numeric(strsplit(time_str, ":")[[1]])
  current_minutes <- time_parts[1] * 60 + time_parts[2]
  
  if(slot %in% c("08:00-13:00", "08:00-12:00")) {
    max_deliveries <- 10
    start_min <- 8 * 60
    end_min <- ifelse(slot == "08:00-13:00", 13 * 60, 12 * 60)
  } else if(slot == "14:00-18:00") {
    max_deliveries <- 12
    start_min <- 14 * 60
    end_min <- 18 * 60
  } else {
    max_deliveries <- 10
    start_min <- 8 * 60
    end_min <- 13 * 60
  }
  
  slot_duration <- end_min - start_min
  progress <- (current_minutes - start_min) / slot_duration
  progress <- pmin(pmax(progress, 0), 1)
  
  dynamic_lambda <- max(0.5, progress * max_deliveries)
  weighted_value <- rpois(1, lambda = dynamic_lambda) + 1
  cumulative_deliveries[i] <- pmin(pmax(weighted_value, 1), max_deliveries)
}

logistics_dataset$Cumulative_Completed_Deliveries <- cumulative_deliveries

# Historical Address Failure Tracking (Generate lagged cumulative failure features per address)
temporal_order <- order(as.Date(logistics_dataset$Order_Creation_Date))
ordered_logistics_dataset <- logistics_dataset[temporal_order, ]

is_failure_numeric <- ifelse(ordered_logistics_dataset$Delivery_Status == "Failed", 1, 0)
historical_failures <- ave(is_failure_numeric, ordered_logistics_dataset$Address_ID, FUN = function(x) c(0, cumsum(x[-length(x)])))

ordered_logistics_dataset$Prior_Address_Failures <- historical_failures

logistics_dataset <- ordered_logistics_dataset[order(as.numeric(row.names(ordered_logistics_dataset))), ]
rownames(logistics_dataset) <- NULL
logistics_dataset$Address_ID <- NULL


###############################################################################
# 12. FINAL DATASET FORMATTING, ORDERING & QUALITY VALIDATION
###############################################################################

# Reorder columns into a structured, logical schema for analytical modeling
logistics_dataset <- logistics_dataset[, c(
  "ID_Delivery_Order", "Order_Creation_Date", "Censorship_Indicator", "City", "Postal_Code", "Province", "Street_Address",
  "Contact_Date", "Contact_Time_Slot", "Exact_Contact_Time", "Contact_Attempts", "Appointment_Confirmation_Received",
  "Delivery_Date", "Day_OfWeek", "ZTL_Restriction", "Delivery_Time_Slot", "Exact_Delivery_Date", "Exact_Delivery_Time",
  "Cumulative_Completed_Deliveries", "Prior_Address_Failures", "Product_Size", "Product_Item", "Service_Type", "Personnel_Required", "Product_Code", 
  "Stock_Quantity", "Delivery_Distance_KM", "Delivery_Status", "Failure_Reason", "Technical_Installation_Detail", 
  "Delivery_Distance_HUB_Km", "kgCO2", "Temperature_C"
)]

# Perform basic structural validation inspections
head(logistics_dataset)
dim(logistics_dataset)
table(logistics_dataset$Censorship_Indicator)


###############################################
# --- Data Export ---
###############################################
# Export the finalized, preprocessed synthetic logistics dataset into a structured 
# Microsoft Excel spreadsheet for downstream validation, sharing, and external analysis.
write_xlsx(logistics_dataset, "technical-courier-survival-dataset.xlsx")
# CSV spreadsheet for downstream validation, sharing, and external analysis.
write_csv(logistics_dataset, "technical-courier-survival-dataset.csv")


# -------------------------------------------------------------------------------------
# Creative Commons Attribution 4.0 International (CC BY 4.0)
# 
# The datasets contained in this repository (e.g., files in the data/ directory) 
# are licensed under the Creative Commons Attribution 4.0 International License.
# 
# To view a copy of this license, visit: http://creativecommons.org/licenses/by/4.0/
# 
# or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
# -------------------------------------------------------------------------------------