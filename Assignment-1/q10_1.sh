#!/bin/bash

# Target recycle directory in user's home folder
TRASH_DIR="$HOME/my-deleted-files"
mkdir -p "$TRASH_DIR"

# -------------------------------------------------------------
# Feature (b): Clear directory switch (-cl)
# -------------------------------------------------------------
if [ "$1" = "-cl" ]; then
    read -p "Are you sure you want to permanently clear the trash? (y/n): " confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        rm -rf "$TRASH_DIR"/*
        echo "Trash directory cleared."
    else
        echo "Operation cancelled."
    fi
    exit 0
fi

# Check if at least one file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 [-cl] [file1 file2 ...]"
    exit 1
fi

# -------------------------------------------------------------
# Feature (a): Safe delete / Move with versioning
# -------------------------------------------------------------
for file in "$@"; do
    if [ ! -e "$file" ]; then
        echo "Error: '$file' does not exist."
        continue
    fi

    # Extract base filename (e.g., path/to/doc.txt -> doc.txt)
    base_name=$(basename "$file")
    dest="$TRASH_DIR/$base_name"

    # Case 1: File does not exist yet in trash directory
    if [ ! -e "$dest" ] && [ ! -e "${dest}.0" ]; then
        mv "$file" "$dest"
        echo "Moved '$file' -> '$dest'"

    # Case 2: First collision -> Rename existing to .0 and new to .1
    elif [ -e "$dest" ]; then
        mv "$dest" "${dest}.0"
        mv "$file" "${dest}.1"
        echo "Moved '$file' -> '${dest}.1' (existing archived as '${dest}.0')"

    # Case 3: Subsequent collisions -> Find next available version number (.2, .3, ...)
    else
        v=0
        while [ -e "${dest}.${v}" ]; do
            ((v++))
        done
        mv "$file" "${dest}.${v}"
        echo "Moved '$file' -> '${dest}.${v}'"
    fi
done