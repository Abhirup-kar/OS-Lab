#!/bin/bash

TARGET_DIR="${1:-.}"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist or is not a directory."
    exit 1
fi

echo "=================================================="
echo " Analyzing Directory: $TARGET_DIR"
echo "=================================================="

# Temporary files to store filtered listings safely
FILES_LIST=$(mktemp)
DIRS_LIST=$(mktemp)

# Clean up temporary files on script exit
trap 'rm -f "$FILES_LIST" "$DIRS_LIST"' EXIT

# Find non-hidden items in the top level of the directory
find "$TARGET_DIR" -maxdepth 1 -minlen 1 ! -path "$TARGET_DIR" -type f > "$FILES_LIST"
find "$TARGET_DIR" -maxdepth 1 -minlen 1 ! -path "$TARGET_DIR" -type d > "$DIRS_LIST"

# Count files and directories
FILE_COUNT=$(wc -l < "$FILES_LIST")
DIR_COUNT=$(wc -l < "$DIRS_LIST")
TOTAL_COUNT=$((FILE_COUNT + DIR_COUNT))


echo -e "\n--- Summary ---"
echo "Total Files and Directories : $TOTAL_COUNT"
echo "Total Directories           : $DIR_COUNT"
echo "Total Files                 : $FILE_COUNT"

echo -e "\n--- Directories ($DIR_COUNT) ---"
if [ "$DIR_COUNT" -gt 0 ]; then
    sed 's|.*/||' "$DIRS_LIST" | sed 's/^/  - /'
else
    echo "  (No directories found)"
fi

echo -e "\n--- Files ($FILE_COUNT) ---"
if [ "$FILE_COUNT" -gt 0 ]; then
    sed 's|.*/||' "$FILES_LIST" | sed 's/^/  - /'
else
    echo "  (No files found)"
fi


echo -e "\n--- Files Created/Modified in the Past 7 Days ---"


PAST_WEEK_SIZE_BYTES=$(find "$TARGET_DIR" -maxdepth 1 -type f -mtime -7 -exec du -b {} + 2>/dev/null | awk '{sum += $1} END {print sum+0}')


HUMAN_SIZE=$(numfmt --to=iec-i --suffix=B "$PAST_WEEK_SIZE_BYTES" 2>/dev/null || echo "${PAST_WEEK_SIZE_BYTES} Bytes")

echo "Total size of files created/modified in the last 7 days: $HUMAN_SIZE ($PAST_WEEK_SIZE_BYTES bytes)"
echo "---------------------------------------------"