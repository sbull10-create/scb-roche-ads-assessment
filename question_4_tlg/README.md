# TLG – Adverse Events Reporting (Question 4)

## Overview

This project creates Tables, Listings, and Graphs (TLGs) for treatment-emergent adverse events (TEAEs) using the pharmaverseadam datasets.

The scripts generate:

* A summary table of treatment-emergent adverse events
* A visualization of AE severity by treatment
* A visualization of the top 10 most frequent adverse events
* A detailed AE listing

All outputs are saved in the output folder.

## Folder Structure

```
question_4_tlg
│
├── R
│   Contains scripts used to generate adverse event tables, listings,
│   and visualisations.
│
│   ├── 01_create_ae_summary_table.R
│   │   Script used to generate the summary table of treatment-emergent
│   │   adverse events using the {gtsummary} package.
│   │
│   ├── 02_create_visualizations_01.R
│   │   Script used to generate the adverse event severity distribution
│   │   plot by treatment group.
│   │
│   ├── 02_create_visualizations_02.R
│   │   Script used to generate the plot showing the top 10 most frequent
│   │   adverse events with confidence intervals.
│   │
│   └── 03_create_listings.R
│       Script used to generate the adverse event listing output.
│
├── output
│   Contains the generated outputs produced by the scripts.
│
│   ├── ae_summary_table.html
│   ├── ae_severity_distribution.png
│   ├── ae_top_10_fp.png
│   └── ae_listings.html
│
└── README.md
    Documentation explaining the scripts and how to run them.
```
    
## Scripts

01_create_ae_summary_table.R
Creates a summary table of treatment-emergent adverse events using pharmaverseadam::adae.
Filters records where TRTEMFL == "Y" and summarises AEs by treatment group (ACTARM).
Output: ae_summary_table.html

02_create_visualizations_01.R
Creates a bar chart showing AE severity distribution by treatment using AESEV.
Output: ae_severity_distribution.png

02_create_visualizations_02.R
Creates a plot of the top 10 most frequent adverse events using AETERM with 95% confidence intervals.
Output: ae_top_10_fp.png

03_create_listings.R
Creates a detailed listing of treatment-emergent adverse events including:
USUBJID, ACTARM, AETERM, AESEV, relationship to drug, and start/end dates.
Sorted by subject and event date.
Output: ae_listings.html

## Data Sources

pharmaverseadam::adae
pharmaverseadam::adsl

## Required R Packages

pharmaverseadam
gtsummary
ggplot2
dplyr

## Running the Scripts

Run the scripts in order:

source("R/01_create_ae_summary_table.R")
source("R/02_create_visualizations_01.R")
source("R/02_create_visualizations_02.R")
source("R/03_create_listings.R")

The output files will be created in the output folder.
