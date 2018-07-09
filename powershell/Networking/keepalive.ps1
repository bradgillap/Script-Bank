for($i=1; $i=10; $i) {	
	Test-Connection -ComputerName "172.16.3.5","172.16.4.5","172.16.5.5" -Delay 5 -TTL 255 -BufferSize 32 -Throttlelimit 32 -Count 1
}