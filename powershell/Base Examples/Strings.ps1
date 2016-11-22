#Types of strings

$myString = "Random text   "

$myString.Length | gm

$myString.Length

#trim the spaces out

$myString = $myString.Trim("*").Length


#change to upper.

$myString2 = "string tEXT"
$myString2 = $myString2.ToUpper()

$myString2

# compare one string to another -1 for fail, 0 for true

$myString3 = "Random Text".ToUpper()
$userString = "RANDOM TEXT"

$isEqual = $myString3.CompareTo($userString)

# Try to grab the last four characters of a string


#$myLength = $myString4.Length
#$result = $myString4.Remove(0, $myLength - 4)
#$result
#$myString3.Substring(0,4)


#Replace parts of a string. 

$myString5 = "Marsha will be grading labs"
$hobby = "watching the Blue Jays win World Series"
$myString5.Replace("grading labs", $hobby)