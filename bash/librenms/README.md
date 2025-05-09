# LibreNMS RAM Disk Setup and Backup

This repository contains scripts and services to optimize LibreNMS by using a RAM disk for high-write directories (rrd and logs). This approach reduces SSD wear while ensuring data integrity through automated backups and restores.

## Overview

The setup includes the following components:

### Locations of Note

The paths we will be replacing with ramdisk.

  - /opt/librenms/rrd
  - /opt/librenms/logs

The paths where the data will be stored after.

  - /mnt/ramdisk/rrd
  - /mnt/ramdisk/logs

### Scripts:

setup-librenms-ramdisk.sh: Creates necessary directories on the RAM disk, sets permissions, and creates symbolic links.
librenms-ramdisk.sh: Handles data backup and restore operations between the RAM disk and persistent storage.

### Systemd Services:

- librenms-ramdisk-setup.service: Sets up the RAM disk and directories during boot.
- librenms-ramdisk-restore.service: Restores data from persistent storage to the RAM disk after setup.
- librenms-ramdisk-backup.service: Backs up data from the RAM disk to persistent storage during shutdown.

## Installation

Before you begin, move your rrd and log folders out of the /opt/librenms folder to somewhere else temporarily. The reason is that the symbolic links will be created on the ramdisk in this step and if these static folders already exist within the /opt/librenms then it'll cause issues. We want librenms to look at the symbolic links instead for their data.

1. Clone the Repository
Copy code from directory

2. Install Scripts
Copy the scripts to /usr/local/bin and make them executable:

Copy code
```
sudo cp setup-librenms-ramdisk.sh /usr/local/bin/
sudo cp librenms-ramdisk.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/setup-librenms-ramdisk.sh
sudo chmod +x /usr/local/bin/librenms-ramdisk.sh
```

3. Install Systemd Services
Copy the service files to /etc/systemd/system/:


Copy code
```
sudo cp services/*.service /etc/systemd/system/
sudo systemctl daemon-reload
Enable the services:
```


Copy code
```
sudo systemctl enable librenms-ramdisk-setup.service
sudo systemctl enable librenms-ramdisk-restore.service
sudo systemctl enable librenms-ramdisk-backup.service
```

## Usage

### Service Descriptions

1. librenms-ramdisk-setup.service
  - Runs during system boot.
  - Creates the rrd and logs directories on the RAM disk, sets ownership, and creates symbolic links in /opt/librenms.

2. librenms-ramdisk-restore.service
  - Runs after librenms-ramdisk-setup.service.
  - Restores data from the persistent backup directory to the RAM disk.

3. librenms-ramdisk-backup.service
  - Runs during system shutdown.
  - Backs up the contents of the RAM disk (rrd and logs) to persistent storage to prevent data loss.

### Script Descriptions

1. setup-librenms-ramdisk.sh
  - Creates required directories (rrd and logs) on the RAM disk.
  - Sets appropriate ownership and permissions.
  - Creates symbolic links from /opt/librenms to the RAM disk directories.

2. librenms-ramdisk.sh
  - start: Restores data from persistent storage to the RAM disk.
  - stop: Backs up data from the RAM disk to persistent storage.

## Configuration

1. Update the paths in the scripts (RAMDISK_PATH, LIBRENMS_PATH, BACKUP_PATH) to match your setup.
2. Ensure the backup directory (BACKUP_PATH) is on a persistent storage device.
3. Testing
4. Reboot the System
5. Verify that the directories (rrd and logs) are created and restored correctly.
6. Check symbolic links in /opt/librenms:

Copy code
```
ls -ld /opt/librenms/rrd /opt/librenms/logs
```

### Shutdown the System
1. Verify that data is backed up to persistent storage.
2. Check Logs
3. Review service logs for any errors:

Copy code
```
sudo journalctl -u librenms-ramdisk-setup.service
sudo journalctl -u librenms-ramdisk-restore.service
sudo journalctl -u librenms-ramdisk-backup.service
```

