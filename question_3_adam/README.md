# ADSL Derivation – Technical Assessment

## Overview

This repository contains an R program that derives the ADaM Subject-Level Analysis Dataset (ADSL) from SDTM domains using the pharmaverse ecosystem.

The script demonstrates:
- SDTM data handling
- Subject-level derivations
- Date/time processing and imputation
- Flag derivations
- Multi-domain merging
- Construction of a final ADSL dataset

Output dataset: `adsl_final`

---

## Repository Structure

/ADSL
│
├── adsl_derivation.R   # Main ADSL derivation script
└── README.md           # Project documentation

---

## Input Data

Data are sourced from the `pharmaversesdtm` package:

- dm (Demographics)
- ds (Disposition)
- ex (Exposure)
- ae (Adverse Events)
- vs (Vital Signs)
- suppdm (Supplemental Demographics)

All blank values are converted to NA prior to derivations.

---

## Key Derivations

### Demographics-Based
- AGEGR9   – Age group (<18, 18–50, >50)
- AGEGR9N  – Numeric age group
- ITTFL    – Intent-to-Treat flag (ARM not missing)

### Treatment Variables
- TRTSDTM  – First treatment start datetime
- TRTSTMF  – Time imputation flag (H/M/S based on missing precision)

### Safety / Clinical Flags
- ABNSBPFL – Abnormal systolic BP (>=140 or <100 mmHg)
- CARPOPFL – Cardiac Disorders population flag (AESOC)

### Last Known Alive Date
- LSTALVDT – Maximum date across:
  - AE start date
  - VS date
  - EX end date
  - DS date

Derived using explicit maximum date comparison across domains.

---

## Dependencies

Required R packages:

- metacore
- metatools
- pharmaversesdtm
- admiral
- xportr
- dplyr
- tidyr
- lubridate
- stringr

---

## How to Run

1. Ensure required packages are installed.
2. Open the script `adsl_derivation.R`.
3. Run:

```r
source("adsl_derivation.R")
```

The script will create `adsl_final` in the R session.

---

## Notes for Reviewer

This implementation demonstrates:

- Clear subject-level derivation logic
- Proper datetime handling and imputation flags
- Cross-domain integration
- Modular and readable transformation steps
- Use of pharmaverse tools aligned with ADaM standards

The structure is intentionally concise and assessment-focused.