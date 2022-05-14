import pandas as pd
import matplotlib.pyplot as plt
#import plotly.express as px
import seaborn as sns
import researchpy as rp
import scipy.stats as stats

data = pd.read_csv("/gpfs/data/biol1555/projects2022/team04/data/inpatient_demog_obs_full.csv" ,delimiter= "|")
# =============================================================================
# PERHAPS NOT VIABLE
# This file aims to identify null values for some of the categories that are suspected
#of having too many missing data to properly inform an ML model (BMI nulls were compared 
# to other null totals in order to )
# =============================================================================
bmi_missing= data['BMI'].isnull().sum()
height_missing= data['BODY_HEIGHT'].isnull().sum()
print(bmi_missing)
print(height_missing)

bmi_missing= data['BMI'].isnull().sum()
sys_bp_missing= data['SYSTOLIC_BP'].isnull().sum()
height_missing= data['HEIGHT'].isnull().sum()
