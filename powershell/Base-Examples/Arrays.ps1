#forced string array
[string[]]$workstations = "L1", "L2", "L3", "L4", 560
$workstations[0,1]

#number array
#$numbers = 1,2,3,4,5
$numbers = (1..5)
$numbers
$letters = 'a'
$letters

#Concatenate arrays
$LowNumbers = (1..5)
$HighNumbers = (6..10)
$allnumbers = $LowNumbers + $HighNumbers
$allnumbers

#start a counter for items in the array
# loop through the array


$numItems = $workstations.Count
for($i = 0; $i -lt $numItems; $i++){

write-host $workstations[$i]


}

#whereobject with array.

$comp = "L1", "L2", "L2", "L3", "L4"


$comp | Where-Object { $_ -like "*3*"} | 
measure-object

#test