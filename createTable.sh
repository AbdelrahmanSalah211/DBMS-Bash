#! /bin/bash
read -p "enter the name of the table you want to create : " tableName

while ! [[ $tableName =~ ^([a-zA-Z])[a-zA-Z0-9\w_-]*([a-zA-Z0-9])$ ]]
do
    echo ""---${tableName}---" is not valid name "
    echo "The table name must:"
    echo "- Start with a letter (a-z or A-Z)."
    echo "- Contain only letters, numbers, hyphens, and underscores."
    echo "- End with a letter or number."
    read -p "Please enter a valid name: " tableName
    
done

if [ ! -f "databases/$1/$tableName.txt" ]
then
    touch "./databases/$1/$tableName.txt"
    
    read -p "enter number of columns in $tableName table: " colNum
    
    counter=0
    
    metadataFile="databases/$1/metadata"
    
    metadata="$tableName|"

    declare -A attributes

    validTypes=("int" "float" "string")

    for (( i=1; i<=colNum; i++ ));
    do
        while true;do
            read -p "enter name of attribute $i: " attrName
            read -p "enter type of $attrName. valid ones are ${validTypes[*]}: " attrType

            if [[ -n "${attributes[$attrName]}" ]];then
                echo "attribute name \"$attrName\" already exist please choose anthor name"
            elif [[ ! " ${validTypes[*]} " =~ " ${attrType} " ]];then
                echo "invalid attribute \"$attrType\". valid ones are ${validTypes[*]}"
            else
            attributes[$attrName]=$attrType
            metadata+="$attrName:$attrType,"
            break
            fi
            done
    done
    
    metadata=${metadata%,}
    
    echo "$metadata" >> "$metadataFile"
    echo "$tableName table is created"

else
    echo "Table $tableName already exists."
fi


