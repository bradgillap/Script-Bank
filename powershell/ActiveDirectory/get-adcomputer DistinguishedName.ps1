get-adcomputer "COMPUTERNAME" -properties "DistinguishedName" | select -Property DistinguishedName
//Strip title and crush linespacing
get-adcomputer "vic-st-01" -properties "DistinguishedName" | select -ExpandProperty DistinguishedName | Out-File -FilePath "D:\DistinguishedNames.txt" -Append -NoClobber

// with tables and spacing
get-adcomputer "vic-st-01" -properties "DistinguishedName" | select -Property DistinguishedName | format-table -HideTableHeaders | Out-File -FilePath "D:\DistinguishedNames.txt" -Append -NoClobber

//get all computers export csv
get-adcomputer -Filter * -properties "DistinguishedName" | export-csv -path "D:\DistinguishedNames.csv"

//set user to primary computer
Set-aduser <user name> -add @{‘msDS-PrimaryComputer’=(get-adcomputer <computer name>).distinguishedname}
