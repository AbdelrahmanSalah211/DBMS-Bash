#!/bin/bash
<<<<<<< HEAD

select choice in createDatabase listDBs exit
=======
while true; do
    
select choice in "Create Database" "List Databases" "Connect To Database" "Drop Database" Exit
>>>>>>> origin/master
do
  case $choice in
    createDatabase) 
      source createDB.sh
      break
      ;;
<<<<<<< HEAD
    listDBs) 
      source listDBS.sh
      break
      ;;
    exit) 
=======
    "List Databases") 
      clear
      source listDBS.sh
      break
      ;;
    "Connect To Database")
      clear
      source connectDB.sh
      break
      ;;
    "Drop Database")
      source dropDB.sh
      break
      ;;
    Exit) 
>>>>>>> origin/master
      echo "Exiting the program."
      exit 0
      ;;
    *) 
      echo "$REPLY is not one of the choices."
      echo "Try again."
      ;;
  esac
<<<<<<< HEAD
done
=======
done
done
>>>>>>> origin/master
