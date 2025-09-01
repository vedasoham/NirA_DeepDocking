#!/bin/bash

# Default values for command-line arguments
input_directory="/home/jrf-2/jrf/dd/new_run/defined_run/make_set/final_o_final/actives/actives_smi"
batch_size=100
output_directory="/home/jrf-2/jrf/dd/new_run/defined_run/make_set/final_o_final/actives/actives_sdf"
error_log="./error.log"

# Parse command-line arguments
while getopts "i:o:b:e:" opt; do
  case $opt in
    i) input_directory="$OPTARG" ;;
    o) output_directory="$OPTARG" ;;
    b) batch_size="$OPTARG" ;;
    e) error_log="$OPTARG" ;;
    *) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

# Create output directory if it doesn't exist
mkdir -p "$output_directory"

# Initialize or clear the error log file
> "$error_log"

# Find all SMI files in the input directory
smi_files=($(find "$input_directory" -maxdepth 1 -name "*.smi"))

# Calculate the number of batches needed
total_files=${#smi_files[@]}
total_batches=$(( (total_files + batch_size - 1) / batch_size ))

# Function to process a batch of files
process_batch() {
    local batch_files=("$@")
    for smi_file in "${batch_files[@]}"; do
        local output_file="$output_directory/$(basename "$smi_file" .smi).sdf"

        # Check if the output file already exists
        if [ -f "$output_file" ]; then
            echo "File already converted, skipping: $smi_file" | tee -a "$error_log"
            continue
        fi

        # Run obabel with a timeout of 120 seconds and check for errors
        start_time=$(date +%s)
        if ! timeout 120 obabel -ismi "$smi_file" -osdf -O "$output_file" -m -h --gen3d -e --stereo; then
            echo "Error converting molecule in file: $smi_file" | tee -a "$error_log"
            continue
        fi
        end_time=$(date +%s)
        elapsed_time=$((end_time - start_time))

        # Log the elapsed time
        echo "Processed $smi_file in $elapsed_time seconds" | tee -a "$error_log"
    done
}

# Process files in batches
for ((batch=0; batch<total_batches; batch++)); do
    start_index=$((batch * batch_size))
    end_index=$(((batch + 1) * batch_size - 1))
    if [ $end_index -ge $total_files ]; then
        end_index=$((total_files - 1))
    fi

    batch_files=("${smi_files[@]:$start_index:$((end_index - start_index + 1))}")

    # Run process_batch function in the background
    process_batch "${batch_files[@]}" &

    # Limit the number of background processes
    if (( (batch + 1) % (batch_size / 10) == 0 )); then
        wait
    fi
done

# Wait for any remaining background jobs to finish
wait

# Touch the skipped files to update their modification time
for smi_file in "${smi_files[@]}"; do
    local output_file="$output_directory/$(basename "$smi_file" .smi).sdf"
    if [ -f "$output_file" ]; then
        touch "$output_file"
    fi
done

echo "Processing complete!" | tee -a "$error_log"

