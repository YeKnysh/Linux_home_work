#!/bin/bash

# Ask user for target address
read -p "Enter address to ping: " target

# Set threshold and failure counter
max_ping_ms=100
max_failures=3
failures=0

# Infinite loop
while true
do
    # Try to ping once
    ping_output=$(ping -c 1 "$target" | grep 'time=')

    if [ -z "$ping_output" ]; then
        echo "Ping failed."
        ((failures++))
    else
        # Reset failure counter
        failures=0

        # Extract ping time
        ping_time=$(echo "$ping_output" | awk -F'time=' '{print $2}' | awk '{print $1}' | cut -d'.' -f1)

        if [ "$ping_time" -gt "$max_ping_ms" ]; then
            echo "Ping time is too high: ${ping_time} ms"
        else
            echo "Ping OK: ${ping_time} ms"
        fi
    fi

    # Check failure limit
    if [ "$failures" -ge "$max_failures" ]; then
        echo "Ping failed 3 times in a row. Exiting."
        break
    fi

    sleep 1
done
