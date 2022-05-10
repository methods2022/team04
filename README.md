# Predicting Patients with Long Hospitalizations Due to COVID-19 Using Demographic and Physiologic Data
## Team 04: Dana Leichter, Zachary Levin, Talia Seshaiah, Li Yuan, Joshua Woo

### Project overview
This repository contains code used to analyze synthetic medical records representative of patients during the COVID-19 pandemic. The provided code allows for exploratory analysis of demographic traits among hospitalized COVID-19 patients and uses machine learning to try and predict patients with long hospitalizations due to COVID-19.

### Data source

- The 100k COVID-19 synthea dataset was downloaded from Synthea [here](https://synthea.mitre.org/downloads)
- The file is a .zip file containing a series of .csv files that can be unzipped.

### Setup

- This analysis was run on Brown's HPC server Oscar using Julia 1.7.2 and VS Code 1.22.
- One file (ZL_plotting.ipynb) uses IJulia and not VS Code.
- On Oscar, the file path to the directory containing the original dataset is: `/gpfs/data/biol1555/0_shared/0_data/synthea/100k_synthea_covid19_csv/`

### Code files and descriptions

- The first script in the analysis is `ZL_encounter_inpatient.jl`
  - This script accesses the `encounters.csv` file and extracts data for all patients hospitalized (to a regular unit) with COVID-19.
  - It outputs a text file (`inpatient_covid_cohort.txt`)
- The second script in the analysis is `ZL_encounter_ICU.jl`
  - This script accesses the `encounters.csv` file and extracts data for all patients admitted to the ICU with COVID-19.
  - It outputs a text file (`ICU_covid_cohort.txt`)
- The third script in the analysis is `ZL_merge_encounters.jl`
  - This script accesses the two output files that were just created (`inpatient_covid_cohort.txt` and `ICU_covid_cohort.txt`) in order to identify any patients that were transferred from an inpatient unit to the ICU.
  - After adjusting for transfers to the ICU, it calculates the mean length of stay (LOS) and binarizes patients into short LOS (<14 days) or long LOS (>14 days). This outcome is stored in the `outcome` column of the output file
  - It outputs a text file that has updated durations inclusive continuous ward and ICU hospital stays and the binary LOS outcome (`encounters_total_dur.txt`).



[Everyone should add their stuff here]






- `ZL_plotting.ipynb` must be run using IJulia.
  - IJulia can be installed and run using instructures [here](https://github.com/JuliaLang/IJulia.jl).
  - This file uses PyPlot.jl to create visualizations of sex, race, vital signs, and lab work.
