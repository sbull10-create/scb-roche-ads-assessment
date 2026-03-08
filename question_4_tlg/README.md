# TLG – Adverse Events Reporting (Question 4)

## Overview

This project creates Tables, Listings, and Graphs (TLGs) for treatment-emergent adverse events (TEAEs) using the pharmaverseadam datasets.

The scripts generate:

* A summary table of treatment-emergent adverse events
* A visualization of AE severity by treatment
* A visualization of the top 10 most frequent adverse events
* A detailed AE listing

All outputs are saved in the output folder.

question_4_tlg
│
├── R/
│   Contains the R scripts used to generate adverse event tables,
│   listings, and visualisations.
│   ├── 01_create_ae_summary_table.R
│   ├── 02_create_visualizations_01.R
│   ├── 02_create_visualizations_02.R
│   └── 03_create_listings.R
│
├── output/
│   Contains generated outputs produced by the scripts.
│   ├── ae_summary_table.html
│   ├── ae_severity_distribution.png
│   ├── ae_top_10_fp.png
│   └── ae_listings.html
│
└── README.md
    Documentation describing the scripts and outputs.
    
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
