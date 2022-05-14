using Dates

# dirt = "/gpfs/data/biol1555/0_shared/0_data/synthea/1k_synthea_sample_csv/"

dirt = "/gpfs/data/biol1555/0_shared/0_data/synthea/100k_synthea_covid19_csv/"

function extract_inpatient(dirt)

    input_file_name = string(dirt, "encounters.csv")
   
    output_file_name = "ICU_covid_cohort.txt"

    input_file = open(input_file_name,"r")

    output_file = open(output_file_name,"w")

    line_count = 0

    covid_count = 0

    duration_total = 0

    println(output_file,"patient|start|stop|duration")

    for line in readlines(input_file)
        line_count += 1

        if line_count == 1
            field_array = split(line,",")
            global patient_index = findfirst(isequal("PATIENT"),field_array)
            #global class_index = findfirst(isequal("ENCOUNTERCLASS"),field_array)
            global procedure_code = findfirst(isequal("CODE"),field_array)
            global start_index = findfirst(isequal("START"),field_array)
            global stop_index = findfirst(isequal("STOP"),field_array)
            global reason_code = findfirst(isequal("REASONCODE"),field_array)
            #global desc_index = findfirst(isequal("REASONDESCRIPTION"),field_array)
            continue
        end

        line_part_array = split(line,",")

        patient = line_part_array[patient_index]
        #class = line_part_array[class_index]
        start = SubString(line_part_array[start_index],1,10)
        stop = SubString(line_part_array[stop_index],1,10)
        proc_code = line_part_array[procedure_code]
        reason = line_part_array[reason_code]

        df = DateFormat("y-m-d")

        start_date = Date(start,df)
        stop_date = Date(stop,df)

        duration = Dates.value(stop_date - start_date)

        #code = line_part_array[code_index]
        #desc = line_part_array[desc_index]

        
        if proc_code == "305351004" && reason =="840539006"
            duration_total += duration
            covid_count += 1
            println(output_file,"$patient|$start|$stop|$duration")
        end
        
    end
    duration_avg = round(duration_total/covid_count;digits=1)
    close(output_file)
    println(" ")
    println("Total COVID ICU patients: $covid_count \t Total duration: $duration_total \t Average Duration: $duration_avg")
    println("Result saved to $output_file_name")
    println(" ")
end 

extract_inpatient(dirt)