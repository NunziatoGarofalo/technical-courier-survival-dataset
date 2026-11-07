
################################################################################################
#
# Official dataset and resources for the paper: 
# "Predicting Delivery Failures in Technical Courier Services: 
# A Survival Learning Approach for Sustainable Last-Mile Logistics".
#
################################################################################################
#
# TITLE: Exploratory Data Analysis, Statistical Distributions, and Multivariate 
#        Visualizations for Last-Mile Logistics Failure Forecasting
#
# DESCRIPTION: Comprehensive R script for exploratory data analysis (EDA) and 
#              statistical profiling of logistics operational datasets. Features:
#              - Univariate density and histogram profiling of continuous variables.
#              - Non-parametric box-plot stratification across operational categories 
#                and failure causes.
#              - Censoring analysis, frequency summarization of failure drivers, 
#                and binary target distribution mapping.
#              - Spearman rank-order correlation matrix with statistical significance 
#                thresholding (p < 0.05).
#              - Multivariate scatter-plot analysis on sampled subsets examining 
#                CO2 emissions, environmental factors, productivity curves, and 
#                geospatial delivery constraints.
#              - Export of publication-grade vector graphics in PDF format via cairo_pdf.
#
################################################################################################
#
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
#
# ==============================================================================
# LOAD LOGISTICS DATASET FROM EXTERNAL EXCEL STORAGE & MEMORY CLEANUP
# ==============================================================================

library(readxl)

# Read the previously exported dataset from disk
logistics_dataset <- read_excel("technical-courier-survival-dataset.xlsx")

# Optional: ensure date columns are properly parsed back as Date objects if needed
logistics_dataset$Order_Creation_Date <- as.Date(logistics_dataset$Order_Creation_Date)


###############################################################################
# 1. UNIVARIATE DISTRIBUTIONS (EXPLORATORY DATA ANALYSIS)
# Description: Evaluates the empirical density and distributional properties 
#              of key continuous features including temperature, gas emissions, 
#              and delivery distances.
###############################################################################

# --- Distribution: Air Temperature ---
AA <- ggplot(logistics_dataset, aes(x = Temperature_C)) + 
  geom_histogram(aes(y = ..density..), bins = 15, color = NA, fill = rev(viridis(15))) +
  geom_density(fill = "grey55", color = "grey80", alpha = 0.2) +
  theme_minimal(base_size = 9) +
  labs(
    x = "Air Temperature [°C]",
    y = "Density"
  )+
  theme(
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 9)
  )

AA
ggsave(filename = "AirTemperatureDistribution.pdf" , plot = AA, width = 3.35, height = 3.0, units = "in", device = cairo_pdf())

# --- Distribution: Gas Emissions (kgCO2) ---
BB <- ggplot(logistics_dataset, aes(x = kgCO2)) + 
  geom_histogram(aes(y = ..density..), bins = 15, color = NA, fill = rev(viridis(15))) +
  geom_density(fill = "grey55", color = "grey80", alpha = 0.2) +
  theme_minimal(base_size = 9) +
  labs(
    x = expression("Gas Emissions [kg" * CO[2] * "]"),
    y = "Density"
  )+
  theme(
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 9)
  ) 

BB
ggsave(filename = "GasEmission Distribution.pdf" , plot = BB, width = 3.35, height = 3.0, units = "in", device = cairo_pdf())

# --- Distribution: Distance from HUB ---
CC <- ggplot(logistics_dataset, aes(x = Delivery_Distance_HUB_Km)) + 
  geom_histogram(aes(y = ..density..), bins = 15, color = NA, fill = rev(viridis(15))) +
  geom_density(fill = "grey55", color = "grey80", alpha = 0.2) +
  theme_minimal(base_size = 9) +
  labs(
    x = "Distance from HUB [km]",
    y = "Density"
  )+
  theme(
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 9)
  ) 

CC
ggsave(filename = "Deliverydistancedistribution.pdf" , plot = CC, width = 3.35, height = 3.0, units = "in", device = cairo_pdf())

# --- Distribution: Final Delivery Distance ---
DD <- ggplot(logistics_dataset, aes(x = Delivery_Distance_KM)) + 
  geom_histogram(aes(y = ..density..), bins = 15, color = NA, fill = rev(viridis(15))) +
  geom_density(fill = "grey55", color = "grey80", alpha = 0.2) +
  theme_minimal(base_size = 9) +
  labs(
    x = "Delivery Distance [km]",
    y = "Density"
  )+
  theme(
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 9)
  ) 

