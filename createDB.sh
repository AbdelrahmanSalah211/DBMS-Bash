#! /bin/bash
clear -x
read -p "enter the name of the database you want to create : " databaseName

while ! [[ $databaseName =~ ^([a-zA-Z])[a-zA-Z0-9\w_-]*([a-zA-Z0-9])$ ]]; do
    echo ""---${databaseName}---" is not valid name "
    echo "The database name must:"
    echo "- Start with a letter (a-z or A-Z)."
    echo "- Contain only letters, numbers, hyphens, and underscores."
    echo "- End with a letter or number."
    read -p "Please enter a valid name: " databaseName

done
echo $databaseName

if [ ! -d "$databaseName" ]; then
    mkdir "$databaseName"
    echo "Database \"$databaseName\" created!"
else
    echo "Database \"$databaseName\" already exists."
fi
