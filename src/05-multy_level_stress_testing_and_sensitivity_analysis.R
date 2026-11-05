
################################################################################################
#
# Official dataset and resources for the paper: 
# "Predicting Delivery Failures in Technical Courier Services: 
# A Survival Learning Approach for Sustainable Last-Mile Logistics".
#
#################################################################################################
#
# ==============================================================================
# METHODOLOGICAL NOTE & RESEARCH CONTEXT:
# ------------------------------------------------------------------------------
# This script implements a multi-level stress-testing and sensitivity analysis 
# pipeline to rigorously evaluate the robustness, stability, and predictive 
# discrimination of a Telemetry-Enhanced Random Survival Forest (RSF) model. 
# 
# By systematically introducing controlled, progressive stochastic perturbations 
# across microclimatic variables (ambient thermal stress/heatwaves), spatial 
# routing constraints (distance amplification and carbon footprint scaling via kgCO2), 
# and regulatory bottlenecks (restricted ZTL urban access failures), this framework 
# simulates severe operational degradation scenarios. 
# 
# The pipeline tracks out-of-sample concordance (Out-of-Bag C-index) and 
# permutation-based variable importance (VIMP) shifts across varying stress 
# intensity factors (ranging from baseline $\gamma = 1.0$ to severe $\gamma = 3.0$), 
# offering empirical validation of the model's resilience under extreme conditions.
# ==============================================================================

# ==============================================================================
# MULTI-LEVEL PERTURBATION SENSITIVITY ANALYSIS & RSF EVALUATION PIPELINE
# ==============================================================================
library(readxl)
library(survival)
library(ranger)
library(ggplot2)

# 1. Load the baseline dataset
logistics_dataset_orig <- read_excel("technical-courier-survival-dataset.xlsx")

# Define distinct perturbation intensity factors to simulate progressive stress scenarios
# Factor 1.0 = Mild/Baseline Stress, 2.0 = Moderate Stress, 3.0 = Severe Stress
intensity_factors <- c(1.0, 1.5, 2.0, 2.5, 3.0)
sensitivity_results_list <- list()

cat("==============================================================================\n")
cat(" STARTING MULTI-LEVEL STRESS TESTING SENSITIVITY ANALYSIS\n")
cat("==============================================================================\n")

