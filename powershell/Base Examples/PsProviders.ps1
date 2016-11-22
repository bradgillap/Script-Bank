#PSProviders



# to get a list of possible providers for hooking into file systems
Get-PSprovider


get-command -noun item
get-item
copy-item
move-item
remove-item
rename-item
new-item

set-location -path C:\windows

new-item testfolder type:something
new-item testfolder type:directory


#If you want to use a path with * and ? in it
#Use -Literalpath

#registry

set-location -path hkcu:
get-childitem
Hive: HKEY_CURRENT_USER\software

set-location microsoft
get-childitem



#Let's look at the default PS providers

Get-PSProvider

#We use this cmdlet to view the PSDrives

Get-PSDrive

#navigate to the c drive, then view all of its items

set-location C:\

#add a new directory, called test, 

new-item -ItemType Directory -Name test -Path C:\

#navigate to the test dir, then add a new file, called test.txt inside of it.

set-location C:\test
New-Item -ItemType File -name Test.txt

<#remove the directory, test, that you just made, and make sure 
that you remove all of the test dir contents, too #>

set-location C:\

Get-ChildItem

Remove-Item -Path C:\test -Recurse

#navigate to the alias drive, then view all of its items


<#let's use the new-item cmdlet to create a new alias. We will
create an alias for opening up notepad #>

#assigns np as an alias to the session.  

New-item -path alias:np -Value C:\Windows\notepad.exe


#test out the the notepad alias now!


<#let's change a registry setting, using set-itemProperty.
Change the DisableCAD property so that it requires users
to use Ctr Alt Del for login#>

set-location 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Value 0 -Name DisableCAD
get-childitem

#Create a provider at the current version folder.
New-PSDrive -Name "currentver" -PSProvider "Registry" -root 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' 

#let's look at our environment variables

#set location environment

sl env:

#get child item
gci

#To get values of env variables (i.e. homePath) you have to do this:

$env:homepath

(get-item 0Path Env:\HOMEPATH).value