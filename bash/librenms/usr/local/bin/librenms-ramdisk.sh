#!/bin/bash

RAMDISK_PATH="/mnt/ramdisk"
BACKUP_PATH="/backup"

case "$1" in
  start)
    echo "Restoring RAM disk contents..."
    mkdir -p "$RAMDISK_PATH/rrd" "$RAMDISK_PATH/logs"
    rsync -a "$BACKUP_PATH/rrd/" "$RAMDISK_PATH/rrd/"
    rsync -a "$BACKUP_PATH/logs/" "$RAMDISK_PATH/logs/"
    ;;
  stop)
    echo "Backing up RAM disk contents..."
    rsync -a "$RAMDISK_PATH/rrd/" "$BACKUP_PATH/rrd/"
    rsync -a "$RAMDISK_PATH/logs/" "$BACKUP_PATH/logs/"
    ;;
  *)
    echo "Usage: $0 {start|stop}"
    exit 1
    ;;
esac
