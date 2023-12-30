#!/bin/bash

# Check if an argument was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <integer>"
    exit 1
fi

# Check if the argument is an integer
if ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "Error: Argument must be an integer."
    exit 1
fi

python3 fib.py &

# Check if the 'fib' executable exists in the current directory
if [ ! -f "./fib" ]; then
    echo "Error: 'fib' executable not found in the current directory."
    exit 1
fi

# Run the 'fib' executable in a loop with a delay
for (( i = 0; i <= $1; i++ )); do
    ./fib "$i"
    sleep 0.3  # Wait for 0.3 seconds
done

