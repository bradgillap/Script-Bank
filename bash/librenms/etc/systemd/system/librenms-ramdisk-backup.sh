[Unit]
Description=Backup LibreNMS Data from RAM Disk
DefaultDependencies=no
Before=shutdown.target reboot.target halt.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/librenms-ramdisk.sh stop

[Install]
WantedBy=halt.target reboot.target shutdown.target
