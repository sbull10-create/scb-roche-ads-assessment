# Roche Advanced Data Science Programmer Coding Assessment

This repository contains my solutions for the **Roche Advanced Data Science Programmer Coding Assessment**. The assessment evaluates skills in:

* **R package development**
* **Pharmaverse ecosystem (SDTM / ADaM)**
* **Clinical reporting (TLGs)**
* **Python API development**
* **LLM / GenAI integration**
* **Clean, reproducible software development practices**

The repository is organised by question to make it easy to navigate and review.

---

# Repository Structure

```
scb-roche-ads-assessment
│
├── question_1/
│   └── descriptiveStats/
│       └── R package implementing descriptive statistics
│
├── question_2_sdtm/
│   └── Script to create the SDTM DS domain
│
├── question_3_adam/
│   └── Script to create the ADaM ADSL dataset
│
├── question_4_tlg/
│   ├── R scripts for adverse event tables, listings and graphs
│   └── output/ generated HTML and PNG outputs
│
├── question_5_fastapi/
│   └── FastAPI application serving clinical trial data
│
├── question_6_genai/
│   └── GenAI clinical data assistant using an LLM
│
├── renv/
│   └── R environment lockfile for reproducibility
│
└── README.md
```

---

# Environment Setup

The R environment is managed using **renv** to ensure reproducibility.

## Restore R Environment

```r
install.packages("renv")
renv::restore()
```

This will install all required R dependencies.

---

# Question 1 – R Package Development

Location:

```
question_1/descriptiveStats
```

This folder contains a fully structured **R package** implementing descriptive statistics functions.

Functions included:

* `calc_mean()`
* `calc_median()`
* `calc_mode()`
* `calc_q1()`
* `calc_q3()`
* `calc_iqr()`

## Install the package locally

```r
devtools::install("question_1/descriptiveStats")
```

Example usage:

```r
library(descriptiveStats)

data <- c(1,2,2,3,4,5,5,5,6,10)

calc_mean(data)
calc_median(data)
calc_mode(data)
calc_q1(data)
calc_q3(data)
calc_iqr(data)
```

---

# Question 2 – SDTM DS Domain Creation

Location:

```
question_2_sdtm/02_create_ds_domain.R
```

This script creates the **SDTM DS (Disposition) domain** using the **Pharmaverse {sdtm.oak} package**.

Input data:

* `pharmaverseraw::ds_raw`

Output dataset includes:

* STUDYID
* DOMAIN
* USUBJID
* DSSEQ
* DSTERM
* DSDECOD
* DSCAT
* VISITNUM
* VISIT
* DSDTC
* DSSTDTC
* DSSTDY

Run the script:

```r
source("question_2_sdtm/02_create_ds_domain.R")
```

---

# Question 3 – ADaM ADSL Dataset Creation

Location:

```
question_3_adam/create_adsl.R
```

This script generates the **ADSL (Subject-Level Analysis Dataset)** using **{admiral}** and **tidyverse** tools.

Input datasets:

* `pharmaversesdtm::dm`
* `pharmaversesdtm::vs`
* `pharmaversesdtm::ex`
* `pharmaversesdtm::ds`
* `pharmaversesdtm::ae`

Derived variables include:

* `AGEGR9`
* `AGEGR9N`
* `TRTSDTM`
* `ITTFL`
* `ABNSBPFL`
* `LSTALVDT`
* `CARPOPFL`

Run the script:

```r
source("question_3_adam/create_adsl.R")
```

---

# Question 4 – TLG (Tables, Listings, Graphs)

Location:

```
question_4_tlg/
```

This section generates **Adverse Event summary outputs** using **{gtsummary}** and **{ggplot2}**.

Scripts:

```
01_create_ae_summary_table.R
02_create_visualizations.R
03_create_listings.R
```

Outputs:

```
output/
├── ae_summary_table.html
├── ae_severity_distribution.png
├── ae_top_10_fp.png
└── ae_listings.html
```

These outputs demonstrate standard **clinical reporting deliverables**.

---

# Question 5 – Clinical Data API (FastAPI)

Location:

```
question_5_fastapi/main.py
```

A **FastAPI REST API** that serves clinical trial data and performs dynamic filtering and risk scoring.

## Run the API

Install dependencies:

```
pip install fastapi uvicorn pandas
```

Start the server:

```
uvicorn main:app --reload
```

Available endpoints:

### Root endpoint

```
GET /
```

Returns a welcome message.

### Dynamic AE filtering

```
POST /ae-query
```

Example request:

```json
{
  "severity": ["MILD", "MODERATE"],
  "treatment_arm": "Placebo"
}
```

### Patient safety risk score

```
GET /subject-risk/{subject_id}
```

Calculates a weighted risk score based on adverse event severity.

---

# Question 6 – GenAI Clinical Data Assistant

Location:

```
question_6_genai/
```

This component implements a **Generative AI agent** that translates natural language questions into structured queries on the AE dataset.

Workflow:

```
User Question
      ↓
LLM parses intent
      ↓
Structured JSON output
      ↓
Pandas query execution
      ↓
Return matching subjects
```

Example query:

```
Give me subjects with moderate severity adverse events
```

Output:

* Count of matching subjects
* List of USUBJIDs

---

# Reproducibility

To ensure reproducibility:

* R dependencies managed with **renv**
* Python dependencies listed in the relevant folders
* Output files included for review

---

# Video Walkthrough

A short walkthrough video explaining the repository structure and implementation approach accompanies this submission.

---

# Author

Submission prepared as part of the **Roche Advanced Data Science Programmer Coding Assessment**.

---
