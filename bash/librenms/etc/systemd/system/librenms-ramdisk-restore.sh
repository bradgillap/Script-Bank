[Unit]
Description=Restore LibreNMS Data to RAM Disk
After=local-fs.target
After=librenms-ramdisk-setup.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/librenms-ramdisk.sh start
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
