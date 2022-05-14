# Code of Machine learning, based on Patient Demographics and two conditions

using CSV
using DataFrames
using MLJ
# using GLM

# Read the data
file_name = "../data/inpatient_full_0427.csv"

# Ask user to choose ML algorithm
println("\nPlease choose algorithm: ")
println("\n1: Linear Binary   \n\n2: Decision Tree      \n\n3: Random Forest    \n\n4: Evo Tree  \n\n5. SVM")
println("\nYour choice: ")
choose = readline(stdin)


# load the file, keep Demographics and conditions only
df = CSV.File(file_name; header = 1,delim="|") |> DataFrame
df = select(df, [:OUTCOME,:GENDER,:RACE,:ETHNICITY,:AGE,:HYPERTENSION,:DIABETES])

# Update Gender, Race, and Enthnicity into numeric value
df.GENDER = @. ifelse(df.GENDER =="M", 1, df.GENDER)
df.GENDER = @. ifelse(df.GENDER =="F", 2, df.GENDER)

df.RACE = @. ifelse(df.RACE =="native", 1, df.RACE)
df.RACE = @. ifelse(df.RACE =="black", 2, df.RACE)
df.RACE = @. ifelse(df.RACE =="white", 3, df.RACE)
df.RACE = @. ifelse(df.RACE =="asian", 4, df.RACE)
df.RACE = @. ifelse(df.RACE =="other", 5, df.RACE)

df.ETHNICITY = @. ifelse(df.ETHNICITY =="nonhispanic", 1, df.ETHNICITY)
df.ETHNICITY = @. ifelse(df.ETHNICITY =="hispanic", 2, df.ETHNICITY)

# Prepare the data for training and testing
coerce!(df, :OUTCOME => OrderedFactor{2})

y = df.OUTCOME
X = select(df, Not(:OUTCOME))

train, test = partition(eachindex(y),0.8)

# Prepare the model
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
elseif choose == "5"
    # SVM is different with other algorithms
    
    using LIBSVM
    Xtrain = transpose(Matrix(X[1:1:10000,:]))
    Xtest  = transpose(Matrix(X[10000:1:end,:]))
    ytrain = y[1:1:10000]
    ytest  = y[10000:1:end]
    model = svmtrain(Xtrain, ytrain)
    yhat, decision_values = svmpredict(model, Xtest)
    f1_score = f1score(yhat,ytest)
    println("Accuracy:  \t", mean(yhat .== ytest))
    println("F1 Score = $f1_score")

else
    println("Invalid Choice! ")
    return
end 

# Traing the model, calculate the accuracy and F1 score 
if choose != "5"
    class_model = machine(train_model, X, y)
    fit!(class_model, rows = train)
    yhat = predict(class_model, X[test, :])

    acc = accuracy(mode.(yhat), y[test])
    f1_score = f1score(mode.(yhat),y[test])

    println("Accuracy = $acc")
    println("F1 Score = $f1_score")
end