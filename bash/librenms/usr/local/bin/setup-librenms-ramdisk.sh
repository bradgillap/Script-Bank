#!/bin/bash

RAMDISK_PATH="/mnt/ramdisk"
LIBRENMS_PATH="/opt/librenms"
BACKUP_PATH="/backup"

# Ensure RAM disk directories exist
mkdir -p "$RAMDISK_PATH/rrd" "$RAMDISK_PATH/logs"

 Restore data from backup
if [ -d "$BACKUP_PATH/rrd" ]; then
    rsync -a "$BACKUP_PATH/rrd/" "$RAMDISK_PATH/rrd/"
fi
if [ -d "$BACKUP_PATH/logs" ]; then
    rsync -a "$BACKUP_PATH/logs/" "$RAMDISK_PATH/logs/"
fi

# Create symbolic links
ln -sf "$RAMDISK_PATH/rrd" "$LIBRENMS_PATH/rrd"
ln -sf "$RAMDISK_PATH/logs" "$LIBRENMS_PATH/logs"

# Set permissions
chown -R librenms:librenms "$RAMDISK_PATH/rrd" "$RAMDISK_PATH/logs"
chown -h librenms:librenms "$LIBRENMS_PATH/rrd" "$LIBRENMS_PATH/logs"
chmod  775 /mnt/ramdisk/ -R
