# Code to plot the result

using VegaLite
using VegaDatasets
using DataFrames
using CSV

# Read the file into dataframe
file_name = "../data/inpatient_full_0427.csv"
df = CSV.File(file_name; header = 1,delim="|") |> DataFrame


inpatient = @vlplot(
                data = df,
                mark = {type = "point"},
                encoding = {
                    x = {field = "DURATION", type = "quantitative"},
                    y = {field = "AGE", type = "quantitative"},
                    color = {field = "DURATION", type = "nominal",
                            scale = {range = ["blue", "magenta", "teal"]}},
                    shape = {field = "DURATION", type = "nominal"}
                    }
                );
# save the plot
save("../plots/inpatient.pdf", inpatient)
println("Plot saved!")
