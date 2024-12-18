flag=true
while $flag; do
    read -p "enter the name of the table you want to drop : " tableName

while ! [[ $tableName =~ ^([a-zA-Z])[a-zA-Z0-9\w_-]*([a-zA-Z0-9])$ ]]
do
    echo ""---${tableName}---" is not valid name "
    echo "The table name must:"
    echo "- Start with a letter (a-z or A-Z)."
    echo "- Contain only letters, numbers, hyphens, and underscores."
    echo "- End with a letter or number."
    read -p "Please enter a valid name: " tableName
    
done


echo $1 asdasd
tableFile="./databases/$1/$tableName.txt"
metaDataFile="./databases/$1/metadata"
echo $tableFile
echo $metaDataFile



if [ ! -f "${metaDataFile}"  ]; then
    echo "no tables to be deleted "
    echo ""
    source connectDB.sh $1
fi


tableExit=$(grep "${tableName}|" "${metaDataFile}") 

if [ -n "${tableExit}" ];then
    echo are sure that you want to drop the table
    read -p "press y or n : " answer
    if [ $answer == "y" ]; then
    rm ${tableFile} && sed -i "/${tableExit}/d" "${metaDataFile}"
    fi
fi
    echo "do you want to continue ?" 
    read -p "press y or n : " answer
    if [ $answer != "y" ]; then
        flag=false
        clear
    #   source connectDB.sh $1

    fi

done