#!/bin/bash

# check if 4 arguments are provided
if [ "$#" -ne 4 ]; then
    echo "Error :Exactly 4 Java file names are required as arguments."
    exit 1
fi

printf -- "---------------------------------------------------------------\n"
printf "| %-20s | %-10s | %-10s | %-10s |\n" "Filename" "public" "class" "int"
printf -- "---------------------------------------------------------------\n"


for file in "$@";do
    if [ ! -f "$file" ]; then
        printf "| %-20s | %-10s | %-10s | %-10s |\n" "$(basename "$file")" "N/A" "N/A" "N/A"
        continue
    fi

    fname=$(basename "$file")

    # count occurences 
    c_public=$(grep -o -w "public" "$file" | wc -l)
    c_class=$(grep -o -w "class" "$file" | wc -l)
    c_int=$(grep -o -w "int" "$file" | wc -l)

    printf "| %-20s | %-10s | %-10s | %-10s |\n" "$fname" "$c_public" "$c_class" "$c_int"
done

printf -- "---------------------------------------------------------------\n"