DD
ggsave(filename = "DeliveryDistribution.pdf" , plot = DD, width = 3.35, height = 3.0, units = "in", device = cairo_pdf())

# --- Distribution: Stock Quantity ---
EE <- ggplot(logistics_dataset, aes(x = Stock_Quantity)) + 
  geom_histogram(aes(y = ..density..), bins = 15, color = NA, fill = rev(viridis(15))) +
  geom_density(fill = "grey55", color = "grey80", alpha = 0.2) +
  theme_minimal(base_size = 9) +
  labs(
    x = "Stock Quantity [pcs]",
    y = "Density"
  )+
  theme(
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 9)
  ) 

EE
ggsave(filename = "Stockdistribution.pdf" , plot = EE, width = 3.35, height = 3.0, units = "in", device = cairo_pdf())


###############################################################################
# 2. BOX-PLOT ANALYSIS ACROSS CATEGORICAL VARIABLES
# Description: Examines structural dispersion and median differences across 
#              operational strata, failure causes, and delivery statuses.
###############################################################################

# --- Box-Plot: Air Temperature by Failure Reason ---
A <- ggplot(logistics_dataset, aes(x = Failure_Reason, y = Temperature_C, fill = Failure_Reason)) +
  geom_boxplot(
    alpha = 0.65, 
    color = "black", 
    fatten = 1.2,
    outlier.colour = "black", 
    outlier.shape = 16, 
    outlier.size = 2
  ) +
  scale_fill_viridis(discrete = TRUE, option = "D") +
  theme_minimal(base_size = 9) +
  labs(
    x = "Failure Reason",
    y = "Temperature [°C]",
    fill = "Failure Reason"
  )+
  theme(
    legend.position = "bottom",
    legend.background = element_rect(linewidth = 0.8, linetype = "solid"), 
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 9),
    plot.title = element_text(size = 9),
    plot.subtitle = element_text(size = 9),
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 9),
    strip.text = element_text(size = 9)
  ) 

A
ggsave(filename = "BoxPlotAir Temperature.pdf" , plot = A, width = 20.0, height = 10.0, units = "in", device = cairo_pdf())

# --- Box-Plot: Stock Quantity by Failure Reason ---
B <- ggplot(logistics_dataset, aes(x = Failure_Reason, y = Stock_Quantity, fill = Failure_Reason)) +
  geom_boxplot(
    alpha = 0.65, 
    color = "black", 
    fatten = 1.2,
    outlier.colour = "black", 
    outlier.shape = 16, 
    outlier.size = 2
  ) +
  scale_fill_viridis(discrete = TRUE, option = "D") +
  theme_minimal(base_size = 9) +
  labs(
    x = "Failure Reason",
    y = "Stock Quantity [pcs]",
    fill = "Failure Reason"
  ) +
  theme(
    legend.position = "bottom",
    legend.background = element_rect(linewidth = 0.8, linetype = "solid"), 
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 9),
    plot.title = element_text(size = 9),
    plot.subtitle = element_text(size = 9),
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 9),
    strip.text = element_text(size = 9)
  ) 

B
ggsave(filename = "Box Plot stock.pdf", plot = B, width = 20.0, height = 10.0, units = "in", device = cairo_pdf())

# --- Box-Plot: Personnel Required by Product Size ---
C <- ggplot(logistics_dataset, aes(x = Product_Size, y = Personnel_Required, fill = Product_Size)) +
  geom_boxplot(outlier.colour = "black", outlier.shape = 16, outlier.size = 2) +
  scale_fill_viridis(discrete = TRUE, option = "D") +
  theme_minimal(base_size = 9) +
  labs(
    x = "Product Size",
    y = "Personnel Required",
    fill = "Product Size"
  ) +
  theme(
    legend.position = "bottom",
    legend.background = element_rect(size = 0.8, linetype = "solid"),
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 9),
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 9),
    plot.title = element_text(size = 9)
  ) 

C
ggsave(filename = "boxplot personnelrequired.pdf", plot = C, width = 10, height = 6.0, units = "in", device = cairo_pdf())

