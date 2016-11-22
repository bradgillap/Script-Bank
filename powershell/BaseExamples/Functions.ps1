
#function that acts like a procedure
#does an action
function addNumbers ($n1, $n2)
{

    $n + $n2

}

cls

[int]$a = 10
[int]$b = 25

write-host "$a added to $b equals" -NoNewline
addNumbers $a $b

#Return addition
function returnAddition ($n1, $n2)
{

    return = $n1 + $n2

}

#function that does an action AND returns result
# must use an assignment statement to  call it

function returnAddition ($n1, $n2)

{
    return $n1 + $n2
}

$result = returnAddition $a $b

write-host "$a added to $b equals: $result"


#FLOWER BOX FUNCTION
function createFlowerBox ($msg)
{
    for($x = 1; $x -le 3; $x++)
    {
        if($x -eq 2)
        {
            write-host "`n*$msg*"
        }else
			{
            	for($y = 0; $y -le $msg.Length + 1; $y++)
            {
                write-host "*" -NoNewline
            }
        }
    }
}

cls

createFlowerBox "This is a test of our function"

#FIle length function
function formatLength($fileLength) {

    if($length -ge 1MB) {
        $length = "{0:N2}" -f ($length/1MB) + " MB"
    } 
    
    elseif($filelength -ge 1KB) 
        {
            $length = "{0:N2}" -f ($length/1KB) + " KB"
        } 
        else
        {
            $filelength = "{0:N2}" -f $filelength + " Bytes"
        }
    write-host $fileLength
}