#Great for breaking out of logon scripts

$strFileName="c:\filename.txt"
If (Test-Path $strFileName){
  # // File exists so exit script
  break
}Else{
  # // File does not exist
    "running more code and creating a file so we know the code was run."
    New-Item C:\filename.txt -ItemType file
}
