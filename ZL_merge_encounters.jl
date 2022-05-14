using Dates
using CSV
using DataFrames
using Statistics

# Read in two extractions from the encounters.csv file
# inpatient_cohort is patients admitted to the hospital ward for covid
inpatient_cohort = "/gpfs/data/biol1555/projects2022/team04/data/inpatient_covid_cohort.txt"
# ICU_cohort is patients admitted to the ICU
ICU_cohort = "/gpfs/data/biol1555/projects2022/team04/data/ICU_covid_cohort.txt"

log_file = open("merge_encounters_log.txt", "w")


# make two DataFrames
inpatient_df = CSV.File(inpatient_cohort; header = 1,delim="|") |> DataFrame
ICU_df = CSV.File(ICU_cohort; header = 1,delim="|") |> DataFrame


for ID in ICU_df.patient # iterate of ICU patient IDs
    if ID in inpatient_df.patient # check they exist in the inpatient ID list

        # find corresponding records from both patients
        inpatient_pt = inpatient_df[only(findall(.==(ID), inpatient_df.patient)), :]
        ICU_pt = ICU_df[only(findall(==(ID), ICU_df.patient)), :]
        #println("Patient match found!!!")

        if ICU_pt.start == inpatient_pt.stop # check if ICU admission continuous with ward LOS
            total_duration = ICU_pt.duration + inpatient_pt.duration
            #println("Total = $total_duration (ward = $(inpatient_pt.duration), ICU = $(ICU_pt.duration))")
            
            inpatient_pt.duration = total_duration
            inpatient_pt.ICU = 1
            write(log_file,"Patient went ward --> ICU\n")        
        elseif ICU_pt.stop == inpatient_pt.start
            total_duration = ICU_pt.duration + inpatient_pt.duration
            #println("Total = $total_duration (ward = $(inpatient_pt.duration), ICU = $(ICU_pt.duration))")
            
            inpatient_pt.duration = total_duration
            inpatient_pt.ICU = 1
            write(log_file,"Patient went ICU --> ward\n")
        else
            write(log_file,"ICU and ward non continuous\n")
        end
    else
        write(log_file,"********Patient not found********\n")
    end


    #print("Patient matched!")

end


mean_duration = round(mean(inpatient_df.duration))
println("Rounded mean duration is $mean_duration !")



function binarize_los(col,threshold)
    # this function takes a df column and a threshold (ours is 14.0 days)
    # it binarizes the column (so if a value > 14, it returns a 1 or if value <14, returns 0)
    binarized_outcomes = Vector{Int64}()

    for duration in col
        if duration > threshold
            append!(binarized_outcomes,1)
        else
            append!(binarized_outcomes,0)
        end
    end
    return binarized_outcomes
end

binary_los = binarize_los(inpatient_df[!,:duration],mean_duration)

inpatient_df[!,:outcome] = binary_los

#remove start and stop dates from the output file
select!(inpatient_df, Not(:start))
select!(inpatient_df, Not(:stop))


CSV.write("encounters_total_dur.txt",inpatient_df,delim = "|")
close(log_file)
println("All done")