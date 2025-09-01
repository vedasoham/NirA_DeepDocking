#!/bin/bash

# Get the current directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Change directory to the folder containing the scripts
cd "$SCRIPT_DIR"

# Find all scripts matching the pattern
script_list=$(ls -v *_[0-9]*.sh)

# Iterate through each script in sorted order
for script in $script_list; do
    # Execute the script
    bash "$script"
    
    # Check the exit status of the script
    if [ $? -eq 0 ]; then
        echo "$script completed successfully."
    else
        echo "Error: $script failed."
        exit 1
    fi
done

echo "All scripts completed successfully."
