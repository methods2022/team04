# Code for machine learning, based on 24 features

using CSV
using DataFrames
using MLJ
# using GLM

file_name = "../data/inpatient_full_0427.csv"

# choose ML algorithm
println("\nPlease choose algorithm: ")
println("\n1: Linear Binary   \n\n2: Decision Tree      \n\n3: Random Forest    \n\n4: Evo Tree  \n\n5. SVM")
println("\nYour choice: ")
choose = readline(stdin)


# load the file and remove the ID columns
df = CSV.File(file_name; header = 1,delim="|") |> DataFrame

# remove the columns that will not contribute the learning. 
select!(df, Not(:PATIENT))      # string can't be used for learning
select!(df, Not(:ENCOUNTER))    # string can't be used for learning
select!(df, Not(:DURATION))     # will cause accuracy to 100%

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

# println(describe(df))

coerce!(df, :OUTCOME => OrderedFactor{2})

y = df.OUTCOME
X = select(df, Not(:OUTCOME))

train, test = partition(eachindex(y),0.8)

best_acc = 0
remove_item = ""
best_f1_score = 0

for item in names(X)
    # Remove one feature from the feature list randomly.
    X_sub = select(X, Not([item]))

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
        ML_Model = @load EvoTreeClassifier() pkg=EvoTrees
        train_model = ML_Model(max_depth=3)
    elseif choose == "5"
        using LIBSVM
        Xtrain = transpose(Matrix(X_sub[1:1:10000,:]))
        Xtest  = transpose(Matrix(X_sub[10000:1:end,:]))
        ytrain = y[1:1:10000]
        ytest  = y[10000:1:end]
        model = svmtrain(Xtrain, ytrain)
        yhat, decision_values = svmpredict(model, Xtest);
        global acc = mean(yhat .== ytest)
        global f1_score = f1score(yhat,ytest)
        println(item, "\t Accuracy = $acc \t")
        println("F1 Score = $f1_score")

    else
        println("Invalid Choice! ")
        return
    end 

    if choose != "5"
        class_model = machine(train_model, X_sub, y)
        fit!(class_model, rows = train)
        yhat = predict(class_model, X_sub[test, :])

        
        global acc = accuracy(mode.(yhat), y[test])
        global f1_score = f1score(mode.(yhat),y[test])

        println(item,"\tAccuracy = $acc")
        println("F1 Score = $f1_score")
    end

    # Only keep the best accuracy
    if acc > best_acc
        global best_acc = acc
        global remove_item = item
        global best_f1_score = f1_score
    end
end

println("Best Accuracy = $best_acc")
println("Best f1 Score = $best_f1_score")
println("Removed Item:  $remove_item")