# LibreNMS RAM Disk Setup and Backup

This repository contains scripts and services to optimize LibreNMS by using a RAM disk for high-write directories (rrd and logs). This approach reduces SSD wear while ensuring data integrity through automated backups and restores.

## Overview

The setup includes the following components:

### Scripts:

setup-librenms-ramdisk.sh: Creates necessary directories on the RAM disk, sets permissions, and creates symbolic links.
librenms-ramdisk.sh: Handles data backup and restore operations between the RAM disk and persistent storage.

### Systemd Services:

librenms-ramdisk-setup.service: Sets up the RAM disk and directories during boot.
librenms-ramdisk-restore.service: Restores data from persistent storage to the RAM disk after setup.
librenms-ramdisk-backup.service: Backs up data from the RAM disk to persistent storage during shutdown.

## Installation

1. Clone the Repository
bash
Copy code
git clone https://github.com/yourusername/librenms-ramdisk.git
cd librenms-ramdisk
2. Install Scripts
Copy the scripts to /usr/local/bin and make them executable:

bash
Copy code
sudo cp setup-librenms-ramdisk.sh /usr/local/bin/
sudo cp librenms-ramdisk.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/setup-librenms-ramdisk.sh
sudo chmod +x /usr/local/bin/librenms-ramdisk.sh
3. Install Systemd Services
Copy the service files to /etc/systemd/system/:

bash
Copy code
sudo cp services/*.service /etc/systemd/system/
sudo systemctl daemon-reload
Enable the services:

bash
Copy code
sudo systemctl enable librenms-ramdisk-setup.service
sudo systemctl enable librenms-ramdisk-restore.service
sudo systemctl enable librenms-ramdisk-backup.service
Usage
Service Descriptions
librenms-ramdisk-setup.service

Runs during system boot.
Creates the rrd and logs directories on the RAM disk, sets ownership, and creates symbolic links in /opt/librenms.
librenms-ramdisk-restore.service

Runs after librenms-ramdisk-setup.service.
Restores data from the persistent backup directory to the RAM disk.
librenms-ramdisk-backup.service

Runs during system shutdown.
Backs up the contents of the RAM disk (rrd and logs) to persistent storage to prevent data loss.
Script Descriptions
setup-librenms-ramdisk.sh

Creates required directories (rrd and logs) on the RAM disk.
Sets appropriate ownership and permissions.
Creates symbolic links from /opt/librenms to the RAM disk directories.
librenms-ramdisk.sh

start: Restores data from persistent storage to the RAM disk.
stop: Backs up data from the RAM disk to persistent storage.
Configuration
Update the paths in the scripts (RAMDISK_PATH, LIBRENMS_PATH, BACKUP_PATH) to match your setup.
Ensure the backup directory (BACKUP_PATH) is on a persistent storage device.
Testing
Reboot the System

Verify that the directories (rrd and logs) are created and restored correctly.
Check symbolic links in /opt/librenms:
bash
Copy code
ls -ld /opt/librenms/rrd /opt/librenms/logs
Shutdown the System

Verify that data is backed up to persistent storage.
Check Logs

Review service logs for any errors:
bash
Copy code
sudo journalctl -u librenms-ramdisk-setup.service
sudo journalctl -u librenms-ramdisk-restore.service
sudo journalctl -u librenms-ramdisk-backup.service
License
This project is licensed under the MIT License. See LICENSE for details.

Feel free to adapt this README to include any additional details specific to your setup!