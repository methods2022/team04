# The code to extract patient demographics data from patient.csv file

dirt = "/gpfs/data/biol1555/0_shared/0_data/synthea/100k_synthea_covid19_csv/"

function extract_demo(dirt)

    # Prepare the input and output files
    input_file_name = string(dirt, "patients.csv")
    output_file_name = "proj_patient_demographics.txt"
    input_file = open(input_file_name,"r")
    output_file = open(output_file_name,"w")

    line_count = 0

    # Write the header into file
    println(output_file,"patient|birthdate|deathdate|race|ethnicity|gender")

    for line in readlines(input_file)
        line_count += 1

        if line_count == 1
            field_array = split(line,",")
            global patient_index = findfirst(isequal("Id"),field_array)
            global birth_index = findfirst(isequal("BIRTHDATE"),field_array)
            global death_index = findfirst(isequal("DEATHDATE"),field_array)
            global race_index = findfirst(isequal("RACE"),field_array)
            global ethnicity_index = findfirst(isequal("ETHNICITY"),field_array)
            global gender_index = findfirst(isequal("GENDER"),field_array)
            continue
        end

        line_part_array = split(line,",")

        patient   = line_part_array[patient_index]
        birthdate = line_part_array[birth_index]
        deathdate = line_part_array[death_index]
        race      = line_part_array[race_index]
        ethnicity = line_part_array[ethnicity_index]
        gender    = line_part_array[gender_index]
        
        println(output_file,"$patient|$birthdate|$deathdate|$race|$ethnicity|$gender")

    end
    close(output_file)
    println(" ")
    println("Result saved to $output_file_name")
    println(" ")
end 

extract_demo(dirt)