#! /bin/bash

database="./databases"
if [ ! -d "$database"  ] || [ -z "$(ls -A "$database")" ];then
    echo "No databases created yet"
else 
    echo "The existing databases are: "
    ls "$database"
    echo " " 
fi