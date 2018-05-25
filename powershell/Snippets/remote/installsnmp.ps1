$computers = get-content D:\complist.txt
foreach($computer in $computers)
{Invoke-Command -computername $computer -ScriptBlock {Enable-WindowsOptionalFeature -online -FeatureName snmp; Enable-WindowsOptionalFeature -online -FeatureName wmisnmpprovider}};
