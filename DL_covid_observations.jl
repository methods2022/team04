# Code to extract relevant observations from Synthea observations.csv

using DataFrames
using CSV
using Dates


##########################################
#############  File Loading  #############
##########################################

# Set up file of inpatient Covid cohort
input_path = "/gpfs/data/biol1555/projects2022/team04/data/encounters_demographics.txt"
header_names1 = ["PATIENT", "ENCOUNTER", "DURATION", "ICU", "OUTCOME", "BIRTHDATE", "DEATHDATE", "RACE", "ETHNICITY", "GENDER"]

dfmt = dateformat"yyyy-mm-dd"
column_types = Dict(:BIRTHDATE=>Date, :DEATHDATE=>Date)
df1 = CSV.File(input_path; delim = '|', header = header_names1, skipto = 2, types=column_types, dateformat=dfmt) |> DataFrame


# Read in observations.csv file into a dataframe
observations_file = "/gpfs/data/biol1555/0_shared/0_data/synthea/100k_synthea_covid19_csv/observations.csv"
header_names2 = ["DATE", "PATIENT", "ENCOUNTER", "CODE", "DESCRIPTION", "VALUE", "UNITS", "TYPE"]
df2 = CSV.File(observations_file; header = 1) |> DataFrame

# Read in conditions.csv file into dataframe
conditions_file = "/gpfs/data/biol1555/0_shared/0_data/synthea/100k_synthea_covid19_csv/conditions.csv"
header_names2 = ["START", "STOP", "PATIENT", "ENCOUNTER", "CODE", "DESCRIPTION"]
df3 = CSV.File(conditions_file; header = 1) |> DataFrame


##########################################
#############      Age       #############
##########################################

# Determine age and add to the dataframe
df1_age = transform(df1, :BIRTHDATE => x-> year.(x))
df1_age[!,:BIRTHDATE_function] = convert.(Int64,df1_age[!,:BIRTHDATE_function])
df1_age = rename!(df1_age,:BIRTHDATE_function => :AGE)
df1_age.AGE .-= 2020
df1_age.AGE .*= -1

# Drop birthdate and deathdate from dataframe
df1_age = select(df1_age, 1, 2, 3, 4, 5, 8, 9, 10, 11)


##########################################
#############  Observations  #############
##########################################

# Split each observation into unique dataframes, pull out only relevant columns,
# & rename column to match observation
df2_wt  = rename(select(filter(row -> row.CODE == "29463-7", df2), 2, 3, 6), :VALUE => :BODY_WEIGHT)
df2_dbp = rename(select(filter(row -> row.CODE == "8462-4", df2), 2, 3, 6), :VALUE => :DIASTOLIC_BP)
df2_sbp = rename(select(filter(row -> row.CODE == "8480-6", df2), 2, 3, 6), :VALUE => :SYSTOLIC_BP)
df2_hr  = rename(select(filter(row -> row.CODE == "8867-4", df2), 2, 3, 6), :VALUE => :HEART_RATE)
df2_rr  = rename(select(filter(row -> row.CODE == "9279-1", df2), 2, 3, 6), :VALUE => :RESPIRATORY_RATE)
df2_o2  = rename(select(filter(row -> row.CODE == "2708-6", df2), 2, 3, 6), :VALUE => :O2_SAT)
df2_hem = rename(select(filter(row -> row.CODE == "4544-3", df2), 2, 3, 6), :VALUE => :HEMATOCRIT)
df2_sod = rename(select(filter(row -> row.CODE == "2951-2", df2), 2, 3, 6), :VALUE => :SODIUM)
df2_pot = rename(select(filter(row -> row.CODE == "2823-3", df2), 2, 3, 6), :VALUE => :POTASSIUM)
df2_cal = rename(select(filter(row -> row.CODE == "17861-6", df2), 2, 3, 6), :VALUE => :CALCIUM)
df2_chl = rename(select(filter(row -> row.CODE == "2075-0", df2), 2, 3, 6), :VALUE => :CHLORIDE)
df2_co2 = rename(select(filter(row -> row.CODE == "2028-9", df2), 2, 3, 6), :VALUE => :CO2)
df2_ure = rename(select(filter(row -> row.CODE == "3094-0", df2), 2, 3, 6), :VALUE => :UREA_NITROGEN)
df2_glu = rename(select(filter(row -> row.CODE == "2345-7", df2), 2, 3, 6), :VALUE => :GLUCOSE)
df2_ser = rename(select(filter(row -> row.CODE == "2276-4", df2), 2, 3, 6), :VALUE => :SERUM_FERRITIN)
df2_car = rename(select(filter(row -> row.CODE == "89579-7", df2), 2, 3, 6), :VALUE => :CARDIAC_TROPONIN)
df2_lac = rename(select(filter(row -> row.CODE == "14804-9", df2), 2, 3, 6), :VALUE => :LACTATE_DEHYDROGENASE)
df2_ddi = rename(select(filter(row -> row.CODE == "48065-7", df2), 2, 3, 6), :VALUE => :D_DIMER)

