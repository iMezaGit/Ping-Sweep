#!/bin/bash

# Input validation
if [ "$1" == "" ]; then
    echo "You must enter the network portion of the IP address"
    echo "Syntax: ./pingsweep.sh xxx.xxx.xxx"
else 
    # variables 
    results_temp=$(mktemp)
    mask="$1"

    # loop
    echo "Scanning the network $1.0/24"
    for ((ip = 1; ip <= 224; ip++)); do
        ping $mask.$ip -c 1 >> $results_temp &
        sleep 0.02
    done

    # filters
    cat "$results_temp" | grep '64 bytes' | awk '{print $4,$6}' | tr -d ':' | sort -t '.' -k 4,4n

    # Counting the results
    count=$(cat "$results_temp" | grep '64 bytes' | wc -l)
    echo "Hosts found: $count"

    # clean the temp file
    rm "$results_temp"
fi