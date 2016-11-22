# For loop

for($i=0; $i -lt 10; $i++) {

}

# While loop
$i = 0
while($i -lt 10) {

}


# forward only loop. Goes through each line and lets you work with things like $machines.column
$machines = Import-Csv C:\Users\Administrator\Desktop\machines.txt


foreach($m in $machines) {

    $manu = $m.manufacturer.Substring(0,1)
    $model = $m."model#"
    Write-Host "$manu$model"

}



#LOOKS REPLACE FILE.

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