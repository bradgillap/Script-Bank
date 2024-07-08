# Check if SNMP is already installed
$snmpFeature = Get-WindowsCapability -Online | Where-Object { $_.Name -eq "SNMP.Client~~~~0.0.1.0" }
if ($snmpFeature -and $snmpFeature.State -eq 'Installed') {
    Write-Output "SNMP is already installed."
} else {
    # Install SNMP, Enables by default
    Add-WindowsCapability -Online -Name "SNMP.Client~~~~0.0.1.0"
    Write-Output "SNMP has been installed."
}