#!/bin/bash

# Continuously loop to update status
while true; do
    # Get volume and mute status
    volume=$(pamixer --get-volume)
    is_muted=$(pamixer --get-mute)
    
    # Define the mute icon as a Unicode character
    mute_icon=$'\ueb24' # Unicode character for mute icon
    
    # Check if muted
    if [ "$is_muted" = "true" ]; then
        volume_display="$mute_icon Muted"
    else
        volume_display="Volume: ${volume}%"
    fi

    # Get current time
    current_time=$(date +"%Y-%m-%d %H:%M:%S")

    # Get CPU usage using mpstat
    # mpstat 1 1 outputs CPU usage data over an interval of 1 second
    cpu_idle=$(mpstat 1 1 | awk '/Average:/ {print $NF}')
    cpu_usage=$(awk "BEGIN{print 100 - $cpu_idle}")

    # Get RAM usage in MiB
    total_mem=$(free | grep Mem | awk '{print $2}')
    used_mem=$(free | grep Mem | awk '{print $3}')
    used_mem_mib=$(echo "$used_mem/1024" | bc) # Convert from KiB to MiB

    # Get network name
    network_name=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d':' -f2)

    # Combine information into a single line
    echo "| $volume_display | CPU Usage: ${cpu_usage}% | RAM Usage: ${used_mem_mib} MiB | Network: ${network_name} | Time: ${current_time} |"

    sleep 1 # Update every second
done
