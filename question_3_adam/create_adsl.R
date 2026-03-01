################################################################################
# Program Name:    create_adsl.R
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

rm(list = ls())

library(metacore)
library(metatools)
library(pharmaversesdtm)
library(admiral)
library(xportr)
library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)

# Read in input SDTM data
dm <- pharmaversesdtm::dm
ds <- pharmaversesdtm::ds
ex <- pharmaversesdtm::ex
ae <- pharmaversesdtm::ae
vs <- pharmaversesdtm::vs
suppdm <- pharmaversesdtm::suppdm

# Convert any missing values to NA for usability in R
dm <- convert_blanks_to_na(dm)
ds <- convert_blanks_to_na(ds)
ex <- convert_blanks_to_na(ex)
ae <- convert_blanks_to_na(ae)
vs <- convert_blanks_to_na(vs)
suppdm <- convert_blanks_to_na(suppdm)

#AGEGR9 + AGEGR9N + ITTFL Derivation

adsl_01_dm <- dm %>% 
  mutate(AGEGR9 = case_when(AGE<18 & !is.na(AGE) ~ "<18",
                            AGE>=18 & AGE<=50 & !is.na(AGE) ~ "18 - 50",
                            AGE>50 & !is.na(AGE) ~ ">50",
                            TRUE ~ NA),
         AGEGR9N = case_when(AGE<18 & !is.na(AGE) ~ 1,
                            AGE>=18 & AGE<=50 & !is.na(AGE) ~ 2,
                            AGE>50 & !is.na(AGE) ~ 3,
                            TRUE ~ NA),
         ITTFL = if_else(is.na(ARM),"N","Y"))

#TRTSDTM/TRTSTMF Derivation [H = Hours/Minutes/Seconds missing, M = Minutes/Seconds missing, S = Seconds only missing]
adsl_01_ex <-ex %>% 
  filter(EXDOSE > 0 | (EXDOSE == 0 & EXTRT=="PLACEBO")) %>% 
  filter(nchar(EXSTDTC)>=10) %>% 
  mutate(exstdtc_date = substr(EXSTDTC,1,10),
         exstdtc_time = str_extract(EXSTDTC,"(?<=T).*"),
         exstdtc_time_hms = ifelse(is.na(exstdtc_time), 0, str_count(exstdtc_time, ":")),
         TRTSTMF = case_when(is.na(exstdtc_time) ~ "H",
                             !is.na(exstdtc_time) & exstdtc_time_hms == 0 ~ "M",
                             !is.na(exstdtc_time) & exstdtc_time_hms == 1 ~ "S",
                             !is.na(exstdtc_time) & exstdtc_time_hms == 2 ~ NA
                             ),
         trtsdt_time = case_when(is.na(exstdtc_time) ~ "00:00:00",
                             !is.na(exstdtc_time) & exstdtc_time_hms == 0 ~ paste0(exstdtc_time,":00:00"),
                             !is.na(exstdtc_time) & exstdtc_time_hms == 1 ~ paste0(exstdtc_time,":00"),
                             !is.na(exstdtc_time) & exstdtc_time_hms == 2 ~ exstdtc_time),
         trtsdtm_c = paste(exstdtc_date,trtsdt_time),
         TRTSDTM = ymd_hms(trtsdtm_c)) %>% 
         arrange(USUBJID, TRTSDTM) %>%
         group_by(USUBJID) %>%
         slice(1) %>%
         ungroup() %>%
         select(USUBJID, TRTSDTM, TRTSTMF)

#ABNSBPFL Derivation [All subjects with Systolic Blood pressure (mmHg) where the value is outside the normal range (>=140 or <100)]
adsl_01_vs <- vs %>% 
  filter(VSTESTCD=="SYSBP" & VSSTRESU=="mmHg" & (VSSTRESN >=140 | VSSTRESN < 100)) %>%
  mutate(ABNSBPFL="Y") %>% 
  arrange(USUBJID, VSSTRESN) %>%
  group_by(USUBJID) %>%
  slice(1) %>%
  ungroup() %>%
  select(USUBJID, ABNSBPFL)

#LSTALVDT Derivation 
#[NOTE: Opted to derive each date and merge together as opposed to using derive_vars_extreme_event as it allowed me to check and validate the dates]

adsl_01_lst_vs <- vs %>% 
  filter(nchar(VSDTC)==10 & !is.na(VSSTRESN) & !is.na(VSSTRESC)) %>% 
  mutate(VSDT=convert_dtc_to_dt(VSDTC,highest_imputation = "n")) %>% 
  select(USUBJID,VSDT) %>% 
  arrange(USUBJID,desc(VSDT)) %>%
  group_by(USUBJID) %>%
  slice(1) %>%
  ungroup() 
adsl_01_lst_ae <- ae %>% 
  filter(nchar(AESTDTC)==10) %>% 
  mutate(AESTDT=convert_dtc_to_dt(AESTDTC,highest_imputation = "n")) %>% 
  select(USUBJID,AESTDT)%>% 
  arrange(USUBJID,desc(AESTDT)) %>%
  group_by(USUBJID) %>%
  slice(1) %>%
  ungroup() 
adsl_01_lst_ex <- ex %>% 
  filter(nchar(EXENDTC)==10) %>% 
  mutate(EXENDT=convert_dtc_to_dt(EXENDTC,highest_imputation = "n")) %>% 
  select(USUBJID,EXENDT)%>% 
  arrange(USUBJID,desc(EXENDT)) %>%
  group_by(USUBJID) %>%
  slice(1) %>%
  ungroup() 
adsl_01_lst_ds <- ds %>% 
  filter(nchar(DSSTDTC)==10) %>% 
  mutate(DSSTDT=convert_dtc_to_dt(DSSTDTC,highest_imputation = "n")) %>% 
  select(USUBJID,DSSTDT)%>% 
  arrange(USUBJID,desc(DSSTDT)) %>%
  group_by(USUBJID) %>%
  slice(1) %>%
  ungroup() 

#CARPOPFL Derivation : Equal to "Y" for subjects that have had a Cardiac Disorder
adsl_01_ae <- ae %>% 
  filter(toupper(AESOC)=="CARDIAC DISORDERS") %>%
  mutate(CARPOPFL="Y") %>% 
  arrange(USUBJID, AESTDTC) %>%
  group_by(USUBJID) %>%
  slice(1) %>%
  ungroup() %>%
  select(USUBJID, CARPOPFL)

#Final ADSL merging and LSTALVDT Derivation [Selected maximum date value using the dates derived earlier in program]
adsl_final <- adsl_01_dm %>%
  left_join(adsl_01_ae,     by = "USUBJID") %>%
  left_join(adsl_01_ex,     by = "USUBJID") %>%
  left_join(adsl_01_vs,     by = "USUBJID") %>%
  left_join(adsl_01_lst_ae, by = "USUBJID") %>%
  left_join(adsl_01_lst_vs, by = "USUBJID") %>%
  left_join(adsl_01_lst_ex, by = "USUBJID") %>%
  left_join(adsl_01_lst_ds, by = "USUBJID")  %>% 
  mutate(LSTALVDT = pmax(AESTDT,VSDT,EXENDT, DSSTDT, na.rm=TRUE)) %>% 
  select(STUDYID, USUBJID, AGEGR9, AGEGR9N, TRTSDTM, TRTSTMF, ITTFL, ABNSBPFL, LSTALVDT, CARPOPFL)