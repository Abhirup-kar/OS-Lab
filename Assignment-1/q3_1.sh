#!/bin/bash

# Ask user for target directory (defaults to current directory if left blank)
read -p "Enter directory path (leave blank for current): " target_dir
target_dir="${target_dir:-.}"

# Check if directory exists
if [ ! -d "$target_dir" ]; then
    echo "Error: Directory '$target_dir' does not exist."
    exit 1
fi

echo "=========================================="
echo "Analyzing: $target_dir"
echo "=========================================="

# 1. Directories
echo -e "\n--- DIRECTORIES ---"
dirs=$(find "$target_dir" -mindepth 1 -maxdepth 1 -type d)
if [ -n "$dirs" ]; then
    echo "$dirs"
    dir_count=$(echo "$dirs" | wc -l)
else
    dir_count=0
fi
echo "Total Directories: $dir_count"

# 2. Files
echo -e "\n--- FILES ---"
files=$(find "$target_dir" -mindepth 1 -maxdepth 1 -type f)
if [ -n "$files" ]; then
    echo "$files"
    file_count=$(echo "$files" | wc -l)
else
    file_count=0
fi
echo "Total Files: $file_count"

# 3. Overall Count
total_items=$(( dir_count + file_count ))
echo -e "\n=========================================="//
echo "Total Items (Files + Directories): $total_items"
echo "=========================================="

# 4. Total size of files modified/created in the past 7 days
echo -e "\n--- RECENT FILES (Past 7 Days) ---"
recent_size=$(find "$target_dir" -maxdepth 1 -type f -mtime -7 -exec du -ch {} + 2>/dev/null | grep total$ | awk '{print $1}')

if [ -n "$recent_size" ]; then
    echo "Total size of files created/modified in the past week: $recent_size"
else
    echo "Total size of files created/modified in the past week: 0B (No recent files found)"
fi
