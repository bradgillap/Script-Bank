#!/bin/bash

# This script adds your public SSH key to all or a specific LXC container on a Proxmox node.
# Usage: ./addkey3.sh [-k <public_key_path>] [-c <container_id>]
#   -k <public_key_path>: Path to the public SSH key file (default: ~/.ssh/id_rsa_home.pub)
#   -c <container_id>: Specific container ID to add the key to (optional, if not specified, all containers will be processed)

# Function to display usage information
usage() {
    echo "Usage: $0 [-k <public_key_path>] [-c <container_id>]"
    echo "  -k <public_key_path>: Path to the public SSH key file (default: ~/.ssh/id_rsa_home.pub)"
    echo "  -c <container_id>: Specific container ID to add the key to (optional)"
    exit 1
}

# Default values
PUB_KEY_PATH="$HOME/.ssh/id_rsa_home.pub"
CONTAINER_ID=""

# Parse command-line arguments
while getopts ":k:c:" opt; do
    case $opt in
        k)
            PUB_KEY_PATH="$OPTARG"
            ;;
        c)
            CONTAINER_ID="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. This script requires jq to process JSON output."
    # Attempt to install jq using apt, if whiptail is available for interactive messages
    if command -v whiptail &> /dev/null; then
        whiptail --title "Missing Dependency" --msgbox "The utility 'jq' is required. Installing it now..." 8 50
    fi
    apt update && apt install -y jq
    # Check again if jq installed successfully
    if ! command -v jq &> /dev/null; then
        echo "Failed to install jq. Please install it manually and rerun the script."
        exit 1
    fi
fi

# Check if the public key file exists
if [ ! -f "$PUB_KEY_PATH" ]; then
    if command -v whiptail &> /dev/null; then
        PUB_KEY=$(whiptail --title "SSH Public Key Not Found" --inputbox "The public key file ($PUB_KEY_PATH) was not found. Please paste your SSH public key below:" 10 70 3>&1 1>&2 2>&3)
        EXIT_STATUS=$?
        if [ $EXIT_STATUS -ne 0 ]; then
            echo "Public key input canceled. Exiting."
            exit 1
        fi
    else
        echo "Error: Public key file not found at $PUB_KEY_PATH, and whiptail is not installed for interactive input."
        exit 1
    fi
else
    PUB_KEY=$(cat "$PUB_KEY_PATH")
fi

if [ -z "$PUB_KEY" ]; then
    echo "Error: Public key is empty. Check the input or file content."
    exit 1
fi

# Get the Proxmox node's hostname
NODE_NAME=$(hostname)

# Function to add SSH key to a container
add_ssh_key_to_container() {
    local CTID=$1
    echo "Processing container $CTID"

    # Ensure the container is accessible
    if ! pct exec $CTID -- mkdir -p /root/.ssh; then
        echo "Failed to access container $CTID. Skipping..."
        return
    fi

    # Ensure the authorized_keys file exists
    pct exec $CTID -- touch /root/.ssh/authorized_keys

    # Check if the public key is already in the authorized_keys file
    if ! pct exec $CTID -- grep -Fxq "$PUB_KEY" /root/.ssh/authorized_keys; then
        echo "Adding SSH key to container $CTID"
        pct exec $CTID -- bash -c "echo '$PUB_KEY' >> /root/.ssh/authorized_keys"
        pct exec $CTID -- chmod 600 /root/.ssh/authorized_keys
        pct exec $CTID -- chown root:root /root/.ssh/authorized_keys
        echo "SSH key added to container $CTID"
    else
        echo "SSH key already exists in container $CTID, skipping..."
    fi
}

# Get the list of all LXC container IDs on the node or a specific one if provided
if [ -z "$CONTAINER_ID" ]; then
    CONTAINERS=$(pvesh get /nodes/$NODE_NAME/lxc --output-format json | jq -r '.[].vmid')
    if [ -z "$CONTAINERS" ]; then
        echo "No LXC containers found on node $NODE_NAME."
        exit 1
    fi
else
    CONTAINERS="$CONTAINER_ID"
fi

# Loop through each container ID
for CTID in $CONTAINERS; do
    add_ssh_key_to_container "$CTID"
done

echo "Done!"
