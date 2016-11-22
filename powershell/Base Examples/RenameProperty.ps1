#Rename Property Name

gsv | 
select @{Name = "Service";Expression={$_.Name}}
select @{Name = "Current_Status";Expression={$_.Status}} |
sort Current_status 