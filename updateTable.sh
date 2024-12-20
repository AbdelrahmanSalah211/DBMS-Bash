#!/bin/bash
flag=true
while $flag; do
    read -p "Enter the name of the table: " tableName
    while ! [[ $tableName =~ ^([a-zA-Z])[a-zA-Z0-9_-]*([a-zA-Z0-9])$ ]]; do
        echo "---${tableName}--- is not a valid name"
        echo "The table name must:"
        echo "- Start with a letter (a-z or A-Z)."
        echo "- Contain only letters, numbers, hyphens, and underscores."
        echo "- End with a letter or number."
        read -p "Please enter a valid name: " tableName
    done

    metaDataFile="./databases/$1/metadata"
    dataFile="./databases/$1/$tableName.txt"

    if [ ! -f "${metaDataFile}" ]; then
        echo "No tables existing"
        echo ""
        source connectDB.sh $1
    fi

    tableExit=$(grep "${tableName}|" "${metaDataFile}")

    if [ -n "${tableExit}" ]; then
        primaryKeyField=$(grep "^${tableName}|" "$metaDataFile" | awk -F"|" '{split($3,pk,":"); print pk[2]}')


primaryKeyDataType=$(grep "^${tableName}|" "$metaDataFile" | awk -F"|" '{
        fields=$2;
        split($3,pk,":");
        pk_name=pk[2];
        
        split(fields,field_array,",");
        
        # Look for the field matching PK name
        for(i in field_array) {
            split(field_array[i],field,":");
            if(field[1] == pk_name) {
                print field[2];
                exit;
            }
        }
    }')

 primaryKeyPosition=$(echo "$tableExit" | awk -F"|" '{
        fields=$2;
        split($3,pk,":");
        pk_name=pk[2];
        split(fields,field_array,",");primaryKeyPosition
        for (i in field_array) {
            split(field_array[i],field,":");
            if (field[1] == pk_name) {
                print i; # Output the position (1-based index)
                exit;
            }
        }
    }')

        read -p "Please enter the primary key with value {$primaryKeyField} and data type {$primaryKeyDataType}: " valueRow
        foundRow=$(awk -F ":" -v key=$valueRow -v pkPos=$primaryKeyPosition '{
        split($0,fields,":");
        if (fields[pkPos] == key) {
            print $0;
        }
    }' $dataFile)

        if [ -n "$foundRow" ]; then

        foundNR=$(awk -F ":" -v key="$valueRow" -v key=$valueRow -v pkPos=$primaryKeyPosition '{
        split($0,fields,":");
        if (fields[pkPos] == key) {
            print NR;
        }
    }' $dataFile)





        foundNF=$(awk -F ":" -v key="$valueRow" -v key=$valueRow -v pkPos=$primaryKeyPosition '{
        split($0,fields,":");
        if (fields[pkPos] == key) {
            print NF;
        }
    }' $dataFile)

    IFS='|' read -a metaDataFields <<< "$tableExit"

    attributes="${metaDataFields[1]}"

    IFS=',' read -a attributeType <<< "$attributes"
    
    chosenAttributes=()
    newValues=()
            while true; do
                echo "Select an attribute to update:"
                
                select attr in "${attributeType[@]}" "Done"; do
                    if [ "$attr" == "Done" ]; then
                        break 2 
                    elif [[ -n "$attr" ]]; then
                        
                        attributeName=$(echo "$attr" | cut -d ":" -f 1)
                        attributeDataType=$(echo "$attr" | cut -d ":" -f 2)        
                        
                        read -p "Enter the new value for $attributeName: " newValue


                            case "$attributeDataType" in 
                            int)
                                if ! [[ $newValue =~ ^[0-9]+$ ]]; then
                                    echo "invalid input. please enter an integer value."
                                    continue
                                fi
                                ;;
                            string)
                                if ! [[ $newValue =~ ^[a-zA-Z]+$ ]]; then
                                    echo "invalid input. please enter a string (letters only)."
                                    continue
                                fi
                                ;;
                            float)
                                if ! [[ $newValue =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                                    echo "invalid input. please enter a float value."
                                    continue
                                fi
                                ;;
                            *)
                                echo "Unsupported data type: $primaryKeyDataType"
                                continue
                                ;;
                        esac



                        
                        
                        chosenAttributes+=("$attributeName")
                        newValues+=("$newValue")
                        
                        echo "You chose to update $attributeName with the value $newValue."
                        break
                    else
                        echo "Invalid selection. Please try again."
                    fi
                done
            done

            columnsString=$(IFS=,; echo "${chosenAttributes[*]}")
            valuesString=$(IFS=,; echo "${newValues[*]}")


               IFS=":" read -a rowFields <<< "$foundRow"

            for ((i = 0; i < ${#chosenAttributes[@]}; i++)); do
                attributeName="${chosenAttributes[i]}"
                newValue="${newValues[i]}"

                
                for ((j = 1; j <= $foundNF; j++)); do
                    metadataField=$(echo "${attributeType[j-1]}" | cut -d ":" -f 1)
                    if [ "$metadataField" == "$attributeName" ]; then
                        rowFields[$j-1]="$newValue"
                        break
                    fi
                done
            done


                        updatedRow=$(IFS=":"; echo "${rowFields[*]}")
                       awk -v line="$foundNR" -v newRow="$updatedRow" 'NR == line { $0 = newRow } { print $0 }' "$dataFile" > "$dataFile.tmp" && mv "$dataFile.tmp" "$dataFile"

            echo "The row has been updated successfully!"
        else
            echo "Row with primary key $valueRow not found."
        fi
    fi

    echo "Do you want to continue?"
    read -p "Press y or n: " answer
    if [ "$answer" != "y" ]; then
        flag=false
        clear
    fi
done