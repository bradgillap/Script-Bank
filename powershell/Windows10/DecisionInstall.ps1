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
				# Functions
				function Write-LogEntry {
					param(
						[parameter(Mandatory=$true, HelpMessage="Value added to the RemovedApps.log file.")]
						[ValidateNotNullOrEmpty()]
						[string]$Value,

						[parameter(Mandatory=$false, HelpMessage="Name of the log file that the entry will written to.")]
						[ValidateNotNullOrEmpty()]
						[string]$FileName = "RemovedApps.log"
					)
					# Determine log file location
					$LogFilePath = Join-Path -Path $env:windir -ChildPath "Temp\$($FileName)"

					# Add value to log file
					try {
						Out-File -InputObject $Value -Append -NoClobber -Encoding Default -FilePath $LogFilePath -ErrorAction Stop
					}
					catch [System.Exception] {
						Write-Warning -Message "Unable to append log entry to RemovedApps.log file"
					}
				}

				# Get a list of all apps
				Write-LogEntry -Value "Starting built-in AppxPackage, AppxProvisioningPackage and Feature on Demand V2 removal process"
				$AppArrayList = Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Select-Object -Property Name, PackageFullName | Sort-Object -Property Name

				# White list of appx packages to keep installed
				$WhiteListedApps = @(
					"Microsoft.DesktopAppInstaller", 
					"Microsoft.Messaging", 
					"Microsoft.MSPaint",
					"Microsoft.Windows.Photos",
					"Microsoft.StorePurchaseApp",
					"Microsoft.MicrosoftOfficeHub",
					"Microsoft.MicrosoftStickyNotes",
					"Microsoft.WindowsAlarms",
					"Microsoft.WindowsCalculator", 
					"Microsoft.WindowsCommunicationsApps", # Mail, Calendar etc
					"Microsoft.WindowsSoundRecorder", 
					"Microsoft.WindowsStore"
				)

				# Loop through the list of appx packages
				foreach ($App in $AppArrayList) {
					# If application name not in appx package white list, remove AppxPackage and AppxProvisioningPackage
					if (($App.Name -in $WhiteListedApps)) {
						Write-LogEntry -Value "Skipping excluded application package: $($App.Name)"
					}
					else {
						# Gather package names
						$AppPackageFullName = Get-AppxPackage -Name $App.Name | Select-Object -ExpandProperty PackageFullName -First 1
						$AppProvisioningPackageName = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $App.Name } | Select-Object -ExpandProperty PackageName -First 1

						# Attempt to remove AppxPackage
						if ($AppPackageFullName -ne $null) {
							try {
								Write-LogEntry -Value "Removing AppxPackage: $($AppPackageFullName)"
								Remove-AppxPackage -Package $AppPackageFullName -ErrorAction Stop | Out-Null
							}
							catch [System.Exception] {
								Write-LogEntry -Value "Removing AppxPackage '$($AppPackageFullName)' failed: $($_.Exception.Message)"
							}
						}
						else {
							Write-LogEntry -Value "Unable to locate AppxPackage: $($AppPackageFullName)"
						}

						# Attempt to remove AppxProvisioningPackage
						if ($AppProvisioningPackageName -ne $null) {
							try {
								Write-LogEntry -Value "Removing AppxProvisioningPackage: $($AppProvisioningPackageName)"
								Remove-AppxProvisionedPackage -PackageName $AppProvisioningPackageName -Online -ErrorAction Stop | Out-Null
							}
							catch [System.Exception] {
								Write-LogEntry -Value "Removing AppxProvisioningPackage '$($AppProvisioningPackageName)' failed: $($_.Exception.Message)"
							}
						}
						else {
							Write-LogEntry -Value "Unable to locate AppxProvisioningPackage: $($AppProvisioningPackageName)"
						}
					}
				}

				# White list of Features On Demand V2 packages
				Write-LogEntry -Value "Starting Features on Demand V2 removal process"
				$WhiteListOnDemand = "NetFX3|Tools.Graphics.DirectX|Tools.DeveloperMode.Core|Language|Browser.InternetExplorer|ContactSupport|OneCoreUAP|Media.WindowsMediaPlayer"

				# Get Features On Demand that should be removed
				try {
					$OSBuildNumber = Get-WmiObject -Class "Win32_OperatingSystem" | Select-Object -ExpandProperty BuildNumber

					# Handle cmdlet limitations for older OS builds
					if ($OSBuildNumber -le "16299") {
						$OnDemandFeatures = Get-WindowsCapability -Online -ErrorAction Stop | Where-Object { $_.Name -notmatch $WhiteListOnDemand -and $_.State -like "Installed"} | Select-Object -ExpandProperty Name
					}
					else {
						$OnDemandFeatures = Get-WindowsCapability -Online -LimitAccess -ErrorAction Stop | Where-Object { $_.Name -notmatch $WhiteListOnDemand -and $_.State -like "Installed"} | Select-Object -ExpandProperty Name
					}

					foreach ($Feature in $OnDemandFeatures) {
						try {
							Write-LogEntry -Value "Removing Feature on Demand V2 package: $($Feature)"

							# Handle cmdlet limitations for older OS builds
							if ($OSBuildNumber -le "16299") {
								Get-WindowsCapability -Online -ErrorAction Stop | Where-Object { $_.Name -like $Feature } | Remove-WindowsCapability -Online -ErrorAction Stop | Out-Null
							}
							else {
								Get-WindowsCapability -Online -LimitAccess -ErrorAction Stop | Where-Object { $_.Name -like $Feature } | Remove-WindowsCapability -Online -ErrorAction Stop | Out-Null
							}
						}
						catch [System.Exception] {
							Write-LogEntry -Value "Removing Feature on Demand V2 package failed: $($_.Exception.Message)"
						}
					}    
				}
				catch [System.Exception] {
					Write-LogEntry -Value "Attempting to list Feature on Demand V2 packages failed: $($_.Exception.Message)"
				}

				# Complete
Write-LogEntry -Value "Completed built-in AppxPackage, AppxProvisioningPackage and Feature on Demand V2 removal process"
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
					choco upgrade googlechrome -y
					choco upgrade chocolatey-core.extension -y
					
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
					choco upgrade gimp -y
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
