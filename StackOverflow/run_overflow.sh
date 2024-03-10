#!/bin/bash

# Remove old files
rm -rf latest_sp.txt
rm -rf original_sp.txt

touch latest_sp.txt

# Get the stack size limit
stack_size_limit=$(ulimit -s)

# Start the Python GUI in the background and detach it, passing the stack size limit as an argument
nohup python3 show_overflow.py "$stack_size_limit" &
nohup python3 show_stack.py "$stack_size_limit" &

# Check if the 'overflow' executable exists in the current directory
if [ ! -f "./overflow" ]; then
    echo "Error: 'overflow' executable not found in the current directory."
    exit 1
fi

# Give the Python scripts a little time to initialize the GUI
sleep 2

# Run the 'overflow' executable which will write to the stack pointer tracking files
./overflow

