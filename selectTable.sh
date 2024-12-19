#!/bin/bash

read -p "Enter table name: " tableName

tableFile="databases/$1/$tableName.txt"
metaFile="databases/$1/metadata"

if [ ! -f "$tableFile" ]; then
    echo "Table does not exist"
    return
fi

metadata=$(grep "^$tableName|" "$metaFile")

cols=$(echo "$metadata" | cut -d "|" -f2)
IFS=',' read -a columnArray <<< "$cols"

echo "available columns: "
for column in "${columnArray[@]}"; do
    colName=$(echo "$column" | cut -d ":" -f1)
    echo "- $colName"
done

while true; do
    read -p "Enter columns to show comma-separated or * for all: " selectedColumns
    
    if [ "$selectedColumns" = "*" ]; then
        break
    fi
    
    IFS=',' read -a colsToShow <<< "$selectedColumns"
    invalidColumns=()
    
    for column in "${colsToShow[@]}"; do
        isValid=false
        for tableColumn in "${columnArray[@]}"; do
            tableColName=$(echo "$tableColumn" | cut -d ":" -f1)
            if [ "$column" = "$tableColName" ]; then
                isValid=true
                break
            fi
        done
        if [ "$isValid" = false ]; then
            invalidColumns+=("$column")
        fi
    done
    
    if [ ${#invalidColumns[@]} -eq 0 ]; then
        break
    else
        echo "Error: the following columns do not exist in the table: "
        for invalidCol in "${invalidColumns[@]}"; do
            echo "-$invalidCol"
        done
        echo "Please try again with valid column names."
    fi
done

read -p "Do you want to apply a condition? (y/n): " useCondition

if [ "$useCondition" = "y" ]; then
    while true; do
        
        echo "Available operators: =, <=, >=, <, >"
        read -p "Enter column name for condition: " conditionColumn
        
        isValid=false
        for column in "${columnArray[@]}"; do
            colName=$(echo "$column" | cut -d ":" -f1)
            if [ "$conditionColumn" = "$colName" ]; then
                isValid=true
                break
            fi
        done
        
        if [ "$isValid" = true ]; then
            break
        else
            echo "Error: Column '$conditionColumn' does not exist in the table."
            echo "Please enter a valid column name."
        fi
    done
    
    read -p "Enter operator: " operator
    read -p "Enter value: " conditionValue
fi

if [ "$selectedColumns" = "*" ]; then
    header=""
    for column in "${columnArray[@]}"; do
        colName=$(echo "$column" | cut -d ":" -f1)
        if [ -z "$header" ]; then
            header="$colName"
        else
            header="$header:$colName"
        fi
    done
    echo -e "\nResults:"
    echo "$header"
else
    IFS=',' read -a colsToShow <<< "$selectedColumns"
    header=""
    for column in "${colsToShow[@]}"; do
        if [ -z "$header" ]; then
            header="$column"
        else
            header="$header:$column"
        fi
    done
    echo -e "\nResults:"
    echo "$header"
fi

while IFS= read line; do
    IFS=':' read -a record <<< "$line"
    
    if [ "$useCondition" = "y" ]; then
        conditionColIndex=0
        for i in "${!columnArray[@]}"; do
            colName=$(echo "${columnArray[$i]}" | cut -d ":" -f1)
            if [ "$colName" = "$conditionColumn" ]; then
                conditionColIndex=$i
                break
            fi
        done
        
        case $operator in
            "=")  [ "${record[$conditionColIndex]}" = "$conditionValue" ] || continue ;;
            "<=") [ "${record[$conditionColIndex]}" -le "$conditionValue" ] || continue ;;
            ">=") [ "${record[$conditionColIndex]}" -ge "$conditionValue" ] || continue ;;
            "<")  [ "${record[$conditionColIndex]}" -lt "$conditionValue" ] || continue ;;
            ">")  [ "${record[$conditionColIndex]}" -gt "$conditionValue" ] || continue ;;
        esac
    fi

    if [ "$selectedColumns" = "*" ]; then
        echo "$line"
    else
        IFS=',' read -a colsToShow <<< "$selectedColumns"
        result=""
        for column in "${colsToShow[@]}"; do
            colIndex=0
            for i in "${!columnArray[@]}"; do
                colName=$(echo "${columnArray[$i]}" | cut -d ":" -f1)
                if [ "$colName" = "$column" ]; then
                    colIndex=$i
                    break
                fi
            done

            if [ -z "$result" ]; then
                result="${record[$colIndex]}"
            else
                result="$result:${record[$colIndex]}"
            fi
        done
        echo "$result"
    fi
done < "$tableFile"