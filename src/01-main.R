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
source("synthetic_dataset.R", local = FALSE)
cat("-> Step 1 completed successfully.\n\n")


# ------------------------------------------------------------------------------
# STEP 2: EXPLORATORY DATA ANALYSIS (EDA) & VISUALIZATION PROFILING
# Description: Computes univariate distributions, correlation matrices, box-plot 
#              strata, and multivariate scatter plots, exporting vector PDFs.
# ------------------------------------------------------------------------------
cat("-> Executing Step 2: Exploratory Data Analysis & Visualization...\n")
source("Descriptive analysis.R", local = FALSE)
cat("-> Step 2 completed successfully. All EDA plots exported.\n\n")


# ------------------------------------------------------------------------------
# STEP 3: SURVIVAL ANALYSIS, BENCHMARKING, & MACHINE LEARNING PIPELINE
# Description: Fits semiparametric Cox models, penalized variants (Ridge, Lasso, 
#              Elastic Net, Oscar), and non-parametric ML ensembles (RSF, Bagging, 
#              Boosting), generating performance tables and diagnostic plots.
# ------------------------------------------------------------------------------
cat("-> Executing Step 3: Survival Analysis & Model Benchmarking...\n")
source("Survival Analysis.R", local = FALSE)
cat("-> Step 3 completed successfully. All metrics and models evaluated.\n\n")


cat("========================================================\n")
cat("          FULL PIPELINE EXECUTION FINISHED             \n")
cat("========================================================\n")




