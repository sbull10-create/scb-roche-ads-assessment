# descriptiveStats

A simple R package for computing descriptive statistics.

## Installation

devtools::install("question_1/descriptive_stats")

## Functions

- calc_mean()
- calc_median()
- calc_mode()
- calc_q1()
- calc_q3()
- calc_iqr()

## Package Structure

```text
descriptiveStats
│
├── DESCRIPTION
│   Package metadata including name, version, authors, dependencies and description.
│
├── NAMESPACE
│   Defines exported functions available to users of the package.
│
├── R/
│   Contains the implementation of the descriptive statistics functions.
│   ├── calc_mean.R
│   ├── calc_median.R
│   ├── calc_mode.R
│   ├── calc_q1.R
│   ├── calc_q3.R
│   └── calc_iqr.R
│
├── man/
│   Automatically generated documentation files created using roxygen2.
│   ├── calc_mean.Rd
│   ├── calc_median.Rd
│   ├── calc_mode.Rd
│   ├── calc_q1.Rd
│   ├── calc_q3.Rd
│   └── calc_iqr.Rd
│
└── README.md
    Documentation describing the purpose of the package and usage examples.
```