# --- Box-Plot: Total CO2 Emissions by Delivery Status ---
D <- ggplot(logistics_dataset, aes(x = Delivery_Status, y = kgCO2, fill = Delivery_Status)) +
  geom_boxplot(
    alpha = 0.65, 
    color = "black", 
    fatten = 1.2,
    outlier.colour = "black", 
    outlier.shape = 16, 
    outlier.size = 2
  ) +
  scale_fill_viridis(discrete = TRUE, option = "D") +
  theme_minimal(base_size = 9) +
  labs(
    x = "Delivery Status",
    y = expression(bold("Total Gas Emissions [kg " * CO[2] * "]")),
    fill = "Delivery Status"
  )+
  theme(
    legend.position = "bottom",
    legend.background = element_rect(linewidth = 0.8, linetype = "solid"),
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 9),
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 9),
    plot.title = element_text(size = 9)
  )

D
ggsave(filename = "Gasemissions box plot.pdf", plot = D, width = 10, height = 6.0, units = "in", device = cairo_pdf())


###############################################################################
# 3. CENSORING AND TARGET FEATURE ANALYSIS
# Description: Summarizes failure typologies, right-censoring counts, and binary 
#              delivery success/failure metrics, compiling publication tables and 
#              multi-panel visual summaries.
###############################################################################

# --- Summary Statistics: Failure Types & Censoring Counts ---
Bad_Weather <- sum(with(logistics_dataset, Failure_Reason == "Bad Weather"))
Censored <- sum(with(logistics_dataset, Failure_Reason == "Censored (Out of Period / No Confirmation)"))
Failed_Appointment <- sum(with(logistics_dataset, Failure_Reason == "Failed Appointment"))
No_Failure <- sum(with(logistics_dataset, Failure_Reason == "None"))
Product_Unavailable <- sum(with(logistics_dataset, Failure_Reason == "Product Unavailable"))
Technical_Installation_Issue <- sum(with(logistics_dataset, Failure_Reason == "Technical Installation Issue"))
Traffic_Delay <- sum(with(logistics_dataset, Failure_Reason == "Traffic/Delay"))
ZTL <- sum(with(logistics_dataset, Failure_Reason == "ZTL Permit Missing"))
Num_Failure <- 60000 - No_Failure

# Construct summary table for failure events
Event <- c("Bad Weather", "Failed Appointment", "Product Unavailable", 
           "Technical Installation Issue", "Traffic/Delay", "ZTL Permit Missing", 
           "Total Censured", "Total Uncensored")
Count <- c(Bad_Weather, Failed_Appointment, Product_Unavailable, 
           Technical_Installation_Issue, Traffic_Delay, ZTL, Censored, No_Failure)
STABLE_Censured <- data.frame(Event, Count)

# Render formatted table
stable.p <- ggtexttable(STABLE_Censured, rows = NULL, theme = ttheme("mOrange"))
stable.p 

# --- Summary Statistics: Binary Target Feature (Delivery Status) ---
Target_1 <- sum(with(logistics_dataset, Delivery_Status == "Successful"))
Target_0 <- sum(with(logistics_dataset, Delivery_Status == "Failed"))

Event_Target <- c("Failure (1)", "No Failure (0)")
Count_Target <- c(Target_1, Target_0)
STABLE_Target <- data.frame(Event_Target, Count_Target)
colnames(STABLE_Target) <- c("Event Target", "Count")

# Render formatted table and export LaTeX representation
stable.p.Target <- ggtexttable(STABLE_Target, rows = NULL, theme = ttheme("mBlue"))
stable.p.Target 
xtable(STABLE_Target)

# --- Visual Analysis: Occurrence of Failure Events ---
Censured_plot <- ggplot(logistics_dataset, aes(y = factor(Delivery_Status), fill = Delivery_Status)) +
  geom_bar(width = 0.5) +
  geom_text(
    stat = "count", 
    aes(label = after_stat(count)), 
    hjust = -0.3, 
    size = 3.5
  ) +
  scale_fill_viridis(discrete = TRUE, option = "cividis") +
  theme_bw(base_size = 9) +
  theme(
    legend.background = element_rect(linewidth = 0.5, linetype = "solid"),
    plot.title = element_text(size = 9,),
    plot.subtitle = element_text(size = 9),
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 9),
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 9)
  ) +
  labs(
    y = NULL,
    fill = "Failure Type"
  ) +
  scale_x_continuous(expand = expansion(mult = c(0.05, 0.20)))

