################################################################################
# Program Name:    03_create_listings.R
#
# Purpose:
#   Generate a subject-level listing of Treatment-Emergent Adverse Events (TEAEs)
#   including treatment assignment, event severity, relationship to treatment,
#   and event start/end dates.
#
# Description:
#   This program:
#     - Loads the ADAE dataset from the pharmaverseadam package
#     - Filters records to Treatment-Emergent Adverse Events (TRTEMFL = "Y")
#     - Selects key subject-level AE variables for listing output
#     - Orders events by subject and AE start date
#     - Produces a formatted patient listing using gt
#     - Exports the listing as an HTML file
#
# Input Data:
#   - adae : Adverse Events Analysis Dataset (from pharmaverseadam)
#
# Key Variables:
#   - USUBJID  : Unique Subject Identifier
#   - ACTARM   : Description of Actual Treatment Arm
#   - AETERM   : Reported Term for the Adverse Event
#   - AESEV    : Severity/Intensity
#   - AEREL    : Relationship to Study Drug
#   - ASTDT    : Start Date/Time of Adverse Event
#   - AENDT    : End Date/Time of Adverse Event
#   - TRTEMFL  : Treatment-Emergent Analysis Flag
#
# Output:
#   - question_4_tlg/output/ae_listings.html
#
# Methods:
#   - Filtering TEAEs using TRTEMFL flag
#   - Selection of relevant AE variables for subject-level listing
#   - Sorting by subject and event start date
#   - gt table formatting for structured patient listing
#   - gt::gtsave() for HTML output
#
# Dependencies:
#   dplyr
#   gtsummary
#   pharmaverseadam
#   gt
#
# Notes:
#   Designed to demonstrate generation of a subject-level adverse event listing
#   suitable for TLG outputs using pharmaverse example datasets and gt for
#   formatted reporting.
#
################################################################################

rm(list = ls())

library(dplyr)
library(gtsummary)
library(pharmaverseadam)
library(gt)


# Load ADAE dataset
adae <- pharmaverseadam::adae

# Create AE listing
ae_listing <- adae %>%
  filter(TRTEMFL == "Y") %>%
  select(USUBJID,ACTARM,AETERM,AESEV,AEREL,ASTDT,AENDT) %>%
  arrange(USUBJID, ASTDT) 

# Use gt for patient listings as gtsummary is for summary tables primarily
ae_listing_final <- ae_listing %>% 
  gt() %>%
  cols_label(
    USUBJID = "Unique Subject Identifier",
    ACTARM  = "Description of Actual Arm",
    AETERM  = "Reported Term for the Adverse Event",
    AESEV   = "Severity/Intensity",
    AEREL   = "Causality",
    ASTDT   = "Start Date/Time of Adverse Event",
    AENDT   = "End Date/Time of Adverse Event"
  )

ae_listing_final %>% 
  gt::gtsave("question_4_tlg/output/ae_listings.html")