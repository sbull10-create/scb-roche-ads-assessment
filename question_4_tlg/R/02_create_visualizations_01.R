################################################################################
# Program Name:    02_create_visualizations_01.R
#
# Purpose:
#   Generate a visualization showing the distribution of Adverse Event (AE)
#   severity by treatment arm for subjects in the Safety Population.
#
# Description:
#   This program:
#     - Loads ADSL and ADAE datasets from the pharmaverseadam package
#     - Filters ADAE records to the Safety Population (SAFFL = "Y")
#     - Summarizes the number of adverse events by treatment arm and severity
#     - Creates a stacked bar chart displaying AE severity distribution
#       across treatment arms
#     - Saves the visualization as a PNG file
#
# Input Data:
#   - adae : Adverse Events Analysis Dataset (from pharmaverseadam)
#   - adsl : Subject-Level Analysis Dataset (from pharmaverseadam)
#
# Key Variables:
#   - ACTARM : Description of Actual Treatment Arm
#   - AESEV  : Severity/Intensity of Adverse Event
#   - SAFFL  : Safety Population Flag
#
# Output:
#   - question_4_tlg/output/ae_severity_distribution.png
#
# Methods:
#   - Safety population filtering using SAFFL
#   - Frequency counting of AE records by treatment arm and severity
#   - ggplot2 stacked bar chart using geom_col()
#   - Color grouping by AE severity
#   - Export of visualization using ggsave()
#
# Dependencies:
#   dplyr
#   ggplot2
#   pharmaverseadam
#   scales
#
# Notes:
#   The stacked bar chart displays the count of adverse events by severity
#   category within each treatment arm. Each AE record contributes to the
#   count, meaning subjects with multiple AEs may contribute multiple times.
#
################################################################################

rm(list = ls())

library(dplyr)
library(ggplot2)
library(pharmaverseadam)
library(scales)

adsl <- pharmaverseadam::adsl
adae <- pharmaverseadam::adae

adae_saf <- adae %>%
 filter(SAFFL == "Y")

ae_sev_summary <- adae_saf %>%
  filter(!is.na(AESEV)) %>%
  count(ACTARM, AESEV) %>%
  group_by(ACTARM)

ae_sev_sum <- ggplot(ae_sev_summary,
       aes(x = ACTARM, y = n, fill = AESEV)) +
  geom_col(position = "stack", color = "black") +
  labs(
    title = "AE severity distribution by treatment",
    x = "Treatment Arm",
    y = "Count of AEs",
    fill = "Severity/Intensity"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "right"
  )

ggsave(
  filename = "question_4_tlg/output/ae_severity_distribution.png",
  plot = ae_sev_sum,
  width = 8,
  height = 6,
  units = "in",
  dpi = 300
)
