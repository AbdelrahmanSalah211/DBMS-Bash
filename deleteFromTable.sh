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


if [ ! -f $metaDataFile  ]; then
    echo "No tables existing"
    echo ""
      source connectDB.sh $1
    
fi

tableExit=$(grep "^${tableName}|" "${metaDataFile}" )
    if [ -n "${tableExit}" ];then
    
    primaryKeyField=$(grep "^${tableName}|" "$metaDataFile" | cut -d "|" -f 2 | cut -d "," -f 1 | cut -d ":" -f 1)
    primaryKeyDataType=$(grep "^${tableName}|" "${metaDataFile}" | cut -d "|" -f 2 | cut -d "," -f 1 | cut -d ":" -f 2 )

    echo "${primaryKeyDataType}"

    read -p "please enter the primary key with value {$primaryKeyField} amd  data type {$primaryKeyDataType}:" valueRow
       case "$primaryKeyDataType" in
            int)
                if ! [[ $valueRow =~ ^[0-9]$ ]]; then
                    echo "invalid input. please enter an integer value."
                    continue
                fi
                ;;
            string)
                if ! [[ $valueRow =~ ^[a-zA-Z]$ ]]; then
                    echo "invalid input. please enter a string (letters only)."
                    continue
                fi
                ;;
            *)
                echo "Unsupported data type: $primaryKeyDataType"
                continue
                ;;
        esac
    valueData=$(awk -F ":" -v key=$valueRow ' $1 == key  { print $0 } ' $dataFile)

    if [ -n "$valueData" ]; then
        echo "is this the data you want to delete ?  ${valueData}" 
        read -p "press y or n : " answer
        if [ "$answer" == "y" ]; then
            sed -i "/${valueData}/d" "$dataFile"
            echo "the data is deleted"
        else 
            echo "deletion canceled."
        fi
    else
        echo "no matching data found for key: $valueRow"
    fi
else
    echo "no table called ${tableName}"
fi
    echo "do you want to continue ?" 
    read -p "press y or n : " answer
    if [ $answer != "y" ]; then
        flag=false
        clear
      source connectDB.sh $1

    fi
done






