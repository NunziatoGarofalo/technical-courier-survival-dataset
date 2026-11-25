# Bibliography & Theoretical Framework

This project relies on open-source software libraries and established statistical/machine learning methodologies. Below is the complete list of software dependencies and foundational literature supporting the models and metrics used in this repository.

---

## 1. Statistical Methods for Survival Analysis
* **Kaplan-Meier Estimator**: Kaplan, E. L., & Meier, P. (1958). Nonparametric Estimation from Incomplete Observations. *Journal of the American Statistical Association*, 53(282), 457–481.
* **Nelson-Aalen Estimator**: Nelson, W. (1969). Hazard Plotting for Incomplete Failure Data. *Journal of Quality Technology*, 1(1), 27–52; Nelson, W. (1972). Theory and Applications of Hazard Plotting for Censored Failure Data. *Technometrics*, 14(4), 945–966.
* **Cox Proportional Hazards Model**: Cox, D. R. (1972). Regression Models and Life-Tables. *Journal of the Royal Statistical Society*, 34(2), 187–220; Cox, D. R., & Oakes, D. (1987). *Analysis of Survival Data*, Chapman & Hall/CRC.
* **Survival Modeling Reference**: Therneau, T. M., & Grambsch, P. M. (2000/2010). *Modeling Survival Data: Extending the Cox Model*, Springer New York.
* **Lasso Method**: Tibshirani, R. (1997). The Lasso Method for Variable Selection in the Cox Model. *Statistics in Medicine*, 16(4), 385–395.
* **Elastic Net**: Zou, H., & Hastie, T. (2005). Regularization and Variable Selection via the Elastic Net. *Journal of the Royal Statistical Society: Series B*, 67(2), 301–320.
* **Coordinate Descent for Cox Models**: Simon, N., Friedman, J., Hastie, T., & Tibshirani, R. (2011). Regularization Paths for Cox's Proportional Hazards Model via Coordinate Descent. *Journal of Statistical Software*, 39(5), 1–13.
* **Group Penalties / OSCAR**: Bondell, H. D., & Reich, B. J. (2008). Simultaneous Regression Shrinkage, Variable Selection, and Supervision of Grouping via ELASTIC NET with a Joint Penalty / OSCAR. *Biometrics*, 64(1), 115–123.
* **Survival Analysis Methods**: Wang, P., Y. Li, and C. K. Reddy (2019). “Machine Learning for Survival Analysis: A Survey”. In: ACM Comput. Surv. Vol. 51 No. 6. issn: 0360-0300. doi: 10.1145/3214306.

---

## 3. Machine Learning Methods for Survival Analysis
* **Random Survival Forests**: Ishwaran, H., Kogalur, U. B., Blackstone, E. H., & Lauer, M. S. (2008). Random Survival Forests. *The Annals of Applied Statistics*, 2(3), 841–860.
* **Gradient Boosting Machines**: Friedman, J. H. (2001). Greedy function approximation: A gradient boosting machine. *The Annals of Statistics*, 29(5), 1189–1232.
* **XGBoost Framework**: Chen, T., & Guestrin, C. (2016). XGBoost: A Scalable Tree Boosting System. *Proceedings of the 22nd ACM SIGKDD Conference on Knowledge Discovery and Data Mining*, 785–794.

---

## 4. Model Performance, Evaluation & Validation Metrics
* **Performance Framework**: Steyerberg, E. W., et al. (2010). Assessing the performance of prediction models: a framework for traditional and novel measures. *Epidemiology*, 21(1), 128–138.
* **Concordance Index (C-index)**: Harrell, F. E., Califf, R. M., Pryor, D. B., Lee, K. L., & Rosati, R. A. (1982). Evaluating the Yield of Medical Tests. *JAMA*, 247(18), 2543–2546.
* **Brier Score**: Brier, G. W. (1950). Verification of Forecasts Expressed in Terms of Probability. *Monthly Weather Review*, 78(1), 1–3.
* **Expected Brier Score for Survival Models**: Graf, E., Schmoor, C., Sauerbrei, W., & Schumacher, M. (1999). Assessment and Comparison of Prognostic Classification Schemes for Survival Data. *Statistics in Medicine*, 18(17-18), 2529–2545; Gerds, T. A., & Schumacher, M. (2006). Consistent Estimation of the Expected Brier Score in General Survival Models with Right-Censored Data. *Biometrical Journal*, 48(6), 1029–1040.
* **Time-Dependent ROC Curves**: Heagerty, P. J., Lumley, T., & Pepe, M. S. (2000). Time-Dependent ROC Curves for Censored Survival Data and a Diagnostic Marker. *Biometrics*, 56(2), 337–344.
* **Explained Variation / R-squared**: Nagelkerke, N. J. D. (1991). A Note on a General Definition of the Coefficient of Determination. *Biometrika*, 78(3), 691–692; O'Quigley, J., & Xu, R. (2005). Explained Variation in Survival Analysis. *Journal of Statistical Planning and Inference*, 133(2), 337–361.

---

## 5. Packages (R & Python) for Survival Analysis, Statistical Analysis, Data Manipulation and Visualization

### 5.1. Standards & Datasets Context
* **ISO Standard**: International Organization for Standardization (2023). *ISO 14083:2023 -- Greenhouse gases -- Quantification and reporting of greenhouse gas emissions arising from transport chain operations*.
* **GHG Reporting**: Department for Environment, Food & Rural Affairs (2026). *Greenhouse gas reporting: conversion factors 2026*. UK Government.
* **Eurostat Data**: Eurostat (2026). *Value of e-commerce sales by size class of enterprise*. URL: <https://doi.org/10.2908/ISOC_EC_EVALS>.

