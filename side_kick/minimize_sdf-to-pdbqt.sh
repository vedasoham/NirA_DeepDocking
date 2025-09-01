#!/bin/bash

# Input directory containing .sdf files
input_dir="/home/jrf-2/jrf/dd/new_run/defined_run/make_set/final_o_final/actives/actives_sdf"

# Output directory for .pdbqt files
output_dir="$input_dir/../actives_pdbqt"

# Summary log file
summary_log="$output_dir/conversion_summary.log"

# Timeout duration for minimization (in seconds)
timeout_duration=120

# Number of parallel jobs (adjust based on your system's CPU cores)
num_threads=$(nproc)

# Maximum number of retries for failed jobs
max_retries=3

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Check if input directory exists
if [ ! -d "$input_dir" ]; then
    echo "Error: Input directory '$input_dir' not found." | tee -a "$summary_log"
    exit 1
fi

# Function to process a single .sdf file
process_file() {
    local sdf_file="$1"
    local base_name=$(basename "$sdf_file" .sdf)
    local pdbqt_file="$output_dir/$base_name.pdbqt"
    local log_file="$output_dir/$base_name.log"

    # Check if .pdbqt file already exists
    if [ -f "$pdbqt_file" ]; then
        echo "Skipping $base_name.sdf, already converted." >> "$summary_log"
        return 0
    fi

    echo "Processing $sdf_file..." >> "$summary_log"

    # Convert .sdf to .pdbqt with minimization, with a timeout
    if timeout "$timeout_duration" obabel "$sdf_file" -opdbqt -O "$pdbqt_file" -h --minimize --steps 5000 --ff MMFF94 --log "$log_file"; then
        echo "Converted and minimized $base_name.sdf to $base_name.pdbqt" >> "$summary_log"
    else
        if [ $? -eq 124 ]; then
            echo "Error: $base_name.sdf minimization timed out, will retry later." >> "$summary_log"
            return 124  # Custom exit code to indicate timeout
        else
            echo "Error: Failed to convert and minimize $base_name.sdf" >> "$summary_log"
            return 1
        fi
    fi
}

export -f process_file
export timeout_duration
export output_dir
export summary_log

# Main processing loop using xargs for parallel processing
find "$input_dir" -name "*.sdf" -type f | \
    xargs -I {} -P "$num_threads" bash -c 'process_file "$@"' _ {}

# If there are any skipped files due to timeouts, retry them
if grep -q "124" "$output_dir/joblog.log"; then
    echo "Retrying skipped files..." | tee -a "$summary_log"
    grep "124" "$output_dir/joblog.log" | awk '{print $9}' | \
        xargs -I {} -P "$num_threads" bash -c 'process_file "$@"' _ {}
fi

echo "Conversion and minimization complete!" | tee -a "$summary_log"

