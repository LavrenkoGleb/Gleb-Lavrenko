#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <input_directory> <output_directory>"
    exit 1
elif [[ ! -d "$1" ]]; then
    echo "Sorry, input_directory does not exist."
    exit 2
fi

find "$1" -type f -exec sh -c '
    input_directory="$1"    
    output_directory="$2"
    for file in "$input_directory"; do
        filename=$(basename "$file")
        basename=$(echo $filename | cut -d. -f1)
        extension=$(echo $filename | cut -c $((${#basename} + 1))-${#filename})
        ind=""
        count=0
        while [ -e "$output_directory/$basename$ind$extension" ]; do
            count=$((count + 1))
            ind="$count"
            done
        if [[ "$extension" == "" ]]; then
            cp "$file" "$output_directory/$basename$ind"
        elif [[ "$extension" != "" ]]; then
            cp "$file" "$output_directory/$basename$ind$extension"
        fi
     done
    ' sh {} "$2" \;
echo "Copying completed."