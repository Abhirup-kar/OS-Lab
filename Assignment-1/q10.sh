#!/bin/bash

# Target recycle bin directory
TRASH_DIR="$HOME/my-deleted-files"

# Ensure the trash directory exists
mkdir -p "$TRASH_DIR"

# Feature B: Handle the -cl switch to clear the directory
if [ "$1" == "-cl" ]; then
    read -p "Are you sure you want to permanently delete all files in $TRASH_DIR? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf "$TRASH_DIR"/*
        echo "The directory '$TRASH_DIR' has been cleared."
    else
        echo "Operation cancelled."
    fi
    exit 0
fi

# Check if arguments are provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 [-cl] <file1> [file2 ...]"
    exit 1
fi

# Feature A: Process each provided file
for file in "$@"; do
    if [ ! -e "$file" ]; then
        echo "Error: '$file' does not exist."
        continue
    fi

    base_name=$(basename "$file")
    target_path="$TRASH_DIR/$base_name"

    # Check if the file already exists in my-deleted-files
    if [ ! -e "$target_path" ]; then
        # File does not exist in trash, move it directly
        mv "$file" "$target_path"
    else
        # File already exists -> Handle versioning
        
        # 1. If base file exists without version suffix, rename it to .0
        if [ ! -e "${target_path}.0" ]; then
            mv "$target_path" "${target_path}.0"
        fi

        # 2. Find the highest existing version number
        highest_ver=0
        for existing in "${target_path}."*; do
            if [[ "$existing" =~ \.([0-9]+)$ ]]; then
                ver="${BASH_REMATCH[1]}"
                if [ "$ver" -gt "$highest_ver" ]; then
                    highest_ver=$ver
                fi
            fi
        done

        # 3. Next file gets version (highest + 1)
        next_ver=$((highest_ver + 1))
        mv "$file" "${target_path}.${next_ver}"
    fi

    echo "Moved '$file' to '$TRASH_DIR'"
done