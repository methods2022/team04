import pandas as pd
import matplotlib.pyplot as plt
#import plotly.express as px
import seaborn as sns
import researchpy as rp
import scipy.stats as stats

data = pd.read_csv("/gpfs/data/biol1555/projects2022/team04/data/inpatient_demog_obs_full.csv" ,delimiter= "|")
# =============================================================================
# AGE VISUALIZATION AND FRAMING
'''
The full demographic distribution for age was calculated through quartiles.
This was done prior to the ML model for preliminary analysis.
'''
# =============================================================================
age_counts = data["AGE"].value_counts()
print(age_counts)
groups = pd.cut(data["AGE"], bins = 4 )

#this organizes the data by age interval category which allows for better understanding of age distribution of risk factors
ageint = data.groupby(groups).count()
print(ageint)
x = ["(0, 27.75]","(27.75, 55.5]" ,"(55.5, 83.25]", "(83.25, 111.0]"]

ageint.plot(kind ="bar" ,y ="PATIENT" )