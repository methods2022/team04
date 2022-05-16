# Predicting Patients with Long Hospitalizations Due to COVID-19 Using Demographic and Physiologic Data
## Team 04: Dana Leichter, Zachary Levin, Talia Seshaiah, Li Yuan, Joshua Woo

### Project overview
This repository contains code used to analyze synthetic medical records representative of patients during the COVID-19 pandemic. The provided code allows for exploratory analysis of demographic traits among hospitalized COVID-19 patients and uses machine learning to try and predict patients with long hospitalizations due to COVID-19.

### Flow chart of project
   <img src="plots/flow_chat v2.0.png"/>

### Data source

- The 100k COVID-19 synthea dataset was downloaded from Synthea [here](https://synthea.mitre.org/downloads)
- The file is a .zip file containing a series of .csv files that can be unzipped.

### Setup

- This analysis was run on Brown's HPC server Oscar using Julia 1.7.2 and VS Code 1.22.
- One file (ZL_plotting.ipynb) uses IJulia and not VS Code. (Note: It is listed as a Jupyter notebook, but uses the Julia language.)
- One file (TS_visualizations.jl) was run externally (not on Oscar) using VSCode 1.67.1 and Julia v1.6.17.
- On Oscar, the file path to the directory containing the original dataset is: `/gpfs/data/biol1555/0_shared/0_data/synthea/100k_synthea_covid19_csv/`


### Repo organization
- All visualization files can be found in `Plots`.
- All intermediate data files can be found in `Data`.
- All code scripts are in the main repository.

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

- `LY_patient_demographics.jl`
  - This file extract the patient demogrphics from `patient.csv` file. 
  - We extracted patient_ID, birthdate, deathday, race, ethnicity and gender information from there. 
  - The output file is a text file with header. (`proj_patient_demographics.txt`)

- `TS_merge_demographics.jl`
  - This file accesses the `encounters_total_dur.txt` and `proj_patient_demographics.txt` files, and merges/combines these two files together. 
  - It outputs a text file that has the patients hospitalized with COVID, ICU hospital stays (duration), binary LOS outcome, and the patient demographics (`encounters_demographics.txt`)

- `LY_ml_encounters_demographics.jl`
  - This file accesses the `encounters_demographics.txt` file. 
  - User can choose one of the algorithms from Linear Binary Tree, Decision Tree, Random Forest, and EVO Decision Trees, to train all the features within the file. 
  - It prints out the value of accuracy and f1 score for the traing. 

- `DL_covid_observations.jl`
  - This script accesses the `encounters_demographics.txt`, `observations.csv`, and `conditions.csv` files.
  - It calculates the age for all patients, extracts the observations and conditions for all patients, and merges/combines all of these features together.
  - It outputs a CSV file `inpatient_full_0427.csv` that containes all patients hospitalized with COVID, ICU hospital stays (duration), binary LOS outcome, and all demographic, physiological, and comorbid features.

- `LY_ml_inpatient_full_0.jl`
  - This file accesses the `inpatient_full_0427.csv` file. 
  - User can choose one of the algorithms from Linear Binary Tree, Decision Tree, Random Forest, EVO Decision Trees and SVM, to train all demographics and two conditions features within the file. 
  - It prints out the value of accuracy and f1 score for the training. 

- `LY_ml_inpatient_full_1.jl`
  - This file accesses the `inpatient_full_0427.csv` file. 
  - User can choose one of the algorithms from Linear Binary Tree, Decision Tree, Random Forest, EVO Decision Trees and SVM, to train 24 features within the file (by removing one feature randomly). 
  - It prints out the value of accuracy and f1 score for the training. 

- `LY_ml_inpatient_full_2.jl`
  - This file accesses the `inpatient_full_0427.csv` file. 
  - User can choose one of the algorithms from Linear Binary Tree, Decision Tree, Random Forest, EVO Decision Trees and SVM, to train 23 features within the file (by removing two features randomly). 
  - It prints out the value of accuracy and f1 score for the training. 

- `LY_ml_inpatient_full_5.jl`
  - This file accesses the `inpatient_full_0427.csv` file. 
  - User can choose one of the algorithms from Linear Binary Tree, Decision Tree, Random Forest, EVO Decision Trees and SVM, to train 23 features within the file (by removing five features randomly). 
  - It prints out the value of accuracy and f1 score for the training. 

- `LY_ml_inpatient_full_10.jl`
  - This file accesses the `inpatient_full_0427.csv` file. 
  - User can choose one of the algorithms from Linear Binary Tree, Decision Tree, Random Forest, EVO Decision Trees and SVM, to train 23 features within the file (by removing ten features randomly). 
  - It prints out the value of accuracy and f1 score for the training. 

- The first code file in the analysis of age is `TS_age_data.jl`
  - This file accesses the full dataset (`inpatient_full_0427.csv`) and creates the different age groups used in analyzing age. 
  - This file uses CategoricalArrays.jl to order age group numerically. 
  - It outputs a text file (`agegrp.txt)`, which is then called in and merged with the full dataset to create the two dataframes/datasets that will be used for visualizations and analysis of age. 
  - Outputs a csv file (`duration_agegroup.csv`) that contains duration and age group. 
  - Outputs a csv file (`duration_agegroup_prop.csv`) that contains the frequencies, proportions and percentages of duration by age group. 
- Visualizations for age: `TS_visualizations.jl` 
  - This file accesses the `dur_agegroup.csv` and `duration_agegroup_prop.csv` files to create the visualizations. 
  - This file uses StatsPlots and PyPlot.jl to create visualizations of age for duration and LOS outcome.
    - NOTE: This file was run externally using VSCode 1.67.1 and Julia v1.6.17 (due to the use of PyPlot)
  - The visualizations are: bar plot, histogram, boxplot and pie chart. 
- Statistics/Analysis of age: `TS_stats.jl` 
  - This file accesses the `duration_agegroup.csv` file. 
  - This file uses Statistics.jl for statistics (e.g. mean) and HypothesisTests.jl for ANOVA
  - It calculates the mean duration value for the age groups, and also runs a one-way ANOVA test to determine if there are any statistically significant differences between the means of the different age groups (the means in this case refer to the mean duration values).

- Visualization and analysis for comorbid conditions: `DL_conditions_plotting.jl`
  - This file accesses the `inpatient_full_0427.csv` file
  - This file uses Statsplots to create histograms of hospitalization LOS based on the two comorbid conditions (hypertension and diabetes)

- Visualizations and analysis between Case and Non-Case cohorts: `JW_cases.py` and `JW_racial_case_distribution.py`
  -   Accesses the `inpatient_demog_obs_full.csv`
  -   `JW_racial_case_distribution.py` compares the two case/non-case cohorts and calculates the racial proportions in each; no significant differences were found; Runs a t-test and calculates p value, neither of which intuitively provided new information
  -   `JW_cases.py` compares age and blood pressure, commonly implicated variables in disease severity, by calculating the proportion of each condition in the each cohort. No significant differences were found.
- Visualizations and analysis for the preliminary data, including all patients: `JW_viability.py` and `JW_all_age.py`
  - `JW_viability.py` was used to look for null values in specific columns, particularly the ones suspected of biasing the machine learning model. BMI was found to have a dispropotionate number of null values.

- `ZL_plotting.ipynb` must be run using IJulia.
  - IJulia can be installed and run using instructures [here](https://github.com/JuliaLang/IJulia.jl).
  - This file uses PyPlot.jl to create visualizations of sex, race, vital signs, and lab work.
