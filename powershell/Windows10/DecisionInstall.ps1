<#

.SYNOPSIS
This is a powershell script to install software from chocolatey. The script only allows for non broken pre approved community moderated software to be installed.

.DESCRIPTION
The script itself will run through installing the latest version of chcolatey and then will continue to install the applications.

.EXAMPLE
./nfpl-circ-appinstall.ps1

.NOTES
Requires elevation to run.
Requires Internet access to run.

.LINK


#>

$windowsver = 1803

function Show-Menu
{
     param (
           [string]$Title = 'Post Install Interactive Script'
     )
     cls
     Write-Host "================ $Title ================"
     
     Write-Host "1: Press '1' Remove AppPackage Junk."
     Write-Host "2: Press '2' Turn on SNMP."
     Write-Host "3: Press '3' Install/Update Chocolatey, .NET, CSharp Dependencies."
     Write-Host "4: Press '4' Install/Upgrade 3rd Party Applications."
	 Write-Host "5: Press '5' Do Everything!"
     Write-Host "q: Press 'q' To quit."
}


do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                cls
					Write-Host "Windows AppX Packages Installed Currently" -BackgroundColor Green -ForegroundColor White
					Get-AppXProvisionedPackage  -Online | Select PackageName
					Write-Host "Removing Junk" -BackgroundColor Green -ForegroundColor White
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.BingWeather_4.24.11294.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.Microsoft3DViewer_4.1804.19012.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.MicrosoftOfficeHub_2018.428.1013.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.Office.OneNote_2015.9330.20531.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.OneConnect_4.1805.1291.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.Print3D_2.0.10611.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.WindowsFeedbackHub_2018.425.657.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.XboxApp_41.41.18005.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.XboxGameOverlay_1.30.5001.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.XboxGamingOverlay_1.15.1001.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.XboxIdentityProvider_12.41.24002.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.XboxSpeechToTextOverlay_1.21.13002.0_neutral_~_8wekyb3d8bbwe
					Write-Host "Windows AppX Packages Installed After Removal" -BackgroundColor Green -ForegroundColor White
					Get-AppXProvisionedPackage  -Online | Select PackageName
            } '2' {
                cls
					Write-Host "Installing SNMP." -BackgroundColor Green -ForegroundColor White
					#Install snmp feature
					Enable-WindowsOptionalFeature -online -norestart -FeatureName snmp
					Enable-WindowsOptionalFeature -online -norestart -FeatureName wmisnmpprovider
            } '3' {
                cls
					Write-Host "Installing/Upgrading Package Manager Chocolatey." -BackgroundColor Green -ForegroundColor White
					#Install chocolatey
					Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
					#Upgrade chocolatey
					choco upgrade chocolatey
					choco install chocolatey-core.extension -y
					Write-Host "Installing/Updating .NET and VCREDIST." -BackgroundColor Green -ForegroundColor White
					#Udate powershell and winrm and .net
					choco upgrade powershell -y
					choco upgrade dotnetcore -y
					choco upgrade dotnet4.0 -y
					choco upgrade dotnet4.5 -y
					choco upgrade dotnet4.5.1 -y
					choco upgrade dotnet4.5.2 -y
					choco upgrade dotnet4.6.1 -y
					choco upgrade dotnet4.6.2 -y
					choco upgrade dotnet4.7 -y
					choco upgrade dotnet4.7.1 -y
					choco upgrade vcredist2012 -y
					choco upgrade vcredist2013 -y
					choco upgrade vcredist2015 -y
					choco upgrade vcredist2017 -y
			} '4' {
					Write-Host "Installing/Updating 3rd Party Applications." -BackgroundColor Green -ForegroundColor White
					#Install app broken up by line for easier editing. Comment any applications you do not wish to have.
					choco upgrade adobereader -y
					choco upgrade adobereader-update -y
					choco upgrade flashplayerplugin -y
					choco upgrade flashplayerppapi -y
					choco upgrade googlechrome -y
					choco upgrade jre8 -y
					choco upgrade firefoxesr -y
					choco upgrade 7zip.install -y
					choco upgrade adobeair -y
					choco upgrade vlc -y
					choco upgrade notepadplusplus.install -y
					choco upgrade git.install -y
					choco upgrade putty.install -y
					choco upgrade curl -y
					choco upgrade wget -y
					choco upgrade keepass.install -y
					choco upgrade treesizefree -y
					choco upgrade winscp -y
					choco upgrade audacity -y

					Write-Host "Finished!" -BackgroundColor Green -ForegroundColor White
					Read-Host "Press ENTER"

					#Extras just uncomment
					#choco install skype -y
					#choco upgrade rvtools -y
					#choco upgrade google-drive-file-stream -y
					#choco upgrade markdownmonster -y
					#choco upgrade geforce-experience -y
					#choco upgrade geforce-game-ready-driver
					#choco upgrade imageresizerapp -y
					#choco upgrade telegram.install -y
					#choco upgrade sharex -y
					#choco upgrade blender -y
					#choco upgrade virtualclonedrive -y
					#choco upgrade rdcman -y
					#choco upgrade windows-adk-all -y
					#choco upgrade citrix-receiver -y
					#choco upgrade inkscape -y
					#choco upgrade filezilla -y
					#choco upgrade paint.net -y
					#choco upgrade gimp -y
					#choco upgrade virtualbox -y
			 
            } '5' {
                cls
					Write-Host "Windows AppX Packages Installed Currently" -BackgroundColor Green -ForegroundColor White
					Get-AppXProvisionedPackage  -Online | Select PackageName
					Write-Host "Removing Junk" -BackgroundColor Green -ForegroundColor White
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.BingWeather_4.24.11294.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.Microsoft3DViewer_4.1804.19012.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.MicrosoftOfficeHub_2018.428.1013.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.Office.OneNote_2015.9330.20531.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.OneConnect_4.1805.1291.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.Print3D_2.0.10611.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.WindowsFeedbackHub_2018.425.657.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.XboxApp_41.41.18005.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.XboxGameOverlay_1.30.5001.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.XboxGamingOverlay_1.15.1001.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.XboxIdentityProvider_12.41.24002.0_neutral_~_8wekyb3d8bbwe
					Remove-AppXProvisionedPackage -Online -PackageName Microsoft.XboxSpeechToTextOverlay_1.21.13002.0_neutral_~_8wekyb3d8bbwe
					Write-Host "Windows AppX Packages Installed After Removal" -BackgroundColor Green -ForegroundColor White
					Get-AppXProvisionedPackage  -Online | Select PackageName               
					Write-Host "Installing SNMP." -BackgroundColor Green -ForegroundColor White
					#Install snmp feature
					Enable-WindowsOptionalFeature -online -norestart -FeatureName snmp
					Enable-WindowsOptionalFeature -online -norestart -FeatureName wmisnmpprovider
					Write-Host "Installing/Upgrading Package Manager Chocolatey." -BackgroundColor Green -ForegroundColor White
					#Install chocolatey
					Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
					#Upgrade chocolatey
					choco upgrade chocolatey
					choco install chocolatey-core.extension -y
					Write-Host "Installing/Updating .NET and VCREDIST." -BackgroundColor Green -ForegroundColor White
					#Udate powershell and winrm and .net
					choco upgrade powershell -y
					choco upgrade dotnetcore -y
					choco upgrade dotnet4.0 -y
					choco upgrade dotnet4.5 -y
					choco upgrade dotnet4.5.1 -y
					choco upgrade dotnet4.5.2 -y
					choco upgrade dotnet4.6.1 -y
					choco upgrade dotnet4.6.2 -y
					choco upgrade dotnet4.7 -y
					choco upgrade dotnet4.7.1 -y
					choco upgrade vcredist2012 -y
					choco upgrade vcredist2013 -y
					choco upgrade vcredist2015 -y
					choco upgrade vcredist2017 -y
					Write-Host "Installing/Updating 3rd Party Applications." -BackgroundColor Green -ForegroundColor White
					#Install app broken up by line for easier editing. Comment any applications you do not wish to have.
					choco upgrade adobereader -y
					choco upgrade adobereader-update -y
					choco upgrade flashplayerplugin -y
					choco upgrade flashplayerppapi -y
					choco upgrade googlechrome -y
					choco upgrade jre8 -y
					choco upgrade firefoxesr -y
					choco upgrade 7zip.install -y
					choco upgrade adobeair -y
					choco upgrade vlc -y
					choco upgrade notepadplusplus.install -y
					choco upgrade git.install -y
					choco upgrade putty.install -y
					choco upgrade curl -y
					choco upgrade wget -y
					choco upgrade keepass.install -y
					choco upgrade treesizefree -y
					choco upgrade winscp -y
					choco upgrade audacity -y

					Write-Host "Finished!" -BackgroundColor Green -ForegroundColor White
					Read-Host "Press ENTER"
					
            } 'q' {
                return
            }
     }
     pause
}
until ($input -eq 'q')
