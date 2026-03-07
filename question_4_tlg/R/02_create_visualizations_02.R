################################################################################
# Program Name:    02_create_visualizations_02.R
#
# Purpose:
#   Generate a visualization of the top 10 most frequent Adverse Events (AEs)
#   based on subject-level incidence in the Safety Population, including
#   95% Clopper–Pearson confidence intervals.
#
# Description:
#   This program:
#     - Loads ADSL and ADAE datasets from the pharmaverseadam package
#     - Filters both datasets to the Safety Population (SAFFL = "Y")
#     - Determines the total number of subjects in the safety population
#     - Derives subject-level AE occurrences to avoid double-counting events
#     - Identifies the top 10 most frequent AE preferred terms
#     - Calculates AE incidence proportions and exact 95% Clopper–Pearson
#       confidence intervals using binom.test()
#     - Produces a horizontal point-range plot using ggplot2
#     - Saves the visualization as a PNG file
#
# Input Data:
#   - adsl : Subject-Level Analysis Dataset (from pharmaverseadam)
#   - adae : Adverse Events Analysis Dataset (from pharmaverseadam)
#
# Key Variables:
#   - USUBJID : Unique Subject Identifier
#   - AETERM  : Reported Term for the Adverse Event
#   - SAFFL   : Safety Population Flag
#
# Output:
#   - question_4_tlg/output/ae_top_10_fp.png
#
# Methods:
#   - Safety population filtering using SAFFL
#   - Distinct subject-level AE identification (USUBJID + AETERM)
#   - Frequency ranking to identify top 10 adverse events
#   - Incidence calculation using subject counts divided by total N
#   - Exact binomial confidence intervals using binom.test()
#   - ggplot2 point and error bar visualization
#   - scales::percent_format() for percentage axis formatting
#
# Dependencies:
#   dplyr
#   ggplot2
#   pharmaverseadam
#   scales
#
# Notes:
#   The visualization displays the proportion of subjects experiencing each
#   adverse event along with 95% exact (Clopper–Pearson) confidence intervals.
#   Subject-level deduplication ensures each subject contributes at most once
#   per adverse event term.
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

adsl_saf <- adsl %>% 
  filter(SAFFL == "Y")

N_total <- n_distinct(adsl_saf$USUBJID)

ae_subject_level <- adae_saf %>%
  filter(!is.na(AETERM)) %>%
  distinct(USUBJID, AETERM)

top10_ae <- ae_subject_level %>%
  count(AETERM, name = "n") %>%
  arrange(desc(n)) %>%
  slice_head(n = 10)

top10_ae_1 <- top10_ae %>%
  rowwise() %>%
  mutate(
    incidence = n / N_total,
    ci = list(binom.test(n, N_total, conf.level = 0.95)$conf.int),
    lower = ci[1],
    upper = ci[2]
  ) %>%
  ungroup() %>%
  select(-ci)

ae_plot2 <- ggplot(top10_ae_1,
                   aes(x = reorder(AETERM, incidence),
                       y = incidence)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = lower, ymax = upper),
                width = 0.2) +
  coord_flip() +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(
    title = "Top 10 Most Frequent Adverse Events",
    subtitle=paste0("n = ",N_total," subjects; 95% Clopper-Pearson CIs"),
    x = " ",
    y = "Percentage of Patients (%)"
  ) +
  theme_gray() +
  theme(
    plot.title = element_text(hjust = 0)
  )

ggsave(
  filename = "question_4_tlg/output/ae_top_10_fp.png",
  plot = ae_plot2,
  width = 8,
  height = 6,
  units = "in",
  dpi = 300
)