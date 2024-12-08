#!/bin/bash

select choice in createDatabase listDBs exit
do
  case $choice in
    createDatabase) 
      source createDB.sh
      break
      ;;
    listDBs) 
      source listDBS.sh
      break
      ;;
    exit) 
      echo "Exiting the program."
      break
      ;;
    *) 
      echo "$REPLY is not one of the choices."
      echo "Try again."
      ;;
  esac
done
