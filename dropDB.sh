#!/bin/bash

read -p "enter the name of database you want to drop: " dropDB

if [ -d "databases/$dropDB" ]
then
rm -r "databases/$dropDB"
echo "Database \"$dropDB\" has been dropped."
else
echo "Database \"$dropDB\" does not exsit."
fi

echo " "
source main_menu.sh