# --- Visual Analysis: CO2 Emissions Faceted by Delivery Status ---
Emission_plot <- ggplot(logistics_dataset, aes(x = Delivery_Distance_KM, y = kgCO2, color = Delivery_Status)) +
  geom_point(alpha = 0.4, size = 1.8) +
  facet_wrap(~ Delivery_Status) +
  scale_color_brewer(palette = "Set2") + 
  theme_bw(base_size = 9) +
  theme(
    plot.title = element_text(size = 9),
    plot.subtitle = element_text(size = 9),
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 9),
    strip.text = element_text(size = 9),
    legend.position = "none"
  ) +
  labs(
    x = "Delivery Distance [km]",
    y = expression("Total Gas Emissions [kg" * CO[2] * "]")
  )

# --- Combined Multi-Panel Figure ---
arrangeplot <- ggarrange(
  Censured_plot, Emission_plot,
  ncol = 1, nrow = 2,
  heights = c(1, 1.2)
)

ggsave(filename = "DataSetexploration.pdf", plot = arrangeplot, width = 15, height = 10, units = "in", device = cairo_pdf())


###############################################################################
# 4. CORRELATION ANALYSIS (SPEARMAN RANK CORRELATION)
# Description: Computes non-parametric Spearman rank correlation coefficients 
#              across operational features, masking statistically non-significant 
#              associations (p >= 0.05).
###############################################################################

# Select columns and explicitly coerce non-numeric columns via factors to ensure pure numeric data
DataSet_Corr_raw <- logistics_dataset %>%
  dplyr::select(
    Contact_Attempts,
    Appointment_Confirmation_Received,
    Day_OfWeek,
    ZTL_Restriction,
    Cumulative_Completed_Deliveries,
    Prior_Address_Failures,
    Product_Size,
    Product_Item,
    Service_Type,
    Personnel_Required,
    Stock_Quantity,
    Delivery_Distance_KM,
    Temperature_C,
    kgCO2
  )

# Bulletproof conversion loop: forces every column to be strictly numeric
DataSet_Corr <- as.data.frame(lapply(DataSet_Corr_raw, function(col) {
  if (is.numeric(col)) {
    return(col)
  } else {
    return(as.numeric(as.factor(col)))
  }
}))

# Convert cleanly to a numeric matrix
corr_matrix_data <- as.matrix(DataSet_Corr)

# Compute Spearman correlation matrix
corr <- round(cor(corr_matrix_data, use = "complete.obs", method = "spearman"), 2)

# Full correlation matrix visualization
ggcorrplot(corr, 
           hc.order = FALSE, 
           lab = TRUE, 
           sig.level = 0.05, 
           digits = 2, 
           lab_size = 3) +
  scale_fill_viridis_c(option = "D") +
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        axis.text.y = element_text(size = 10))

# Statistically significant correlation matrix visualization (p < 0.05)
p.mat <- cor_pmat(corr_matrix_data, method = "spearman")

CorrPlotMatrix <- ggcorrplot(corr, 
                             p.mat = p.mat,         
                             sig.level = 0.05,       
                             insig = "blank", # Suppresses non-significant correlations (p >= 0.05)
                             hc.order = FALSE, 
                             lab = TRUE, 
                             digits = 2, 
                             lab_size = 3) +
  scale_fill_viridis_c(option = "D") +
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
        axis.text.y = element_text(size = 9))

ggsave(filename = "Correlationmatrix.pdf" , plot=CorrPlotMatrix, width = 10, height = 7, units = "in", device = cairo_pdf())


###############################################################################
# 5. MULTIVARIATE SCATTER PLOT ANALYSIS (SAMPLED SUBSET)
# Description: Examines multi-dimensional interactions on a representative 
#              random sample (n = 5,000) for carbon emissions, environmental 
#              stressors, and delivery productivity.
###############################################################################

set.seed(1276)
df_sample <- logistics_dataset[sample(nrow(logistics_dataset), 5000), ]

