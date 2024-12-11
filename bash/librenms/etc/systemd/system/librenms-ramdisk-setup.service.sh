[Unit]
Description=Setup LibreNMS RAM Disk
After=local-fs.target
Before=librenms-ramdisk-restore.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/setup-librenms-ramdisk.sh

[Install]
WantedBy=multi-user.target
