cls
$startTimer = 10
$increment = 2
$percentComplete = 0
$perComplete = 0

for($i = $startTimer; $i -gt 0; $i -= $increment) {
    cls
    $perComplete = $i/$startTimer * 100
	$percentComplete = $startTimer 
	#write-host "Shutting down in $i seconds." -NoNewLine

    Write-Progress -Activity "Shutting down in" -PercentComplete $perComplete 

	start-sleep -Seconds $increment
}