################################################################################
# Program Name:        02_create_ds_domain.R
#
# Study:               NA
# Sponsor:             NA
#
# Purpose:             Derive SDTM DS (Disposition) domain dataset from raw
#                      data sources using pharmaverse and sdtm.oak framework.
#
# Description:
#   - Reads raw DM, DS, and EC datasets
#   - Generates OAK ID variables
#   - Derives reference start/end dates using oak_cal_ref_dates()
#   - Maps controlled terminology (DSDECOD, VISIT, VISITNUM)
#   - Derives ISO 8601 date/time variables
#   - Assigns sequence variable (DSSEQ)
#   - Derives study day (DSSTDY)
#   - Outputs finalized SDTM DS dataset
#
# Input Files:
#   - sdtm_ct.csv                  (SDTM Controlled Terminology)
#   - pharmaverseraw::dm_raw       (Raw DM dataset)
#   - pharmaverseraw::ds_raw       (Raw DS dataset)
#   - pharmaverseraw::ec_raw       (Raw EC dataset)
#
# Output:
#   - ds (Final SDTM DS domain dataset)
#
# Key Derivations:
#   - RFXSTDTC (Reference Start Date)
#   - DSSTDTC  (Disposition Start Date)
#   - DSDTC    (Disposition Date/Time)
#   - DSSEQ    (Sequence variable)
#   - DSSTDY   (Study Day)
#
# Controlled Terminology:
#   - C66727 (DSDECOD)
#   - VISIT
#   - VISITNUM
#
# Dependencies:
#   - pharmaverseraw
#   - sdtm.oak
#   - admiral
#   - tidyverse
#   - stringr
#
# Author:              Steven Bullivant
# Created:             01-MAR-2026
# Last Modified:       01-MAR-2026
#
# Validation Status:   Production
#
################################################################################

rm(list = ls())

library("pharmaverseraw")
library("sdtm.oak")
library("tidyverse")
library("admiral")
library("stringr")

#Read in SDTM Controlled Terminology
sdtm_ct <- read.csv("sdtm_ct.csv")

#Read in Raw DS file
ds_raw <- pharmaverseraw::ds_raw

#Read in Raw EC File (For Study Day Variables)
dm_raw <- pharmaverseraw::dm_raw
ec_raw <- pharmaverseraw::ec_raw

dm_raw <- dm_raw %>%
  generate_oak_id_vars(
    pat_var = "PATNUM",
    raw_src = "dm_raw"
  )

ds_raw <- ds_raw %>%
  generate_oak_id_vars(
    pat_var = "PATNUM",
    raw_src = "ds_raw"
  )

ec_raw <- ec_raw %>%
  generate_oak_id_vars(
    pat_var = "PATNUM",
    raw_src = "ec_raw"
  )
dm <- dm_raw %>%
  mutate(
    SUBJID = substr(PATNUM, 5, 8)
  ) %>%
  select(oak_id, raw_source, patient_number, SUBJID)

ref_date_conf_df <- tibble::tribble(
  ~raw_dataset_name, ~date_var,     ~time_var,      ~dformat,      ~tformat, ~sdtm_var_name,
  "ec_raw",       "IT.ECSTDAT", NA_character_, "dd-mmm-yyyy", NA_character_,     "RFXSTDTC",
  "ec_raw",       "IT.ECENDAT", NA_character_, "dd-mmm-yyyy", NA_character_,     "RFXENDTC",
  "ec_raw",       "IT.ECSTDAT", NA_character_, "dd-mmm-yyyy", NA_character_,      "RFSTDTC",
  "ec_raw",       "IT.ECENDAT", NA_character_, "dd-mmm-yyyy", NA_character_,      "RFENDTC",
  "dm_raw",            "IC_DT", NA_character_,  "mm/dd/yyyy", NA_character_,      "RFICDTC",
  "ds_raw",          "DSDTCOL",     "DSTMCOL",  "mm-dd-yyyy",         "H:M",     "RFPENDTC",
  "ds_raw",          "DEATHDT", NA_character_,  "mm/dd/yyyy", NA_character_,       "DTHDTC"
)

