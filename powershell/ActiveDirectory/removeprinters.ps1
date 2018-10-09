//Removes all previous mapped printers.

Get-printer | where{$_.Portname -match ‘\d{1,3}(\.\d{1,3}){3}’} | Remove-Printer
