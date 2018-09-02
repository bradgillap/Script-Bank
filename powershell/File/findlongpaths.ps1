//Finds paths of long file names greater than X. Good for fixing folder redirection issues.

cmd /c dir /s /b |? {$_.length -gt 260} > longpath.txt