for (factor_val in intensity_factors) {
  
  cat(sprintf("\n[PROCESSING] Evaluating Perturbation Intensity Factor: %.1f\n", factor_val))
  
  # Create a deep copy of the original dataset for each iteration
  ds <- logistics_dataset_orig
  n_obs <- nrow(ds)
  
  set.seed(1276)
  
  # A. Progressive Microclimatic Stress (Scaling temperature increments)
  heatwave_idx <- sample(1:n_obs, size = ceiling(n_obs * 0.25))
  ds$Temperature_C[heatwave_idx] <- ds$Temperature_C[heatwave_idx] + (runif(length(heatwave_idx), min = 4, max = 8) * factor_val)
  
  # B. Progressive Spatial & Environmental Stress (Scaling delivery detours and CO2)
  ds$Delivery_Distance_KM[heatwave_idx] <- ds$Delivery_Distance_KM[heatwave_idx] * (1 + 0.2 * factor_val)
  ds$kgCO2 <- 0.257 * ds$Delivery_Distance_KM
  
  # C. Progressive Operational Failure Injection (ZTL and extreme thermal failures)
  ztl_stressed <- which(ds$ZTL_Restriction == "ZTL - Special Permit Required" & ds$Temperature_C > (40 - 3 * factor_val))
  if(length(ztl_stressed) > 0) {
    ds$Delivery_Status[ztl_stressed] <- "Failed"
    ds$Failure_Reason[ztl_stressed] <- "Severe Weather / ZTL Congestion"
  }
  
  # Re-derive right-censoring and final binary event indicators
  ds$status <- ifelse(ds$Censorship_Indicator == 0, 0,
                      ifelse(ds$Delivery_Status == "Failed", 1, 0))
  
  # Data hygiene and time-to-event parsing
  exact_date_clean <- as.Date(ifelse(ds$Exact_Delivery_Date == "0", NA, ds$Exact_Delivery_Date))
  delivery_date_clean <- as.Date(ifelse(ds$Delivery_Date == "0", NA, ds$Delivery_Date))
  order_date <- as.Date(ds$Order_Creation_Date)
  
  max_obs_date <- max(order_date, na.rm = TRUE) + 30
  final_date <- exact_date_clean
  final_date[is.na(final_date)] <- delivery_date_clean[is.na(final_date)]
  final_date[is.na(final_date) & ds$Censorship_Indicator == 0] <- max_obs_date
  final_date[is.na(final_date)] <- order_date[is.na(final_date)] + 5
  
  ds$time_to_event <- as.numeric(final_date - order_date)
  ds$time_to_event[ds$time_to_event <= 0] <- 1
  
  # Feature selection incorporating telemetry
  enhanced_features <- c(
    "Service_Type", "Product_Size", "Product_Item", "Personnel_Required",
    "ZTL_Restriction", "Delivery_Distance_KM", "Stock_Quantity", 
    "Prior_Address_Failures", "Temperature_C", "kgCO2",
    "time_to_event", "status"
  )
  
  df_sub <- ds[, intersect(names(ds), enhanced_features)]
  
  # Factor encoding
  cat_vars <- c("Service_Type", "Product_Size", "Product_Item", "ZTL_Restriction")
  for(col in intersect(cat_vars, names(df_sub))) {
    df_sub[[col]] <- addNA(as.factor(df_sub[[col]]))
    levels(df_sub[[col]])[is.na(levels(df_sub[[col]]))] <- "Missing"
  }
  
  df_clean <- df_sub[!is.na(df_sub$time_to_event) & !is.na(df_sub$status), ]
  
  # Stratified partitioning (70% Train / 30% Test)
  set.seed(1276)
  train_idx <- sample(1:nrow(df_clean), size = 0.7 * nrow(df_clean))
  train_d <- df_clean[train_idx, ]
  test_d  <- df_clean[-train_idx, ]
  
  # Median imputation on training split
  num_vars <- c("Delivery_Distance_KM", "Stock_Quantity", "Prior_Address_Failures", "Personnel_Required", "Temperature_C", "kgCO2")
  for(v in intersect(num_vars, names(train_d))) {
    med_val <- median(train_d[[v]], na.rm = TRUE)
    train_d[[v]][is.na(train_d[[v]])] <- med_val
    test_d[[v]][is.na(test_d[[v]])]   <- med_val
  }
  
  # Train Enhanced RSF Model
  set.seed(1276)
  rsf_model_sens <- ranger(
    Surv(time_to_event, status) ~ ., 
    data = train_d,
    num.trees = 300,
    splitrule = "logrank",
    importance = "permutation",
    max.depth = 12,
    seed = 1276,
    respect.unordered.factors = "order"
  )
  
  # Extract performance and variable importance metrics
  oob_c_index <- 1 - rsf_model_sens$prediction.error
  
  vimp_raw <- importance(rsf_model_sens)
  top_feature <- names(which.max(vimp_raw))
  top_vimp_val <- max(vimp_raw)
  temp_vimp_val <- ifelse("Temperature_C" %in% names(vimp_raw), vimp_raw["Temperature_C"], NA)
  co2_vimp_val  <- ifelse("kgCO2" %in% names(vimp_raw), vimp_raw["kgCO2"], NA)
  
  # Store summary row
  sensitivity_results_list[[as.character(factor_val)]] <- data.frame(
    Perturbation_Factor = factor_val,
    OOB_C_Index = oob_c_index,
    Top_Predictor = top_feature,
    Temperature_VIMP = temp_vimp_val,
    CO2_VIMP = co2_vimp_val
  )
}

# Combine results into a final sensitivity summary table
final_sensitivity_table <- do.call(rbind, sensitivity_results_list)
rownames(final_sensitivity_table) <- NULL

cat("\n==============================================================================\n")
cat(" SENSITIVITY ANALYSIS SUMMARY ACROSS PERTURBATION LEVELS\n")
cat("==============================================================================\n")
print(format(final_sensitivity_table, digits = 4, justify = "right"))

# Visualize C-index degradation across perturbation intensity levels
p_sensitivity <- ggplot(final_sensitivity_table, aes(x = Perturbation_Factor, y = OOB_C_Index)) +
  geom_line(color = "#3b1353", linewidth = 1.2) +
  geom_point(color = "#ff7f0e", size = 3) +
  theme_bw(base_size = 12) +
  labs(
    title = "Model Discrimination Robustness Under Multi-Level Perturbations",
    subtitle = "Out-of-Bag C-index degradation trend across stress intensity factors",
    x = "Perturbation Intensity Factor",
    y = "Out-of-Bag C-Index"
  ) +
  theme(plot.title = element_text(face = "bold"), panel.grid.minor = element_blank())

print(p_sensitivity)
pdf("RSF_Sensitivity_Analysis_Cindex.pdf", width = 8, height = 5)
print(p_sensitivity)
dev.off()

cat("\n[SUCCESS] Multi-level stress testing completed and saved to 'RSF_Sensitivity_Analysis_Cindex.pdf'!\n")