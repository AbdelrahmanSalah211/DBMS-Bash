#! /bin/bash

database="./databases"
if [ ! -d "$database"  ];then
echo "No databases created yet"
    source main_menu.sh

else 
    echo " the databases are  exiting : "
   ls "$database"
    echo " " 
    source main_menu.sh
fi