################################################################################
# Program Name:    adsl_derivation.R
#
# Purpose:
#   Derive the ADaM ADSL (Subject-Level Analysis Dataset) from SDTM domains
#   using pharmaverse and admiral utilities.
#
# Description:
#   This program:
#     - Reads SDTM datasets (DM, DS, EX, AE, VS, SUPPDM)
#     - Converts blank values to NA
#     - Derives subject-level analysis variables
#     - Merges all derivations into a final ADSL dataset
#
# Key Derivations:
#   AGEGR9   - Age group (<18, 18–50, >50)
#   AGEGR9N  - Numeric age group
#   ITTFL    - Intent-to-Treat flag
#   TRTSDTM  - Treatment start datetime
#   TRTSTMF  - Treatment start time imputation flag
#   ABNSBPFL - Abnormal systolic blood pressure flag
#   CARPOPFL - Cardiac disorder population flag
#   LSTALVDT - Last known alive date (max across AE, VS, EX, DS)
#
# Input Data (from pharmaversesdtm):
#   dm, ds, ex, ae, vs, suppdm
#
# Output:
#   adsl_final (ADSL analysis dataset)
#
# Dependencies:
#   metacore
#   metatools
#   pharmaversesdtm
#   admiral
#   xportr
#   dplyr
#   tidyr
#   lubridate
#   stringr
#
# Notes:
#   Designed for technical assessment to demonstrate ADaM subject-level
#   derivation logic using pharmaverse ecosystem tools.
#
################################################################################