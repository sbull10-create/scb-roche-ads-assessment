rm(list = ls())

library(dplyr)
library(gtsummary)
library(pharmaverseadam)

# Load ADAE dataset
adae <- pharmaverseadam::adae

# Create AE listing
ae_listing <- adae %>%
  filter(TRTEMFL == "Y") %>%
  select(
    USUBJID,     # Subject ID
    TRT01A,        # Treatment
    AETERM,      # AE Term
    AESEV,       # Severity
    AEREL,       # Relationship to Drug
    ASTDT,       # Start Date
    AENDT        # End Date
  ) %>%
  arrange(USUBJID, ASTDT) 

