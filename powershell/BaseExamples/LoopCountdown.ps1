cls
$startTimer = 10
$increment = 2

for($i = $startTimer; $i -gt 0; $i -= $increment) {
	
	cls
	
	for($j = 0; $j -lt 3; $j++)
		{
			write-host "." -NoNewLine
			start-sleep -Seconds $increment
		}
	
	write-host "Shutting down in $i seconds." -NoNewLine

	start-sleep -Seconds $increment
}