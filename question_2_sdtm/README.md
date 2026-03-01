# SDTM DS Derivation – Technical Assessment

## Overview

This repository contains an R program that derives the SDTM Disposition (DS) domain using the pharmaverse framework (sdtm.oak, admiral, pharmaverseraw).

The script demonstrates:
- Raw data transformation
- Controlled terminology mapping
- ISO 8601 date/datetime derivation
- Sequence derivation
- Study day calculation
- SDTM-compliant dataset construction

The final output is a submission-ready SDTM DS dataset.

---

## Repository Structure

/DS
│
├── ds_sdtm_derivation.R   # Main derivation script  
├── sdtm_ct.csv            # SDTM controlled terminology  
└── README.md              # Project documentation  

---

## File Descriptions

### ds_sdtm_derivation.R
Main R script that:
- Loads required libraries
- Reads raw datasets (dm_raw, ds_raw, ec_raw)
- Generates subject identifiers
- Derives reference dates (RFXSTDTC)
- Maps controlled terminology (DSDECOD, VISIT, VISITNUM)
- Creates ISO 8601 date and datetime variables
- Derives DSSEQ
- Calculates study day (DSSTDY)
- Produces the final SDTM DS dataset

Output dataset: `ds`

---

### sdtm_ct.csv
Controlled terminology file used for:
- DSDECOD (C66727)
- VISIT
- VISITNUM

Used via assign_ct().

---

## Key Derivations

- Identifiers: SUBJID, USUBJID
- Reference Date: RFXSTDTC
- Disposition Dates: DSSTDTC, DSDTC
- Category: DSCAT
- Sequence: DSSEQ
- Study Day: DSSTDY

All date variables are formatted to ISO 8601 standard.

---

## Dependencies

Required R packages:
- pharmaverseraw
- sdtm.oak
- tidyverse
- admiral
- stringr

---

## How to Run

1. Ensure required packages are installed.
2. Run:

```r
source("02_create_ds_domain.R")
```

The script will create the final `ds` dataset in the R session.

---

## Notes for Reviewer

This implementation focuses on:
- Clear and reproducible transformation logic
- Appropriate controlled terminology mapping
- SDTM-compliant variable derivation
- Use of modular pharmaverse functions

The structure is intentionally simple and readable for assessment review.