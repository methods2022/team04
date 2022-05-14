# Generatibg age group and dataframes used for visualizations and statistics

using CSV
using DataFrames
using CategoricalArrays

# calling in dataset
data = "/gpfs/data/biol1555/projects2022/team04/data/inpatient_full_0427.csv"
df  = CSV.File(data, header = 1, delim = "|") |> DataFrame

# selecting age and duration columns into a new data frame 
age_dur = df[:, [3, 9]]


#############################
# -- GENERATE AGE GROUPS -- #
#############################
    # reference for age groups: https://www.cdc.gov/coronavirus/2019-ncov/covid-data/investigations-discovery/hospitalization-death-by-age.html

# selecting the age column 
age = age_dur[:, 2]
#println(first(age, 7))

# output file for age group 
output_file = open("gpfs/data/biol1555/projects2022/team04/data/agegrp.txt", "w")

# add header line 
write(output_file, "AGE_GROUP \n")

for i in age
    #println(i)

    if (i >= 0 && i <= 4)
        agegrp = "0-4"
    elseif (i >= 5 && i <= 17)
        agegrp = "5-17"
    elseif (i >= 18 && i <= 29)
        agegrp = "18-29"
    elseif (i >= 30 && i <= 39)
         agegrp = "30-39"
    elseif (i >= 40 && i <= 49)
         agegrp = "40-49"
    elseif (i >= 50 && i <= 64)
         agegrp = "50-64"
    elseif (i >= 65 && i <= 74)
         agegrp = "65-74"
    elseif (i >= 75 && i <= 84)
         agegrp = "75-84"
    else
         agegrp = "85+"

    end

    #println("age group: $i: $agegrp")

    # write to output file
    write(output_file, "$agegrp \n")

end

# call in age group file and convert to DataFrame
age_group = "/gpfs/data/biol1555/projects2022/team04/data/agegrp.txt"
age_group_df = CSV.File(age_group, header = 1) |> DataFrame 

# merging/combing age group dataframe and age/duration data frame
new_df = hcat(age_dur, age_group_df)
#println(first(new_df, 6))

# selecting duration and agegrp 
dur_agegrp = new_df[:, [1, 3]]
#println(first(dur_agegrp, 7))

# extract age group
agegrp = dur_agegrp[:, 2]


#################################################
# -- Dataset: Ordered Age Group and Duration -- #
#################################################

# rearrange group age group so it's in the correct order: use Categorical Arrays 
age_cat = CategoricalArray(agegrp, ordered=true)
#println(levels(age_cat)) #String7["0-4", "18-29", "30-39", "40-49", "5-17", "50-64", "65-74", "75-84", "85+"]

agegrp2 = levels!(age_cat, ["0-4","5-17", "18-29", "30-39", "40-49", "50-64", "65-74", "75-84", "85+"])
#println(levels(agegrp2)) #String7["0-4", "5-17", "18-29", "30-39", "40-49", "50-64", "65-74", "75-84", "85+"]

# combine ordered age group with dataframe
dur_agegrp2 = hcat(dur_agegrp, agegrp2)

# change column name 
dur_agegrp2 = rename!(dur_agegrp2, :x1 => "age_group_cat")
#println(first(dur_agegrp2, 5))

# export this dataframe
CSV.write("duration_agegroup.csv", dur_agegrp2, delim = "|")


######################################################################
# -- Dataset: Frequencies, Proportions for Age Group for Duration -- #
######################################################################

# create a grouped dataframe (to get frequencies, proportions, etc) -> gets the # of rows for each duration for each age group
gdf = groupby(dur_agegrp2, [:DURATION, :age_group_cat])

# get frequencies 
freq = combine(gdf, nrow => :count)

# get sum (total number for each duration), add to dataframe with frequencies/count
freq_sum = transform(groupby(freq, :DURATION), :count => sum => :sum)

# get proportion of duration by age group
    #https://discourse.julialang.org/t/compute-frequency-or-proportions-on-grouped-dataframes/62835/8
age_prop = transform(groupby(freq_sum, :DURATION), :count => (x -> x / sum(x)) => :prop)

# get percent of proportion 
age_prop = transform(age_prop, :prop => (x -> x*100) => :percent)
#println(first(age_prop, 10))

# export this dataframe
CSV.write("duration_agegroup_prop.csv", age_prop, delim = "|")
    