dm <- dm %>% 
  # Derive RFXSTDTC using oak_cal_ref_dates
  oak_cal_ref_dates(
    ds_in = .,
    der_var = "RFXSTDTC",
    min_max = "min",
    ref_date_config_df = ref_date_conf_df,
    raw_source = list(
      ec_raw = ec_raw,
      ds_raw = ds_raw,
      dm_raw = dm_raw
    ))

#Create oak_id vars
ds_raw <- ds_raw %>% 
  generate_oak_id_vars(
    pat_var = "PATNUM",
    raw_src = "ds_raw"
  ) 

ds_raw <- ds_raw %>% 
  mutate(DSTERM_RAW = if_else(is.na(OTHERSP) | OTHERSP =="",IT.DSTERM,OTHERSP),
         DSDECOD_RAW = if_else(is.na(OTHERSP) | OTHERSP =="",IT.DSDECOD,OTHERSP),
         INSTANCE_RAW = case_when(INSTANCE=="Ambul Ecg Removal" ~ "Ambul ECG Removal",
                                  INSTANCE=="Ambul Ecg Placement" ~ "Ambul ECG Placement",
                                  TRUE ~ INSTANCE),
         DSTMCOL_RAW = if_else(is.na(DSTMCOL),"00:00",DSTMCOL)
         )

#Map Topic Variable (DSTERM)
ds <- 
  assign_no_ct(
    raw_dat = ds_raw,
    raw_var = "DSTERM_RAW",
    tgt_var = "DSTERM",
    id_vars = oak_id_vars()
  ) 

ds <- ds %>% 
  #Map DSDECOD using Controlled Terminology
  assign_ct(
    raw_dat = ds_raw,
    raw_var = "DSDECOD_RAW",
    tgt_var = "DSDECOD",
    ct_spec = sdtm_ct,
    ct_clst = "C66727",
    id_vars = oak_id_vars()
  ) %>%
  assign_ct(
    raw_dat = ds_raw,
    raw_var = "INSTANCE_RAW",
    tgt_var = "VISIT_",
    ct_spec = sdtm_ct,
    ct_clst = "VISIT",
    id_vars = oak_id_vars()
  ) %>%
  assign_ct(
    raw_dat = ds_raw,
    raw_var = "INSTANCE_RAW",
    tgt_var = "VISITNUM_",
    ct_spec = sdtm_ct,
    ct_clst = "VISITNUM",
    id_vars = oak_id_vars()
  ) %>%
  #Map DSCAT based on DSDECOD 
  mutate(DSCAT=if_else(DSDECOD=="RANDOMIZED","PROTOCOL MILESTONE","DISPOSITION EVENT"),
         DSSTDTC = format(mdy(ds_raw$IT.DSSTDAT), "%Y-%m-%d"),
         DSDTC = format(as.POSIXct(paste(ds_raw$DSDTCOL,ds_raw$DSTMCOL_RAW),format="%m-%d-%Y %H:%M"),"%Y-%m-%dT%H:%M:%S"),
         VISIT = toupper(VISIT_),
         VISITNUM_X = if_else(str_detect(VISIT,"UNSCHEDULED"),NA,VISITNUM_),
         VISITNUM = if_else(
           str_detect(VISIT,"UNSCHEDULED"),
           as.numeric(str_extract(VISIT_, "\\d+\\.?\\d*")),
           as.numeric(VISITNUM_X)),
         STUDYID = ds_raw$STUDY,
         DOMAIN = "DS",
         USUBJID = paste0("01-",ds_raw$PATNUM)
         ) %>%
  derive_seq(
    tgt_var="DSSEQ",
    rec_vars = c("USUBJID","DSSTDTC","DSTERM")
  ) %>% 
  derive_study_day(
    sdtm_in = .,
    dm_domain = dm,
    tgdt = "DSSTDTC",
    refdt = "RFXSTDTC",
    study_day_var = "DSSTDY",
    merge_key = "patient_number"
  ) %>% 
  select("STUDYID","DOMAIN","USUBJID","DSSEQ","DSTERM","DSDECOD","DSCAT","VISITNUM","VISIT","DSDTC","DSSTDTC","DSSTDY")
