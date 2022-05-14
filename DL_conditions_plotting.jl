# Creating some plots based on conditions (hypertension & diabetes)

using DataFrames
using CSV
using StatsPlots

# Set up input file
data_file = "/gpfs/data/biol1555/projects2022/team04/data/inpatient_full_0427.csv"
df = CSV.File(data_file; header = 1) |> DataFrame

## Hypertension Plots ##
hypertension = @df df groupedhist(:DURATION; group = (:HYPERTENSION))
savefig(hypertension,"hypertension.png")

## Diabetes Plots ##
diabetes = @df df groupedhist(:DURATION; group = (:DIABETES))
savefig(diabetes,"diabetes.png")