### 5.2. Core R Software Packages
#### 5.2.1. Core Data Manipulation & I/O
* **dplyr**: Wickham H, François R, Henry L, Müller K, Vaughan D (2023). *dplyr: A Grammar of Data Manipulation*. R package version 1.1.4, <https://CRAN.R-project.org/package=dplyr>.
* **plyr**: Wickham H (2011). *The Split-Apply-Combine Strategy for Data Analysis*. Journal of Statistical Software, 40(1), 1–29. <https://www.jstatsoft.org/v40/i01/>.
* **tidyverse**: Wickham H et al. (2019). *Welcome to the tidyverse*. Journal of Open Source Software, 4(43), 1686, <https://doi.org/10.21105/joss.01686>.
* **MASS**: Venables WN, Ripley BD (2002). *Modern Applied Statistics with S*. Fourth Edition. Springer, New York. ISBN 0-387-95457-0.
* **writexl**: Ooms J (2024). *writexl: Export Data Frames to Excel 'xlsx' Format*. R package version 1.5.1, <https://CRAN.R-project.org/package=writexl>.
* **readxl**: Wickham H, Bryan J (2023). *readxl: Read Excel Files*. R package version 1.4.3, <https://CRAN.R-project.org/package=readxl>.

---

#### 5.2.2. Statistical & Machine Learning Models for Survival Analysis
* **survival**: Therneau TM (2023). *A Package for Survival Analysis in R*. R package version 3.5-7, <https://CRAN.R-project.org/package=survival>.
* **survminer**: Kassambara A, Kosinski M, Biecek P (2021). *survminer: Drawing Survival Curves using 'ggplot2'*. R package version 0.4.9, <https://CRAN.R-project.org/package=survminer>.
* **glmnet**: Friedman J, Hastie T, Tibshirani R (2010). *Regularization Paths for Generalized Linear Models via Coordinate Descent*. Journal of Statistical Software, 33(1), 1–22. <https://www.jstatsoft.org/v33/i01/>.
* **pec**: Gerds TA (2023). *pec: Prediction Error Curves for Risk Prediction Models in Survival Analysis*. R package version 2023.04.12, <https://CRAN.R-project.org/package=pec>.
* **ranger**: Wright MN, Ziegler A (2017). *ranger: A Fast Implementation of Random Forests for High Dimensional Data in C++ and R*. Journal of Statistical Software, 77(1), 1–17. <https://doi.org/10.18637/jss.v077.i01>.
* **xgboost**: Chen T et al. (2023). *xgboost: Extreme Gradient Boosting*. R package version 1.7.5.1, <https://CRAN.R-project.org/package=xgboost>.
* **timeROC**: Blanche P (2023). *timeROC: Time-dependent ROC curve and AUC for censored survival data*. R package version 0.4, <https://CRAN.R-project.org/package=timeROC>.
* **DALEX**: Biecek P (2018). *DALEX: Explainable Machine Learning in R*. Journal of Machine Learning Research, 19(84), 1–5. <https://jmlr.org/papers/v19/18-416.html>.

---

#### 5.2.3. Visualization, Theming & Exploratory Plots
* **ggplot2**: Wickham H (2016). *ggplot2: Elegant Graphics for Data Analysis*. Springer-Verlag New York. ISBN 978-3-319-24277-4, <https://ggplot2.tidyverse.org>.
* **viridis**: Garnier S et al. (2024). *viridis (Lite) - Colorblind-Friendly Color Maps for R*. R package version 0.6.5, <https://CRAN.R-project.org/package=viridis>.
* **ggpubr**: Kassambara A (2023). *ggpubr: 'ggplot2' Based Publication Ready Plots*. R package version 0.6.0, <https://CRAN.R-project.org/package=ggpubr>.
* **ggcorrplot**: Kassambara A (2023). *ggcorrplot: Visualization of a Correlation Matrix using 'ggplot2'*. R package version 0.1.4.1, <https://CRAN.R-project.org/package=ggcorrplot>.
* **GGally**: Schloerke B et al. (2024). *GGally: Extension to 'ggplot2'*. R package version 2.2.1, <https://CRAN.R-project.org/package=GGally>.
* **gridGraphics**: Auguie B (2023). *gridGraphics: Redraw Base Graphics Using 'grid' Graphics*. R package version 0.5-1, <https://CRAN.R-project.org/package=gridGraphics>.
* **reshape2**: Wickham H (2007). *Reshaping Data with the reshape Package*. Journal of Statistical Software, 21(12), 1–20. <https://www.jstatsoft.org/v21/i12/>.

---

#### 5.2.4. Reporting & LaTeX Export
* **xtable**: Dahl DB, Scott D, Roosen C, Magnusson A, Swinton J (2019). *xtable: Export Tables to LaTeX or HTML*. R package version 1.8-4, <https://CRAN.R-project.org/package=xtable>.

---

#### 5.2.5. Python Integration (Reticulate & Modules)
* **reticulate**: Ushey K, Allaire JJ, Tang Y (2024). *reticulate: Interface to 'Python'*. R package version 1.38.0, <https://CRAN.R-project.org/package=reticulate>.
* **pandas**: McKinney W (2010). *Data Structures for Statistical Computing in Python*. Proceedings of the 9th Python in Science Conference, 56–61.
* **numpy**: Harris CR et al. (2020). *Array programming with NumPy*. Nature, 585(7825), 357–362. <https://doi.org/10.1038/s41586-020-2649-2>.
* **matplotlib**: Hunter JD (2007). *Matplotlib: A 2D Graphics Environment*. Computing in Science & Engineering, 9(3), 90–95. <https://doi.org/10.1109/MCSE.2007.55>.
* **seaborn**: Waskom ML (2021). *seaborn: statistical data visualization*. Journal of Open Source Software, 6(60), 3021. <https://doi.org/10.21105/joss.03021>.
