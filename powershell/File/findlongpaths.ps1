//Finds paths of long file names greater than X. Good for fixing folder redirection issues.

Out-File U:\longfilepath.txt ; cmd "U:\" "dir /b /s /a" | ForEach-Object { if ($_.length -gt 230) {$_ | Out-File -append longfilepath.txt}}
