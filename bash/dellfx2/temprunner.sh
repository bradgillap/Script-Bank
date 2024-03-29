#!/bin/bash

# Caution: This script is not suitable for use on production systems unless you fully comprehend its functionality and potential risks to hardware.
# The script employs technician commands to manipulate the Dell Chassis Management Controller (CMC) via SSH racadm CLI, specifically targeting a Dell FX2 Chassis to set a specified fan speed percentage.
# To maintain continuous monitoring, consider restarting the script at regular intervals using systemctl. It evaluates temperatures and dynamically determines whether to enforce a fixed fan speed of 15% or leverage Dell's default fan algorithm (25% + Algorithm).
# It is recommended to execute this script from your primary hypervisor, such as an R630 or R640 server in the environment.

# If for any reason you want to switch back to algorithmic fan mode, disable this script and run the following command on the cli of the CMC or reboot it: racadm getfaninfo -p glacier -a

###### Editable Configuration Options below this line ######  

# Threshhold temperature in C. Above threshhold - switches to dells fan algorithm. Below threshhold - switches to idlefanspeed.
threshold=50
# SSH Password of your CMC Chassis. # Yes this is a security risk. Deal with it.
ssh_password='yourSSHpassword'  
# SSH user and connection to CMC. Set your user and IP or hostname. 
ssh_target='root@192.168.1.X'
# The speed in percentage at which to idle the fans at when below threshold
idlefanspeed='15'

###### Edit above this line only ######  

# Function to check if required commands are installed
check_dependencies() {
    if ! command -v sensors &> /dev/null || ! command -v sshpass &> /dev/null; then
        echo "lm-sensors or sshpass is not installed. Please install them first. apt install lm-sensors sshpass"
        exit 1
    fi
}

# Function to get CPU temperatures
get_cpu_temperatures() {
    cpu_temperature1=$(sensors | grep "Package id 0" | awk '{print $4}')
    cpu_temperature2=$(sensors | grep "Package id 1" | awk '{print $4}')

    if [ -z "$cpu_temperature1" ] || [ -z "$cpu_temperature2" ]; then
        echo "Unable to retrieve CPU temperatures."
        exit 1
    fi
}

# Function to perform SSH commands
perform_ssh_commands() {
    if (( ${cpu_temperature1%.*} > threshold )) || (( ${cpu_temperature2%.*} > threshold )); then
        echo "High temperature detected. Sending SSH commands..."
        sshpass -p "$ssh_password" ssh "$ssh_target" "racadm getfaninfo -p glacier -a"
    else
        echo "Temperature is within the normal range. Sending low fan mode commands"
        sshpass -p "$ssh_password" ssh "$ssh_target" "racadm getfaninfo -d -p glacier -w $idlefanspeed"
    fi
}

# Main Script

# Check dependencies
check_dependencies

# Get CPU temperatures
get_cpu_temperatures

# Display temperatures
echo "CPU 1 Temperature: $cpu_temperature1"
echo "CPU 2 Temperature: $cpu_temperature2"
echo "Threshold: $threshold"

# Perform SSH commands based on temperatures
perform_ssh_commands
