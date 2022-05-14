# Code of Machine learning 

using CSV
using DataFrames
using MLJ
# using GLM

# Read the input file from encounters_demographics
file_name = "../data/encounters_demographics.txt"

# choose ML algorithm
println("\nPlease choose algorithm: ")
println("\n1: Linear Binary   \n\n2: Decision Tree      \n\n3: Random Forest    \n\n4: Evo Tree")
println("\nYour choice: ")
choose = readline(stdin) 


# load the file and remove the ID columns
df = CSV.File(file_name; header = 1,delim="|") |> DataFrame

# remove the columns that will not contribute the learning. 
select!(df, Not(:Patient))      # string can't be used for learning
select!(df, Not(:Encounter))    # string can't be used for learning
select!(df, Not(:Birthdate))    # Date can't be used for learning
select!(df, Not(:Deathdate))    # has so many missing data
select!(df, Not(:Duration))     # will cause accuracy to 100%


# Update Gender, Race, and Enthnicity into numeric value
df.Gender = @. ifelse(df.Gender =="M", 1, df.Gender)
df.Gender = @. ifelse(df.Gender =="F", 2, df.Gender)

df.Race = @. ifelse(df.Race =="native", 1, df.Race)
df.Race = @. ifelse(df.Race =="black", 2, df.Race)
df.Race = @. ifelse(df.Race =="white", 3, df.Race)
df.Race = @. ifelse(df.Race =="asian", 4, df.Race)
df.Race = @. ifelse(df.Race =="other", 5, df.Race)

df.Ethnicity = @. ifelse(df.Ethnicity =="nonhispanic", 1, df.Ethnicity)
df.Ethnicity = @. ifelse(df.Ethnicity =="hispanic", 2, df.Ethnicity)


# println(describe(df))

coerce!(df, :Outcome => OrderedFactor{2})

y, X = unpack(df, ==(:Outcome));

# Split the data into train and test sets
train, test = partition(eachindex(y),0.8, rng=123)

# Prepare the algorithm
if choose == "1"
    ML_Model = @load LinearBinaryClassifier() pkg=GLM
    train_model = ML_Model()

elseif choose == "2"
    ML_Model = @load DecisionTreeClassifier() pkg=DecisionTree
    train_model = ML_Model(max_depth = 5, min_samples_split=3)
    
elseif choose == "3"
    ML_Model = @load RandomForestClassifier() pkg=DecisionTree
    train_model = ML_Model()
    
elseif choose == "4"
    # import Pkg
    # Pkg.add("EvoTrees")
    ML_Model = @load EvoTreeClassifier() pkg=EvoTrees
    train_model = ML_Model(max_depth=3)
else
    println("Invalid Choice! ")
    return
end 

# Train the data
class_model = machine(train_model, X, y)
fit!(class_model, rows = train)
yhat = predict(class_model, X[test, :])

# Calculate the accuracy and f1 score
acc = accuracy(mode.(yhat), y[test])
f1_score = f1score(mode.(yhat),y[test])

println("Test accuracy = $acc")
println("F1 Score = $f1_score")