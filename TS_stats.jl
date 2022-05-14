# Statistics and Analysis of Age 

using CSV
using DataFrames
using CategoricalArrays
using Statistics
using HypothesisTests

# calling in dataframe 
data_agegrp = "/gpfs/data/biol1555/projects2022/team04/data/duration_agegroup.csv"
dur_agegrp = CSV.File(data_agegrp, header = 1, delim = "|") |> DataFrame

#fixing age_group_cat column
ag = dur_agegrp[:, 3]
ag_order = CategoricalArray(ag, ordered=true)
ag_order = levels!(ag_order, ["0-4","5-17", "18-29", "30-39", "40-49", "50-64", "65-74", "75-84", "85+"])
dur_agegrp[!, :age_group_cat] = ag_order

################################
# -- DESCRIPTIVE STATISTICS -- #
################################

# mean duration value of age groups
    #source: https://dataframes.juliadata.org/stable/man/split_apply_combine/
mean_dur = combine(groupby(dur_agegrp, :age_group_cat), :DURATION => mean => :mean)
mean_dur = sort!(mean_dur, :age_group_cat) #https://dataframes.juliadata.org/stable/man/sorting/
#println(mean_dur)


###############
# -- ANOVA -- #
###############

# getting duration for each of the age groups  

# filter for each of the age groups
        #source for filter: https://dataframes.juliadata.org/stable/lib/functions/#Base.filter
agegrp1 = filter(:AGE_GROUP => age -> age == "0-4", dur_agegrp)
agegrp2 = filter(:AGE_GROUP => age -> age == "5-17", dur_agegrp)
agegrp3 = filter(:AGE_GROUP => age -> age == "18-29", dur_agegrp)
agegrp4 = filter(:AGE_GROUP => age -> age == "30-39", dur_agegrp)
agegrp5 = filter(:AGE_GROUP => age -> age == "40-49", dur_agegrp)
agegrp6 = filter(:AGE_GROUP => age -> age == "50-64", dur_agegrp)
agegrp7 = filter(:AGE_GROUP => age -> age == "65-74", dur_agegrp)
agegrp8 = filter(:AGE_GROUP => age -> age == "75-84", dur_agegrp)
agegrp9 = filter(:AGE_GROUP => age -> age == "85+", dur_agegrp)

# extract the duration values
dur_values1 = agegrp1[:, 1]
dur_values2 = agegrp2[:, 1]
dur_values3 = agegrp3[:, 1]
dur_values4 = agegrp4[:, 1]
dur_values5 = agegrp5[:, 1]
dur_values6 = agegrp6[:, 1]
dur_values7 = agegrp7[:, 1]
dur_values8 = agegrp8[:, 1]
dur_values9 = agegrp9[:, 1]

# Run a one way ANOVA test to see if the distributions are different among age groups
groups = [dur_values1, dur_values2, dur_values3, dur_values4, dur_values5, dur_values6, dur_values7, dur_values8, dur_values9]
anova = OneWayANOVATest(groups...)
println(anova)
println(pvalue(anova))

