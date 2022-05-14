# Visualizations: age and duration, age and LOS
# Note: this file was run on VSCode directly on personal computer with no problems/issues with PyPlot, so one may have to install VSCode and Julia on their computers to run the code for the pie charts (there seems to be issues with PyPlot via Oscar)


using CSV 
using DataFrames
using CategoricalArrays
using Plots
using StatsPlots
using PyPlot

# calling in dataframes (from TS_data.jl)  
data_agegrp = "/gpfs/data/biol1555/projects2022/team04/data/duration_agegroup.csv"
dur_agegrp = CSV.File(data_agegrp, header = 1, delim = "|") |> DataFrame

data_ageprop = "/gpfs/data/biol1555/projects2022/team04/data/duration_agegroup_prop.csv"
age_prop = CSV.File(data_ageprop, header = 1, delim = "|") |> DataFrame

# fixing age_group_cat column: reordering age_group_cat
    #source 1: https://stackoverflow.com/questions/69401368/can-catagoricalarrays-be-used-with-julia-dataframes-to-convert-multiple-columns

# fix dur_agegrp dataframe
ag1 = dur_agegrp[:, 3]
ag1_order = CategoricalArray(ag1, ordered=true)
ag1_order = levels!(ag1_order, ["0-4","5-17", "18-29", "30-39", "40-49", "50-64", "65-74", "75-84", "85+"])
dur_agegrp[!, :age_group_cat] = ag1_order #replace age_group_cat column with the ordered age group (source 1)

# fix age_prop dataframe
age_prop = transform!(age_prop, names(age_prop, AbstractString) .=> categorical, renamecols=false)
ag2 = age_prop[:, 2]
ag2_order = levels!(ag2, ["0-4","5-17", "18-29", "30-39", "40-49", "50-64", "65-74", "75-84", "85+"])
age_prop[!, :age_group_cat] = ag2_order #replace age_group_cat column with ordered age group (source 1)



##########################
# -- STACKED BAR PLOT -- #
##########################  

# selecting columns of interest: duration, prop, age group
duration = age_prop[:, :1]
prop = age_prop[:, :5]
agegroup = age_prop[:, :2]

plot = groupedbar(duration, prop, group = agegroup, xlabel = "Duration of Hospital Stay (Days)", ylabel = "Percentages", title = "Duration of Stay by Age Group", bar_position = :stack, bar_width = 0.7, legend =:outertopright) #legend is outside of figure 
display(plot)
read(stdin, Char) #this keeps the plot open

# save plot
png(plot, "age-distribution")


###################
# -- HISTOGRAM -- #
###################

hist_plot = @df dur_agegrp groupedhist(:DURATION, group = :age_group_cat, bar_position = :stack, xlabel = "Duration of Hospital Stay (Days)")
display(hist_plot)
read(stdin, Char) #this keeps the plot open

# save plot
png(hist_plot, "age-hist")


#################
# -- BOXPLOT -- #
#################
# using dur_agegrp dataframe 

# sort dataframe by age group (in ascending order)
dur_agegrp = sort!(dur_agegrp, :age_group_cat) #source: #https://dataframes.juliadata.org/stable/man/sorting/
#println(first(dur_agegrp, 10))

# pulling out duration and age group columns
dur_bp = dur_agegrp[:, 1]
age_bp = dur_agegrp[:, 3]

age_bp = groupedboxplot(age_bp, dur_bp, bar_width = 0.8, xlabel = "Age Group", ylabel = "Duration of Hospital Stay (Days)", legend = false)
display(age_bp)
read(stdin, Char) #this keeps the plot open

# save plot
png(age_bp, "age-boxplot")



##################
# - PIE CHARTS - #
##################
    # source for pie chart plots: https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.pie.html#matplotlib.pyplot.pie

# create outcome variable (duration <= 14 --> LOS = 0; duration > 14 --> LOS = 1)
duration_outcome = transform!(dur_agegrp, :DURATION => ByRow(dur -> ifelse(dur <=14, 0, 1)) => :outcome)
#println(first(duration_outcome, 5))

gdf_dur = groupby(duration_outcome, [:age_group_cat, :outcome])
freq_dur = combine(gdf_dur, nrow => :count)

freq_dur_sum = transform(groupby(freq_dur, :outcome), :count => sum => :sum)

# proportions of the age groups
dur_outcome_prop = transform(groupby(freq_dur_sum, :outcome), :count => (x -> x / sum(x)) => :prop)
#println(dur_outcome_prop)

age_groups = ["0-4","5-17", "18-29", "30-39", "40-49", "50-64", "65-74", "75-84", "85+"]

# proportion values for LOS outcome of 0
los0 = filter(:outcome => outcome -> outcome == 0, dur_outcome_prop)
los0_values = los0[:, 5]

# proportion values for LOS outcome of 1
los1 = filter(:outcome => outcome -> outcome == 1, dur_outcome_prop)
los1_values = los1[:, 5]

# pie chart: duration --> LOS outcome = 1
    #image file name: age-outcome1-pie.png
using PyPlot
pygui(true)
pygui(:qt5)
fig1, ax1 = plt.subplots()
ax1.pie(los1_values, labels = labels, labeldistance = 1.075, autopct="%1.1f%%", pctdistance = 0.7,shadow = true, startangle = 45)
ax1.axis("equal")
PyPlot.title("Age Distribution for Long LOS ( > 14 days)", pad = 15) 
plt.show()

# pie chart: duration --> LOS outcome = 0
    #image file name: age-outcome0-pie.png
using PyPlot
pygui(true)
pygui(:qt5)
fig1, ax1 = plt.subplots()
ax1.pie(los0_values, labels = labels, labeldistance = 1.075, autopct="%1.1f%%", pctdistance = 0.77, shadow = true,startangle = 45)
ax1.axis("equal")
PyPlot.title("Age Distribution for Short LOS (< 14 days)", pad = 15) 
plt.show()
