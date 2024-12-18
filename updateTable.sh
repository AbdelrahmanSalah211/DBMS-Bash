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
        primaryKeyField=$(grep "${tableName}|" "${metaDataFile}" | cut -d "|" -f 2 | cut -d "," -f 1 | cut -d ":" -f 1)
        primaryKeyDataType=$(grep "^${tableName}|" "${metaDataFile}" | cut -d "|" -f 2 | cut -d "," -f 1 | cut -d ":" -f 2)
        read -p "Please enter the primary key with value {$primaryKeyField} and data type {$primaryKeyDataType}: " valueRow
        foundRow=$(awk -F ":" -v key="$valueRow" '$1 == key { print $0 }' "$dataFile")

        if [ -n "$foundRow" ]; then

        foundNR=$(awk -F ":" -v key="$valueRow" '$1 == key { print NR }' "$dataFile")
        foundNF=$(awk -F ":" -v key="$valueRow" '$1 == key { print NF }' "$dataFile")


    IFS=',' read  -a attributeType <<< "$tableExit"

    chosenAttributes=()
    newValues=()
            while true; do
                echo "Select an attribute to update:"
                
                select attr in "${attributeType[@]}" "Done"; do
                    if [ "$attr" == "Done" ]; then
                        break 2 # Exit both the select and the outer loop
                    elif [[ -n "$attr" ]]; then
                        
                        attributeName=$(echo "$attr" | cut -d ":" -f 1)
                        
                        
                        read -p "Enter the new value for $attributeName: " newValue
                        
                        
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