#!/bin/bash

# Script to extract all files from current directory and subdirectories
# into a single folder on the desktop

# Set the destination directory
DEST_DIR="$HOME/Desktop/extracted_files"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

echo "Extracting all files to: $DEST_DIR"
echo "Starting extraction..."

# Counter for processed files
count=0

# Find all files (not directories) and copy them
find . -type f | while read -r file; do
    # Get just the filename without the path
    filename=$(basename "$file")
    
    # If a file with the same name already exists, add a number
    if [ -f "$DEST_DIR/$filename" ]; then
        # Extract filename and extension
        name="${filename%.*}"
        ext="${filename##*.}"
        
        # If there's no extension, handle it differently
        if [ "$name" = "$ext" ]; then
            ext=""
            counter=1
            while [ -f "$DEST_DIR/${name}_${counter}" ]; do
                ((counter++))
            done
            new_filename="${name}_${counter}"
        else
            counter=1
            while [ -f "$DEST_DIR/${name}_${counter}.${ext}" ]; do
                ((counter++))
            done
            new_filename="${name}_${counter}.${ext}"
        fi
    else
        new_filename="$filename"
    fi
    
    # Copy the file
    cp "$file" "$DEST_DIR/$new_filename"
    
    if [ $? -eq 0 ]; then
        echo "Copied: $file -> $new_filename"
        ((count++))
    else
        echo "Error copying: $file"
    fi
done

echo ""
echo "Extraction complete!"
echo "Total files copied: $count"
echo "Files are located in: $DEST_DIR"