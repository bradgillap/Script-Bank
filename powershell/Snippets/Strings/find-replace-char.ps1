#Replace illegal character.

cls
$illegalChars = '/','\','*',':','?','"','>','<','|'
[string]$file = 'exmaple/\'
foreach ($illegalcharacter in $illegalChars) {
    
    if($file.Contains($illegalcharacter)) 
        {
           $file = $file.Replace($illegalcharacter,"")
    }
}

write-host $file