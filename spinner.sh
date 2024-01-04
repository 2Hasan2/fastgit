#!/bin/bash

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'

    # Hide the cursor
    tput civis

    while ps -p $pid > /dev/null; do
        local temp=${spinstr#?}
        printf " [%c] " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done

    # Show the cursor again
    tput cnorm

    printf "    \b\b\b\b"
}

# Example usage
echo "Running a time-consuming task..."
sleep 5 &

# Get the process ID of the last background command
pid=$!

# Call the spinner function with the process ID
spinner $pid
