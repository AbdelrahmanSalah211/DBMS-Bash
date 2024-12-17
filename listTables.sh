#!/bin/bash

if compgen -G "databases/$1/*.txt" > /dev/null; then
    echo "Tables in database $1:"
    for file in  databases/$1/*.txt ; do
        echo "$(basename "$file" ".txt")"
        
        # ls -I "metadata.txt" "$database"
    done    
else
    echo "No tables found for database $1"
fi

