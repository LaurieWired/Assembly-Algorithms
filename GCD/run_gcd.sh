#!/bin/bash

# Check if two arguments were provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <integer1> <integer2>"
    exit 1
fi

# Check if both arguments are integers
if ! [[ $1 =~ ^[0-9]+$ ]] || ! [[ $2 =~ ^[0-9]+$ ]]; then
    echo "Error: Both arguments must be integers."
    exit 1
fi

# Check if the 'gcd' executable exists in the current directory
if [ ! -f "./gcd" ]; then
    echo "Error: 'gcd' executable not found in the current directory."
    exit 1
fi

# Run the 'gcd' executable with the provided arguments
./gcd "$1" "$2"

# Call gcd.py to display the result
python3 gcd.py "$1" "$2"
