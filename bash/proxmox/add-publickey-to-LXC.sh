#!/bin/bash

#This script will take your public key, create .ssh and authorized keys if it does not exist and add your key to each LXC on the server. 

# Path to your public key, make sure your public key is on the host server PVE server in the .ssh folder. 
PUB_KEY_PATH="$HOME/.ssh/id_rsa_mykey.pub"

# Read the public key into a variable
PUB_KEY=$(cat $PUB_KEY_PATH)

# Get the Proxmox node's hostname (this will work because the script runs on the Proxmox host)
NODE_NAME=$(hostname)

# Get the list of all LXC container IDs on the node
CONTAINERS=$(pvesh get /nodes/$NODE_NAME/lxc | grep -o '"vmid":[0-9]*' | cut -d: -f2)

# Loop through each container ID
for CTID in $CONTAINERS; do
    echo "Checking container $CTID"

    # Ensure the .ssh directory exists
    pct exec $CTID -- mkdir -p /root/.ssh

    # Ensure the authorized_keys file exists (it won't overwrite the file if it exists)
    pct exec $CTID -- touch /root/.ssh/authorized_keys

    # Check if the public key is already in the authorized_keys file
    KEY_EXISTS=$(pct exec $CTID -- grep -F "$PUB_KEY" /root/.ssh/authorized_keys)

    if [ -z "$KEY_EXISTS" ]; then
        # If the key doesn't exist, add it
        echo "Adding SSH key to container $CTID"
        pct exec $CTID -- bash -c "echo '$PUB_KEY' >> /root/.ssh/authorized_keys"
        pct exec $CTID -- chmod 600 /root/.ssh/authorized_keys
        pct exec $CTID -- chown root:root /root/.ssh/authorized_keys
        echo "SSH key added to container $CTID"
    else
        echo "SSH key already exists in container $CTID, skipping..."
    fi
done

echo "Done!"
