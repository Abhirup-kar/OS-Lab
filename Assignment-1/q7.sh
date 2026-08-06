#!/bin/bash

# Prompt for the file name
read -p "Enter the file name: " filename

# Check if the file exists and is a regular file
if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' does not exist or is not a regular file."
    exit 1
fi

# Prompt for the target word (from Q6)
read -p "Enter the word to search: " target_word

if [ -z "$target_word" ]; then
    echo "Error: Search word cannot be empty."
    exit 1
fi

# Prompt for the replacement word
read -p "Enter the replacement word: " replace_word

output_file="updated_$filename"

# Run awk to process replacement, partial match tracking, and case-insensitivity
awk -v target="$target_word" -v replacement="$replace_word" '
BEGIN {
    total_exact_matches = 0;
    total_partial_matches = 0;
    # Lowercase version of target for case-insensitive processing
    target_lower = tolower(target);
}
{
    line = $0;
    line_lower = tolower($0);
    updated_line = "";
    line_exact_count = 0;
    line_partial_count = 0;
    
    pos = 1;
    len = length(line);
    tlen = length(target);

    # Iterate through the line to inspect word boundaries case-insensitively
    while (pos <= len) {
        # Check if target matches starting at position pos (case-insensitive)
        if (substr(line_lower, pos, tlen) == target_lower) {
            # Inspect characters surrounding the potential match
            char_before = (pos > 1) ? substr(line, pos - 1, 1) : "";
            char_after  = (pos + tlen <= len) ? substr(line, pos + tlen, 1) : "";

            # Check if surrounding characters are word characters (letters, digits, underscore)
            is_prev_wordchar = (char_before ~ /[a-zA-Z0-9_]/);
            is_next_wordchar = (char_after  ~ /[a-zA-Z0-9_]/);

            # Exact match condition: surrounded by non-word characters (or boundaries)
            if (!is_prev_wordchar && !is_next_wordchar) {
                updated_line = updated_line replacement;
                line_exact_count++;
                total_exact_matches++;
                pos += tlen;
            } else {
                # Partial match condition: string matches, but it is part of a larger word
                updated_line = updated_line substr(line, pos, tlen);
                line_partial_count++;
                total_partial_matches++;
                pos += tlen;
            }
        } else {
            updated_line = updated_line substr(line, pos, 1);
            pos++;
        }
    }

    # Print summary per line if matches were detected
    if (line_exact_count > 0 || line_partial_count > 0) {
        print "Line " NR ": " line_exact_count " exact match(es) replaced, " line_partial_count " partial match(es) detected (skipped).";
    }

    # Output modified line to temporary result file
    print updated_line > "temp_output.tmp";
}
END {
    print "----------------------------------------";
    if (total_exact_matches > 0 || total_partial_matches > 0) {
        print "Total exact matches replaced: " total_exact_matches;
        print "Total partial matches found (not replaced): " total_partial_matches;
    } else {
        print "No exact or partial matches were found for \"" target "\".";
    }
}' "$filename"

# Save modified content to output file
if [ -f "temp_output.tmp" ]; then
    mv temp_output.tmp "$output_file"
    echo "Updated file saved as: $output_file"
fi