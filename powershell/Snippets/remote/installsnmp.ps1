$computers = get-content D:\complist.txt
foreach($computer in $computers)
{Invoke-Command -computername $computer -ScriptBlock {Enable-WindowsOptionalFeature -online -norestart -logpath "D:\snmpinstall.log" -FeatureName snmp; Enable-WindowsOptionalFeature -online -norestart "D:\wmisnmpinstall.log" -FeatureName wmisnmpprovider}};
