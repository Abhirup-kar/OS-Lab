#!/bin/bash

# 1. Ask for file name and validate
read -p "Enter file name: " filename

if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' does not exist."
    exit 1
fi

# 2. Ask for the first search string
read -p "Enter string to search: " search_str

total_count=0
line_number=0

echo -e "\n--- Part 1: Search Results ---"

# Read file line by line for counts and line numbers
while IFS= read -r line; do
    ((line_number++))
    
    # Partial match frequency in current line
    line_freq=$(echo "$line" | grep -o "$search_str" | wc -l)
    
    if [ "$line_freq" -gt 0 ]; then
        echo "Line $line_number: occurred $line_freq time(s)"
        ((total_count += line_freq))
    fi
done < "$filename"

echo "------------------------------"
if [ "$total_count" -gt 0 ]; then
    echo "Total occurrences found: $total_count"
else
    echo "The string '$search_str' was not found in '$filename'."
fi

# -----------------------------------------------------------
# Part 2: Replacement & Match Checks
# -----------------------------------------------------------
echo -e "\n--- Part 2: Replace & Match Diagnostics ---"
read -p "Enter replacement word: " replace_str

# (iii) Check if Partial Matches exist (using grep without word boundaries)
partial_count=$(grep -c "$search_str" "$filename")
if [ "$partial_count" -gt 0 ]; then
    echo "[Info] Partial match(es) exist in the file ($partial_count matching lines)."
else
    echo "[Info] No partial matches found."
fi

# (iv) Check if matches exist when case sensitivity is ignored (-i flag)
case_count=$(grep -i -c "$search_str" "$filename")
if [ "$case_count" -gt 0 ]; then
    echo "[Info] Match exists if case-sensitivity is ignored ($case_count matching lines)."
else
    echo "[Info] No matches even when ignoring case."
fi

# (i) & (ii) Replace exact whole-word matches only (ignoring partial matches)
# '\b' enforces whole-word boundaries so 'cat' will match 'cat' but not 'caterpillar'
output_file="replaced_output.txt"
sed "s/\b${search_str}\b/${replace_str}/g" "$filename" > "$output_file"

echo -e "\nReplacement complete!"
echo "Only exact/whole-word matches were replaced (partial matches preserved)."
echo "Output saved to: $output_file"