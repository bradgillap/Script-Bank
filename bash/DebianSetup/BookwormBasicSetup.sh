#!/bin/bash

# Just a bash file that does the following
# Checks to make sure it has root.
# Logs actions to a txt file in the same folder where script run.
# Creates a backup of configuration files affected first.
# Installs sudo curl wget2 fail2ban unattended-upgrades apt-listchanges ncdu
# Disables IPV6 globally via sysctl
# Enables permit root login for sshd
# enables unattended upgrades to allow automatic install of security updates
# Do not recommend permitting root login on Internet exposed machines. For that go through further hardening.
# use BookwormBasicSetup.sh --rollback to restore configuration files. 

# Set up logging
SCRIPT_DIR=$(dirname "$(realpath "$0")")
LOG_FILE="$SCRIPT_DIR/setup_log.txt"

# Log function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
    log "ERROR: This script must be run as root."
    exit 1
fi
log "Script started by root user."

# Backup critical files before making changes
backup_files() {
    log "Backing up configuration files..."
    cp /etc/sysctl.conf /etc/sysctl.conf.bak
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    log "Backups created for /etc/sysctl.conf and /etc/ssh/sshd_config."
}

# Rollback function to revert changes
rollback() {
    log "Starting rollback..."

    # Restore configuration files from backup
    if [ -f /etc/sysctl.conf.bak ]; then
        cp /etc/sysctl.conf.bak /etc/sysctl.conf
        sysctl -p /etc/sysctl.conf
        log "Restored /etc/sysctl.conf from backup."
    else
        log "No backup found for /etc/sysctl.conf, rollback skipped for this file."
    fi

    if [ -f /etc/ssh/sshd_config.bak ]; then
        cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
        log "Restored /etc/ssh/sshd_config from backup."
        systemctl restart ssh && log "SSH service restarted."
    else
        log "No backup found for /etc/ssh/sshd_config, rollback skipped for this file."
    fi

    log "Rollback complete."
}

# Check if rollback flag is set
if [ "$1" == "--rollback" ]; then
    rollback
    exit 0
fi

# Call backup function
backup_files

# Install necessary packages
log "Starting package installation..."
for pkg in sudo curl wget2 fail2ban unattended-upgrades apt-listchanges ncdu; do
    if ! dpkg -l | grep -qw "$pkg"; then
        apt install -y "$pkg"
        log "Installed $pkg."
    else
        log "$pkg is already installed."
    fi
done

# Configure unattended upgrades for security updates only
log "Configuring unattended upgrades for security updates only..."
echo "unattended-upgrades unattended-upgrades/enable_auto_updates boolean true" | debconf-set-selections
dpkg-reconfigure -f noninteractive unattended-upgrades

cat << EOF > /etc/apt/apt.conf.d/50unattended-upgrades
Unattended-Upgrade::Origins-Pattern {
        "origin=Debian,codename=\${distro_codename},label=Debian-Security";
};
EOF

log "Unattended upgrades configured for security updates only."

# Prompt to disable IPv6 if it is currently enabled
ipv6_disabled=$(sysctl -n net.ipv6.conf.all.disable_ipv6 2>/dev/null)
if [ "$ipv6_disabled" -eq 1 ]; then
    log "IPv6 is already disabled globally."
else
    if (whiptail --title "IPv6 Configuration" --yesno "Do you want to disable IPv6?" 10 60); then
        # Update /etc/sysctl.conf with global IPv6 disable settings if not already present
        grep -q "net.ipv6.conf.all.disable_ipv6 = 1" /etc/sysctl.conf || echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
        grep -q "net.ipv6.conf.default.disable_ipv6 = 1" /etc/sysctl.conf || echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf

        # Apply the changes
        sysctl -p /etc/sysctl.conf
        log "IPv6 has been disabled globally."
    else
        log "IPv6 remains enabled."
    fi
fi

# Check if PermitRootLogin is already set to yes
ssh_config="/etc/ssh/sshd_config"
permit_root_login=$(grep -E "^PermitRootLogin\s+yes" "$ssh_config")

if [ -n "$permit_root_login" ]; then
    log "SSH root login is already enabled."
else
    if (whiptail --title "SSH Root Login Configuration" --yesno "Do you want to enable SSH root login?" 10 60); then
        sed -i 's/^#PermitRootLogin .*/PermitRootLogin yes/' "$ssh_config"
        log "SSH root login has been enabled."
    else
        log "SSH root login remains disabled."
    fi
fi

# Restart SSH service to apply changes if configuration was modified
if [ -z "$permit_root_login" ]; then
    if systemctl restart ssh; then
        log "SSH service restarted successfully."
    else
        log "ERROR: Failed to restart SSH service."
    fi
fi

log "Setup complete. Summary of actions:"
cat "$LOG_FILE" | tail -10
