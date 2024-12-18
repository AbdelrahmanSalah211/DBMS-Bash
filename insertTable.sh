#!/bin/bash

read -p "Enter the name of table you want to insert into: " tableName

tableFile="databases/$1/${tableName}.txt"
metadataFile="databases/$1/metadata"

if [ ! -f "$tableFile" ]; then
    echo "Error: Table \"$tableName\" does not exist."
    return
fi

meta=$(grep "^$tableName|" "$metadataFile")

attributesMeta=$(echo "$meta" | cut -d '|' -f2)

primaryKey=$(echo "$meta" | cut -d '|' -f3 | cut -d ':' -f2)

IFS=',' read  -a attributeType <<< "$attributesMeta"

pkInd=-1
for i in "${!attributeType[@]}"; do
    attrName=$(echo "${attributeType[$i]}" | cut -d ':' -f1)
    if [[ "$attrName" == "$primaryKey" ]]; then
        pkInd=$((i+1))
        break
    fi
done

if [[ $pkInd -eq -1 ]]; then
    echo "Error: Primary key \"$primaryKey\" not found in attributes."
    return
fi

declare -A userValues
for attr in "${attributeType[@]}"; do
    attrName=$(echo "$attr" | cut -d ':' -f1)
    attrType=$(echo "$attr" | cut -d ':' -f2)

    while true; do
        read -p "Enter value for \"$attrName\" (type: $attrType): " userInput

        case "$attrType" in
            int)
                if ! [[ "$userInput" =~ ^[0-9]+$ ]]; then
                    echo "Invalid input. \"$attrName\" must be an integer."
                    continue
                fi
                ;;
            float)
                if ! [[ "$userInput" =~ ^[0-9]+\.[0-9]+$ ]]; then
                    echo "Invalid input. \"$attrName\" must be a float."
                    continue
                fi
                ;;
            string)
                if [[ -z "$userInput" ]]; then
                    echo "Invalid input. \"$attrName\" cannot be empty."
                    continue
                fi
                ;;
            *)
                echo "Error: Unsupported type \"$attrType\"."
                return
                ;;
        esac
        userValues["$attrName"]="$userInput"
        break
    done
done

pkValue=${userValues[$primaryKey]}

if cut -d',' -f"$pkInd" "$tableFile" | grep -qx "$pkValue"; then
    echo "Error: Duplicate primary key \"$pkValue\" found in column \"$primaryKey\"."
    return
fi

appendData=""
for attr in "${attributeType[@]}"; do
    attrName=$(echo "$attr" | cut -d ':' -f1)
    appendData+="${userValues[$attrName]}:"
done

appendData=${appendData%:}

echo "$appendData" >> "$tableFile"
echo "Data successfully inserted into table \"$tableName\"."
