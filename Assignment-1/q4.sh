#!/bin/bash

# Default to current directory if no argument is provided
TARGET_DIR="${1:-.}"


if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist or is not a valid directory."
    exit 1
fi

echo "=========================================="
echo " Directory Analysis for: $TARGET_DIR"
echo "=========================================="

TOTAL_FILES=$(find "$TARGET_DIR" -type f | wc -l)
echo -e "\n---> Total number of files (including subdirectories): $TOTAL_FILES"


echo -e "\n---> File count in each directory/subdirectory:"
printf "%-50s %s\n" "DIRECTORY PATH" "FILE COUNT"
printf "%-50s %s\n" "--------------------------------------------------" "----------"

# Iterate over target directory and all nested directories
find "$TARGET_DIR" -type d | while read -r dir; do
    # Count only regular files strictly inside the current directory level
    COUNT=$(find "$dir" -maxdepth 1 -type f | wc -l)
    printf "%-50s %s\n" "$dir" "$COUNT"
done


echo -e "\n---> Files created/modified within the past week:"
printf "%-50s %s\n" "FILE NAME" "PATH"
printf "%-50s %s\n" "--------------------------------------------------" "--------------------------------------------------"

RECENT_FILES=$(find "$TARGET_DIR" -type f -mtime -7)

if [ -z "$RECENT_FILES" ]; then
    echo "No files found created or modified in the last 7 days."
else
    echo "$RECENT_FILES" | while read -r file; do
        FILE_NAME=$(basename "$file")
        printf "%-50s %s\n" "$FILE_NAME" "$file"
    done
fi

echo "=========================================="