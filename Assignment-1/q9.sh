#!/bin/bash

# Function to calculate factorial recursively
factorial() {
    local n=$1
    if [ "$n" -le 1 ]; then
        echo 1
    else
        local prev
        prev=$(factorial $((n - 1)))
        echo $((n * prev))
    fi
}

# Main script logic
read -p "Enter an integer: " num

# Input validation: check if input is a non-negative integer
if ! [[ "$num" =~ ^[0-9]+$ ]]; then
    echo "Error: Please enter a valid non-negative integer."
    exit 1
fi

# Record start time with nanosecond precision
start_time=$(date +%s%N)

# Calculate factorial
result=$(factorial "$num")

# Record end time with nanosecond precision
end_time=$(date +%s%N)

# Calculate duration in milliseconds
duration_ns=$((end_time - start_time))
duration_ms=$(awk "BEGIN {printf \"%.3f\", $duration_ns/1000000}")

# Output results
echo "----------------------------------------"
echo "Factorial of $num is: $result"
echo "Time taken: ${duration_ms} ms (${duration_ns} ns)"
echo "----------------------------------------"