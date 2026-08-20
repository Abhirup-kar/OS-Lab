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


read -p "Enter an integer: " num

if ! [[ "$num" =~ ^[0-9]+$ ]]; then
    echo "Error: Please enter a valid non-negative integer."
    exit 1
fi


start_time=$(date +%s%N)


result=$(factorial "$num")

end_time=$(date +%s%N)

# Calculate duration in milliseconds
duration_ns=$((end_time - start_time))
duration_ms=$(awk "BEGIN {printf \"%.3f\", $duration_ns/1000000}")

echo "----------------------------------------"

echo "Factorial of $num is: $result"
echo "Time taken: ${duration_ms} ms (${duration_ns} ns)"
echo "----------------------------------------"