# Server2016 offers a really annoying service meant for desktops and causes errors
Invoke-Command -ComputerName server1,server2,server3,"server 04","server 05" -ScriptBlock {Get-Service -Name MapsBroker | Set-Service -StartupType Disabled}
