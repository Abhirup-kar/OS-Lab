#!/bin/bash

# 1. Ask for file name and validate
read -p "Enter file name: " filename

if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' does not exist."
    exit 1
fi

# 2. Ask for the search string
read -p "Enter string to search: " search_str

total_count=0
line_number=0

echo ""
echo "--- Search Results ---"

# 3. Read the file line by line
while IFS= read -r line; do
    ((line_number++))
    
    # Count occurrences of the string in the current line (supports partial matches)
    line_freq=$(echo "$line" | grep -o "$search_str" | wc -l)
    
    if [ "$line_freq" -gt 0 ]; then
        echo "Line $line_number: occurred $line_freq time(s)"
        ((total_count += line_freq))
    fi
done < "$filename"

# 4. Display total count or not found message
echo "----------------------"
if [ "$total_count" -gt 0 ]; then
    echo "Total occurrences found: $total_count"
else
    echo "The string '$search_str' was not found in '$filename'."
fi