# Refine dataframe to only unique encounter IDS
df2_uniq = unique!(df2, 3)
df2_uniq = select(df2_uniq, 2, 3)

# Remove any repeat entries and join all the observations into one dataframe
df2_wt = unique!(df2_wt, 2)
df2_obs = leftjoin(df2_uniq, df2_wt, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_dbp = unique!(df2_dbp, 2)
df2_obs = leftjoin(df2_obs, df2_dbp, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_sbp = unique!(df2_sbp, 2)
df2_obs = leftjoin(df2_obs, df2_sbp, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_hr = unique!(df2_hr, 2)
df2_obs = leftjoin(df2_obs, df2_hr, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_rr = unique!(df2_rr, 2)
df2_obs = leftjoin(df2_obs, df2_rr, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_o2 = unique!(df2_o2, 2)
df2_obs = leftjoin(df2_obs, df2_o2, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_hem = unique!(df2_hem, 2)
df2_obs = leftjoin(df2_obs, df2_hem, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_sod = unique!(df2_sod, 2)
df2_obs = leftjoin(df2_obs, df2_sod, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_pot = unique!(df2_pot, 2)
df2_obs = leftjoin(df2_obs, df2_pot, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_cal = unique!(df2_cal, 2)
df2_obs = leftjoin(df2_obs, df2_cal, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_chl = unique!(df2_chl, 2)
df2_obs = leftjoin(df2_obs, df2_chl, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_co2 = unique!(df2_co2, 2)
df2_obs = leftjoin(df2_obs, df2_co2, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_ure = unique!(df2_ure, 2)
df2_obs = leftjoin(df2_obs, df2_ure, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_glu = unique!(df2_glu, 2)
df2_obs = leftjoin(df2_obs, df2_glu, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_ser = unique!(df2_ser, 2)
df2_obs = leftjoin(df2_obs, df2_ser, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_car = unique!(df2_car, 2)
df2_obs = leftjoin(df2_obs, df2_car, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_lac = unique!(df2_lac, 2)
df2_obs = leftjoin(df2_obs, df2_lac, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df2_ddi = unique!(df2_ddi, 2)
df2_obs = leftjoin(df2_obs, df2_ddi, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)

df_obs = leftjoin(df1_age, df2_obs, on = [:PATIENT, :ENCOUNTER], matchmissing=:notequal)


##########################################
#############   Conditions   #############
##########################################

# Extracting conditions
df3_hyp = rename(select(filter(row -> row.DESCRIPTION == "Hypertension", df3), 3, 6), :DESCRIPTION => :HYPERTENSION)
df_cond = leftjoin(df_obs, df3_hyp, on = [:PATIENT], matchmissing=:notequal)

df3_dia = rename(select(filter(row -> row.DESCRIPTION == "Diabetes", df3), 3, 6), :DESCRIPTION => :DIABETES)
df_cond = leftjoin(df_cond, df3_dia, on = [:PATIENT], matchmissing=:notequal)

# Assign 1 or 0 if condition is present
df_cond.HYPERTENSION = @. ifelse(coalesce(df_cond.HYPERTENSION == "Hypertension", false), "1", "0")
df_cond.DIABETES = @. ifelse(coalesce(df_cond.DIABETES == "Diabetes", false), "1", "0")


# Write final output file
output_path = "/gpfs/data/biol1555/projects2022/team04/data/inpatient_full_0427.csv"
CSV.write(output_path, df_cond, delim = '|')