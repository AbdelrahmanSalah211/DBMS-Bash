#!/bin/bash
while true; do
    
select choice in "Create Database" "List Databases" "Connect To Database" "Drop Database" Exit
do
  case $choice in
    "Create Database") 
      source createDB.sh
      break
      ;;
    "List Databases") 
      source listDBS.sh
      break
      ;;
    "Connect To Database")
      source connectDB.sh
      break
      ;;
    "Drop Database")
      source dropDB.sh
      break
      ;;
    Exit) 
      echo "Exiting the program."
      exit 0
      ;;
    *) 
      echo "$REPLY is not one of the choices."
      echo "Try again."
      ;;
  esac
done
done