# --- Plot 1: CO2 Emissions vs. Delivery Distance by Service Type ---
AAA <- ggplot(df_sample, aes(x = Delivery_Distance_KM, y = kgCO2, color = Service_Type)) +
  geom_point(alpha = 0.6, size = 1.5) +
  scale_color_viridis(discrete = TRUE, option = "viridis")+
  guides(color = guide_legend(override.aes = list(size = 5, alpha = 1))) +
  labs(
    x = "Delivery Distance [km]",
    y = expression(bold("CO2 Emissions [kg" * CO[2] * "]")),
    color = "Service Type"
  ) + theme_bw() +
  theme(
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 9),
    strip.text = element_text(size = 9),
    legend.position = "bottom",
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 9)
  ) 

ggsave(filename = "Scatter plot CO2scatterplot.pdf" , plot=AAA, width = 10, height = 7, units = "in", device = cairo_pdf())

# --- Plot 2: CO2 Emissions vs. Temperature by Failure Reason ---
BBB <- ggplot(df_sample[!is.na(df_sample$Temperature_C), ], aes(x = Temperature_C, y = kgCO2, color = Failure_Reason)) +
  geom_point(alpha = 0.6, size = 1.5) +
  scale_color_viridis(discrete = TRUE, option = "viridis") +
  guides(color = guide_legend(override.aes = list(size = 5, alpha = 1), nrow = 4 )) +
  labs(
    x = "Temperature [°C]",
    y = expression(bold("CO2 Emissions [kg" * CO[2] * "]")),
    color = "Failure Reason"
  ) + theme_bw() +
  theme(
    plot.title = element_text(size = 9),
    plot.subtitle = element_text(size = 9),
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 9),
    strip.text = element_text(size = 9),
    legend.position = "bottom",
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 9)
  ) 

ggsave(filename = "CO2emission scatter plot.pdf" , plot=BBB, width = 10, height = 9, units = "in", device = cairo_pdf())

# --- Plot 3: Cumulative Completed Deliveries vs. Delivery Time ---
df_sample$Hour_Numeric <- sapply(df_sample$Exact_Delivery_Time, function(t) {
  if(is.na(t) || t == "0") return(NA)
  parts <- as.numeric(strsplit(t, ":")[[1]])
  return(parts[1] + parts[2]/60)
})

CCC <- ggplot(df_sample[!is.na(df_sample$Hour_Numeric) & df_sample$Cumulative_Completed_Deliveries > 0, ], 
              aes(x = Hour_Numeric, y = Cumulative_Completed_Deliveries, color = Delivery_Time_Slot)) +
  geom_point(alpha = 0.5, position = position_jitter(width = 0.1, height = 0.1), size = 1.5) +
  scale_color_viridis(discrete = TRUE, option = "viridis") +
  guides(color = guide_legend(override.aes = list(size = 5, alpha = 1), nrow = 1 )) +
  labs(
    x = "Delivery Time [Decimal Hour]",
    y = "Cumulative Completed Deliveries",
    color = "Time Slot"
  ) + theme_bw(base_size = 9) +
  theme(
    plot.title = element_text(size = 9),
    plot.subtitle = element_text(size = 9),
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 9),
    strip.text = element_text(size = 9),
    legend.position = "bottom",
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 9)
  ) 

ggsave(filename = "Productivity curve scatter plot.pdf" , plot=CCC, width = 10, height = 7, units = "in", device = cairo_pdf())

# --- Plot 4: Historical Address Failures vs. Distance from HUB ---
DDD <- ggplot(df_sample, aes(x = Delivery_Distance_HUB_Km, y = Prior_Address_Failures, color = ZTL_Restriction)) +
  geom_point(alpha = 0.5, position = position_jitter(width = 0.2, height = 0.2), size = 1.5) +
  scale_color_viridis(discrete = TRUE, option = "viridis") +
  guides(color = guide_legend(override.aes = list(size = 5, alpha = 1), nrow = 1 )) +
  labs(
    x = "HUB Distance [km]",
    y = "Prior Address Failures",
    color = "ZTL Restriction"
  ) + theme_bw(base_size = 9) +
  theme(
    plot.title = element_text(size = 9),
    plot.subtitle = element_text(size = 9),
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 9),
    strip.text = element_text(size = 9),
    legend.position = "bottom",
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 9)
  )

ggsave(filename = "Address faillure scatter plot.pdf" , plot=DDD, width = 10, height = 7, units = "in", device = cairo_pdf())




  