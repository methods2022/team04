# merge patient demographics with encounters/outcome

using CSV
using DataFrames

# read in the input files and convert them to dataframes
patient_demographics = "/gpfs/data/biol1555/projects2022/team04/TS/proj_patient_demographics.txt"
header_names_pd = ["Patient", "Birthdate", "Deathdate", "Race", "Ethnicity", "Gender"]
df_pd = CSV.File(patient_demographics; header = header_names_pd, skipto = 2, delim = "|") |> DataFrame

outcomes = "/gpfs/data/biol1555/projects2022/team04/data/encounters_total_dur.txt"
header_names_outcomes = ["Patient", "Encounter", "Duration", "ICU", "Outcome"]
df_o = CSV.File(outcomes; header = header_names_outcomes, skipto = 2, delim = "|") |> DataFrame

#println(first(df_pd, 5))
#println(first(df_o, 5))

# joining patient ids that are both in outcomes and patient demographics 
output_df = innerjoin(df_o, df_pd, on = :Patient) 
println(first(output_df,10))

# write the merged dataframe to a csv file
CSV.write("encounters_demographics.txt", output_df, delim = "|")


# Sources
    # 1. https://towardsdatascience.com/read-csv-to-data-frame-in-julia-programming-lang-77f3d0081c14 
    # 2. https://dataframes.juliadata.org/stable/man/joins/