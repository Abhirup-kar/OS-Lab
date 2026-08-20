#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 DD/MM/YYYY DD/MM/YYYY"
    exit 1
fi

# Function to reformat DD/MM/YYYY to YYYY-MM-DD for the 'date' command
format_date() {
    IFS="/" read -r day month year <<< "$1"
    echo "$year-$month-$day"
}

# Convert input dates to YYYY-MM-DD
d1=$(format_date "$1")
d2=$(format_date "$2")


day1=$(date -d "$d1" +%A 2>/dev/null)
day2=$(date -d "$d2" +%A 2>/dev/null)

if [ -z "$day1" ] || [ -z "$day2" ]; then
    echo "Error: Invalid date format or date value provided. Use DD/MM/YYYY."
    exit 1
fi

echo "Person 1 was born on a: $day1"
echo "Person 2 was born on a: $day2"
echo "----------------------------------------"

if [ "$day1" = "$day2" ]; then
    echo "Match! Both people were born on a $day1."
else
    echo "No match. They were born on different days of the week."
fi