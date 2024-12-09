#! /bin/bash

database="./databases"
if [ ! -d "$database"  ] || [ -z "$(ls -A "$database")" ];then
echo "No databases created yet"
    source main_menu.sh

else 
    echo "The existing databases are: "
    ls "$database"
    echo " " 
    source main_menu.sh
fi