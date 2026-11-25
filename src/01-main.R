
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

################################################################################################
#
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
#
################################################################################
# TITLE: Environment Setup, Package Management, and Dependencies
# DESCRIPTION: Unified setup block handling R and Python libraries, automated 
#              package installation checks, and global reproducibility seed.
################################################################################

# ==============================================================================
# 1. AUTOMATED PACKAGE INSTALLATION AND CATEGORIZED LOADING (R LIBRARIES)
# ==============================================================================

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
  install.packages(all_packages[!installed_packages], dependencies = TRUE)}

# --- A. Data Wrangling & Manipulation ---
library(dplyr)
library(plyr)
library(tidyverse)
library(MASS)
library(writexl)
library(readxl)

# --- B. Statistical Survival Analysis & Machine Learning ---
library(survival)
library(survminer)
library(glmnet)
library(pec)
library(ranger)
library(xgboost)
library(timeROC)
library(DALEX)

# --- C. Visualization, Theming & Exploratory Plots ---
library(ggplot2)
library(viridis)
library(ggpubr)
library(ggcorrplot)
library(GGally)
library(gridGraphics)
library(reshape2)

# --- D. Reporting & LaTeX Export ---
library(xtable)


# ==============================================================================
# 2. PYTHON ENVIRONMENT INTEGRATION (RETICULATE)
# ==============================================================================

library(reticulate)

# Verify loaded Python configuration
py_config()

# Optional: Uncomment if root permissions/environment setup allows library installation via Python
# py_install("pandas")
# py_install("numpy")
# py_install("matplotlib")
# py_install("seaborn")

# Import Python modules into R session namespace
pd  <- import('pandas')
np  <- import('numpy')
mpl <- import('matplotlib')
plt <- import('matplotlib.pyplot')
sns <- import('seaborn')


# ==============================================================================
# 3. GLOBAL REPRODUCIBILITY SETUP
# ==============================================================================
set.seed(123456789)

# Print session info for audit logging and manuscript reproducibility records
sessionInfo()

# ==============================================================================
# MAIN EXECUTION PIPELINE FOR LOGISTICS FAILURE FORECASTING
# Description: Orchestrates the end-to-end workflow by sequentially executing 
#              the modular pipeline scripts: synthetic data generation, 
#              exploratory data analysis (EDA), and survival model benchmarking.
# ==============================================================================

cat("\n========================================================\n")
cat(" PIPELINE INITIALIZATION & ENVIRONMENT SETUP COMPLETE \n")
cat("========================================================\n\n")


# ------------------------------------------------------------------------------
# STEP 1: SYNTHETIC DATASET GENERATION & STRUCTURE INITIALIZATION
# Description: Executes data simulation routines, defining baseline distributions, 
#              covariates, and right-censoring mechanics.
# ------------------------------------------------------------------------------
cat("-> Executing Step 1: Synthetic Dataset Generation...\n")
source("02-synthetic_dataset.R", local = FALSE)
cat("-> Step 1 completed successfully.\n\n")


# ------------------------------------------------------------------------------
# STEP 2: EXPLORATORY DATA ANALYSIS (EDA) & VISUALIZATION PROFILING
# Description: Computes univariate distributions, correlation matrices, box-plot 
#              strata, and multivariate scatter plots, exporting vector PDFs.
# ------------------------------------------------------------------------------
cat("-> Executing Step 2: Exploratory Data Analysis & Visualization...\n")
source("03-descriptive_analysis.R", local = FALSE)
cat("-> Step 2 completed successfully. All EDA plots exported.\n\n")


# ------------------------------------------------------------------------------
# STEP 3: SURVIVAL ANALYSIS, BENCHMARKING, & MACHINE LEARNING PIPELINE
# Description: Fits semiparametric Cox models, penalized variants (Ridge, Lasso, 
#              Elastic Net, Oscar), and non-parametric ML ensembles (RSF, Bagging, 
#              Boosting), generating performance tables and diagnostic plots.
# ------------------------------------------------------------------------------
cat("-> Executing Step 3: Survival Analysis & Model Benchmarking...\n")
source("04-survival_analysis.R", local = FALSE)
cat("-> Step 3 completed successfully. All metrics and models evaluated.\n\n")


# ------------------------------------------------------------------------------
# STEP 4: MULTI-LEVEL STRESS-TESTING AND SENSITIVITY ANALYSIS 
# pipeline to rigorously evaluate the robustness, stability, and predictive 
# discrimination of a Telemetry-Enhanced Random Survival Forest (RSF) model
# ------------------------------------------------------------------------------
cat("-> Executing Step 4: Multi-level stress-testing and sensitivity analysis Benchmarking...\n")
source("05-multy_level_stress_testing_and_sensitivity_analysis.R", local = FALSE)
cat("-> Step 4 completed successfully. Multi-level stress-testing and sensitivity analysis evaluated.\n\n")

# ------------------------------------------------------------------------------
# STEP 5: REAL-TIME DYNAMIC SURVIVAL STREAMING AND CO2 SAVINGS ASSESSMENT
# pipeline to simulate live streaming orders, evaluate dynamic risk scoring, 
# and quantify carbon emission savings under ISO 14083:2023 guidelines
# ------------------------------------------------------------------------------
cat("-> Executing Step 5: Real-time dynamic survival streaming and CO2 savings assessment...\n")
source("06-Real_time_dynamic_survival_streaming_and_CO2_savings_assessment.R", local = FALSE)
cat("-> Step 5 completed successfully. Real-time dynamic survival streaming and carbon-saving impact assessed.\n\n")


cat("========================================================\n")
cat("          FULL PIPELINE EXECUTION FINISHED             \n")
cat("========================================================\n")




