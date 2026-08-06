#!/bin/bash

read -p "Enter the file name: " filename

# Check if the file exists and is a regular file
if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' does not exist or is not a regular file."
    exit 1
fi

read -p "Enter the string to search: " search_string


if [ -z "$search_string" ]; then
    echo "Error: Search string cannot be empty."
    exit 1
fi

awk -v str="$search_string" '
BEGIN {
    total_matches = 0;
}
{
    line = $0;
    line_count = 0;
    
    # Count occurrences of `str` within the line (handles partial matches and multiple per line)
    while ((idx = index(line, str)) > 0) {
        line_count++;
        line = substr(line, idx + length(str));
    }
    
    # If match found in current line, print line number and frequency
    if (line_count > 0) {
        print "Line " NR ": " line_count " occurrence(s)";
        total_matches += line_count;
    }
}
END {
    print "----------------------------------------";
    if (total_matches > 0) {
        print "Total occurrences of \"" str "\": " total_matches;
    } else {
        print "The string \"" str "\" was not found in the file.";
    }
}' "$filename"