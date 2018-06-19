'\''
new ActiveXObject("WScript.Shell").Run("powershell.exe -ExecutionPolicy Bypass -Command \"(Get-Content \\\"" + WScript.ScriptFullName + "\\\") -join \\\"`n\\\" | Invoke-Expression\"", 0)
"'>'';#\""/*

New-Item 'SilenceIsGolden' -ItemType File

#*/
