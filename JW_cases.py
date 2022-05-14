import pandas as pd
import matplotlib.pyplot as plt
#import plotly.express as px
import seaborn as sns
import researchpy as rp
import scipy.stats as stats

data = pd.read_csv("inpatient_demog_obs_full.csv" ,delimiter= "|")

# =============================================================================
# #CASES VS NON-CASES
'''
This file also evaluates data between the cases and non-cases by examining differences
in the distribution of age and physiological features such as systolic blood presure between
cases and non-cases. Values for statistical comparisons such as t-test
is printed at the end, although the values were uninformative 
'''
# =============================================================================
cases = data.loc[data["OUTCOME"]==1] #8814
casebp = cases["SYSTOLIC_BP"]
all_case_bp = pd.to_numeric(casebp)
case_high_bp = all_case_bp[all_case_bp>130 ]#1648 
case_bp_mean = case_high_bp.mean() #143.85436893203882
#case_bp = cases.loc[pd.to_numeric(cases["SYSTOLIC_BP"])>130 | pd.to_numeric(cases["DIASTOLIC_BP"])>80]
noncases = data.loc[data["OUTCOME"]==0] #9363
noncasebp = noncases["SYSTOLIC_BP"]
all_noncase_bp = pd.to_numeric(noncasebp)
noncase_high_bp = all_noncase_bp[all_noncase_bp>130 ]#1745 
noncase_bp_mean = noncase_high_bp.mean() #144.24126074498568
summary, results = rp.ttest(group1= casebp, group1_name= "CASES",
         group2= noncasebp, group2_name= "NONCASES")


age_counts = cases["AGE"].value_counts()
print(age_counts)
#groups = pd.cut(cases["AGE"], bins = 4 )

#this organizes the data by age interval category which allows for better understanding of age distribution of risk factors

#print(ageint)

bins = [18, 30, 40, 50, 60, 70, 120]
labels = ['18-29', '30-39', '40-49', '50-59', '60-69', '70+']
groups = pd.cut(cases["AGE"], bins, labels = labels,include_lowest = True)
#groups = ["(0, 27.75]","(27.75, 55.5]" ,"(55.5, 83.25]", "(83.25, 111.0]"]
print(cases)
case_ageint = cases.groupby(groups).count()

#case_ageint.plot(kind ="bar" ,y ="PATIENT" ,title="Age Distribution for Cases")

#groups = pd.cut(cases["AGE"], bins = 4 )
noncasegroups = pd.cut(noncases["AGE"], bins, labels = labels,include_lowest = True)

noncase_ageint = noncases.groupby(noncasegroups).count()
#print(ageint)
#x = ["(0, 27.75]","(27.75, 55.5]" ,"(55.5, 83.25]", "(83.25, 111.0]"]

#noncase_ageint.plot(kind ="bar" ,y ="PATIENT" ,title = "Age Distribution for NonCases")


t,p = stats.ttest_ind(data['SYSTOLIC_BP'][data['SYSTOLIC_BP'] == '1'],
                data['SYSTOLIC_BP'][data['SYSTOLIC_BP'] == '0'])

print(t)
print(p)