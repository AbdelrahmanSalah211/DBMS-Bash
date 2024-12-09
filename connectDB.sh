#!/bin/bash

echo choose from following:

select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select from Table" "Delete from Table" "Update Table" "exit"
do
    case $choice in
        "Create Table")
            echo You chose to create a table.
            #source createTable.sh
            ;;
        "List Tables")
            echo You chose to list tables.
            #source listTables.sh
            ;;
        "Drop Table")
            echo You chose to drop a table.
            #source dropTable.sh
            ;;
        "Insert into Table")
            echo You chose to insert into a table.
            #source insertTable.sh
            ;;
        "Select from Table")
            echo You chose to select from a table.
            #source selectTable.sh
            ;;
        "Delete from Table")
            echo You chose to delete from a table.
            #source deleteTable.sh
            ;;
        "Update Table")
            echo You chose to update table.
            #source updateTable.sh
            ;;
        "exit")
            echo You chose to exit.
            break
            ;;
        *)
            echo "Invalid option. Please choose a number from 1 to 8."
        ;;
        
    esac
done

echo " "
source main_menu.sh
