clear

$firstName = "Bradley Gillap"
[char]$midInitial = "J"
$lastName = "Gillap"
[int64]$phoneNumber = 5555555
$addyUnit = 55
$addyNumber = 555
$addyStreet = "Regular Rd."
$age = 33
[char]$gender = "M"
[boolean]$employedStatus = $True
[double]$Salary = 10000.50
[datetime]$workStartDate = "October 25 2015"
    $newMonth = $workStartDate.Month 
    $newDay = $workStartDate.Day
    $newYear = $workStartDate.Year



Write-Host "Name:`t`t$firstName`nStartDate`t$newMonth"-"$newDay"-"$newYear`n"