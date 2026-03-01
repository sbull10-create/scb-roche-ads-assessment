################################################################################
# Program Name:    q4_summary_table.r
#
# Purpose:
#   Generate a hierarchical summary table of Treatment-Emergent Adverse Events
#   (TEAEs) by System Organ Class (SOC) and Preferred Term (PT), stratified
#   by treatment arm.
#
# Description:
#   This program:
#     - Orders SOCs by descending subject frequency
#     - Orders PTs within SOC by descending subject frequency
#     - Applies factor levels to preserve hierarchical ordering
#     - Produces a hierarchical TEAE summary table using tbl_hierarchical()
#     - Outputs a formatted HTML table using gt
#
# Input Data:
#   - adae_teae  : Treatment-emergent adverse events dataset
#   - adsl_saf   : Safety population dataset (denominator)
#
# Key Variables:
#   - AESOC    : System Organ Class
#   - AETERM   : Preferred Term
#   - USUBJID  : Unique Subject Identifier
#   - ACTARM   : Actual Treatment Arm
#
# Output:
#   - question_4_tlg/teae_summary.html
#
# Methods:
#   - Distinct subject counting for SOC and PT levels
#   - Hierarchical ranking (SOC → PT)
#   - tbl_hierarchical() for structured AE table
#   - gt::gtsave() for HTML output
#
# Dependencies:
#   dplyr
#   gtsummary (tbl_hierarchical)
#   gt
#
# Notes:
#   Designed for technical assessment to demonstrate hierarchical AE
#   summarization, proper subject-level counting, and reproducible table output.
#
################################################################################

rm(list = ls())

library(dplyr)
library(gtsummary)
library(pharmaverseadam)
library(tidyr)
library(gt)

adsl <- pharmaverseadam::adsl
adae <- pharmaverseadam::adae

# Safety population (adjust if SAP specifies otherwise)
adsl_saf <- adsl %>%
  filter(SAFFL == "Y") %>%
  select(USUBJID, ACTARM)

# TEAEs in safety population
adae_teae <- adae %>%
  filter(TRTEMFL == "Y" & SAFFL == "Y")

# Unique subject counts per SOC
soc_order <- adae_teae %>%
  distinct(USUBJID, AESOC) %>%
  count(AESOC, name = "n_soc") %>%
  arrange(desc(n_soc)) %>%
  mutate(soc_rank = row_number()) %>%
  ungroup()

soc_levels <- soc_order %>% 
  arrange(soc_rank) %>% 
  pull(AESOC)

# Unique subject counts per SOC + PT
pt_order <- adae_teae %>%
  distinct(USUBJID, AESOC, AETERM) %>%
  count(AESOC, AETERM, name = "n_pt") %>%
  arrange(AESOC, desc(n_pt)) %>%
  group_by(AESOC) %>%
  mutate(pt_rank = row_number()) %>%
  ungroup()

pt_levels <- pt_order %>% 
  arrange(pt_rank) %>% 
  pull(AETERM)

adae_teae_sorted <- adae_teae %>%
  left_join(soc_order,by=c("AESOC")) %>% 
  left_join(pt_order,by=c("AESOC","AETERM")) %>% 
  arrange(soc_rank, pt_rank) %>% 
  mutate(
    AESOC = factor(AESOC, levels = soc_levels),
    AETERM = factor(AETERM, levels = pt_levels)
  )

tbl_teae <- adae_teae_sorted %>%
  tbl_hierarchical(
    variables = c(AESOC,AETERM),
    by = ACTARM,
    id = USUBJID,
    denominator = adsl_saf,
    overall_row = TRUE,
    label = "..ard_hierarchical_overall.." ~ "Treatment Emergent AEs"
  ) %>% 
  sort_hierarchical()

tbl_teae %>% 
  as_gt() %>% 
  gt::gtsave("question_4_tlg/output/q4_teae_summary.html")