#!/bin/bash

# Your Semaphore Public Key
PUB_KEY="..."

# Adjust range as needed for your IDs
for id in {329..329}; do
  # Check if the container exists and is running
  status=$(pct status $id 2>/dev/null)
  if [[ $? -ne 0 || "$status" != *"status: running"* ]]; then
    echo "LXC $id is not running or doesn't exist. Skipping..."
    continue
  fi

  echo "--- Processing LXC $id ---"

  pct exec $id -- /bin/sh -c "
    # 1. OS Detection & Dependency Install
    if [ -f /usr/bin/apk ]; then
      echo 'Detected Alpine Linux'
      apk add --no-cache sudo shadow openssh-sftp-server openssh
      SHELL_BIN='/bin/sh'
      SSH_SERVICE='sshd'
    elif [ -f /usr/bin/apt ]; then
      echo 'Detected Debian/Ubuntu'
      apt-get update && apt-get install -y sudo openssh-server
      SHELL_BIN='/bin/bash'
      SSH_SERVICE='ssh'
    else
      echo 'Unknown OS, attempting generic setup...'
      SHELL_BIN='/bin/sh'
      SSH_SERVICE='sshd'
    fi

    # 2. User Creation & Account Unlocking
    if ! id -u ansible >/dev/null 2>&1; then
      useradd -m -s \"\$SHELL_BIN\" ansible
    fi
    # Ensure account is not locked (Common Alpine issue)
    if [ -f /etc/shadow ]; then
      passwd -u ansible 2>/dev/null
    fi

    # 3. Directory Preparation
    mkdir -p /home/ansible/.ssh
    mkdir -p /home/ansible/.ansible/tmp
    
    # 4. Permissions & Ownership Fix
    # SSH requires the home dir not be group-writable. 
    # Ansible requires the user to own the home dir to create work folders.
    chown ansible:ansible /home/ansible
    chmod 750 /home/ansible
    
    # Set strict perms on SSH and Ansible directories
    chown -R ansible:ansible /home/ansible/.ssh
    chown -R ansible:ansible /home/ansible/.ansible
    chmod 700 /home/ansible/.ssh
    chmod 700 /home/ansible/.ansible
    chmod 600 /home/ansible/.ssh/authorized_keys 2>/dev/null

    # 5. SSH Key Deployment
    if ! grep -q \"$PUB_KEY\" /home/ansible/.ssh/authorized_keys 2>/dev/null; then
      echo \"$PUB_KEY\" >> /home/ansible/.ssh/authorized_keys
      chmod 600 /home/ansible/.ssh/authorized_keys
      chown ansible:ansible /home/ansible/.ssh/authorized_keys
    fi

    # 6. Sudoers Configuration
    mkdir -p /etc/sudoers.d
    echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible
    chmod 440 /etc/sudoers.d/ansible

    # 7. SSHD Configuration Refinement
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config
    
    # 8. Restart SSH service to apply changes
    if [ -f /etc/init.d/\$SSH_SERVICE ]; then
      /etc/init.d/\$SSH_SERVICE restart
    elif command -v systemctl >/dev/null 2>&1; then
      systemctl restart \$SSH_SERVICE
    fi
    
    echo 'LXC $id Onboarding Complete!'
  "
done
