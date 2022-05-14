import pandas as pd
import matplotlib.pyplot as plt
#import plotly.express as px
import seaborn as sns
import researchpy as rp
import scipy.stats as stats

data = pd.read_csv("/gpfs/data/biol1555/projects2022/team04/data/inpatient_demog_obs_full.csv" ,delimiter= "|")

#VISUALIZATIONS FOR COMBINED ATTRIBUTES
'''
Based off of the poor model performance, we aimed to identify differences between the 
feature distribution of short-term patients (non-cases) and long-term patients (cases)
to better grasp the intuitive reasons for why the model couldn't discriminate. Values for specific variables are commented
'''
black_total = data.loc[data["RACE"]=='black' ]
black_total_num = len(black_total) #1556 patients

black_cases= black_total.loc[black_total["OUTCOME"]==0]
black_proportion = len(black_cases)/black_total_num # 0.47879
#black_total.plot.pie(subplots='True')


white_total = data.loc[data["RACE"]=='white' ]
white_total_num = len(white_total) #15205 patients

white_cases= white_total.loc[white_total["OUTCOME"]==0]
white_proportion = len(white_cases)/white_total_num # 0.4869
#white_total.plot.pie(subplots='True')

asian_total = data.loc[data["RACE"]=='asian' ]
asian_total_num = len(asian_total) #1315 patients

asian_cases= asian_total.loc[asian_total["OUTCOME"]==0]
asian_proportion = len(asian_cases)/asian_total_num # 0.4768

native_total = data.loc[data["RACE"]=='native' ]
native_total_num = len(native_total)
native_cases= native_total.loc[native_total["OUTCOME"]==0]

other_total = data.loc[data["RACE"]=='other' ]
asian_total_num = len(asian_total)
other_cases= other_total.loc[other_total["OUTCOME"]==0]

# Pie chart, where the slices will be ordered and plotted counter-clockwise:
labels = 'black (8.45%)', 'white (84.0%)', 'asian(7.11%)', 'native (0.91%)', 'other (0.079%)'
noncase_labels = 'black (8.6%)', 'white (83.6%)', 'asian(7.2%)', 'native (0.91%)', 'other (0.23%)'

denom = 9363#8814 or 9363 (noncase)
blacksize = len(black_cases)/denom*100
whitesize = len(white_cases)/denom*100
asiansize= len(asian_cases)/denom*100
nativesize= len(native_total)/denom*100
othersize = len(other_cases)/denom*100
sizes = [blacksize, whitesize, asiansize, nativesize,othersize]
explode = (0, 0.1, 0, 0,0)  # only "explode" the 2nd slice 

fig1, ax1 = plt.subplots()
ax1.pie(sizes, explode=explode,
        shadow=True, startangle=90)
plt.legend(labels)
ax1.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle.
plt.title("Racial Distribution for NonCases")
plt.show()