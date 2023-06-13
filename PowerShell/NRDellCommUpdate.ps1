#Powershell script to download Dell Command | Update version 4.8 and install it, then run patches WITHOUT REBOOTING
#Uninstall Dell Command | Update for Windows 10
#Removes the Windows 10 and any old update versions if they exist
start-process -FilePath msiexec.exe -ArgumentList "/x $((Get-Package | Where-Object {$_.Name -like "Dell Command | Update for Windows 10"}).fastpackagereference) /qn /norestart" -wait
start-process -FilePath msiexec.exe -ArgumentList "/x $((Get-Package | Where-Object {$_.Name -like "Dell Command | Update*" -and $_.Version -lt 4.8}).fastpackagereference) /qn /norestart" -wait

Write-Output "Removal of old versions completed"

cmd /c mkdir C:\Temp

# Copy files

$Location = "Dell"
# $Producttoinstall = "Dell-Command-Update-Windows-Universal-Application_601KT_WIN_4.5.0_A00_01.exe"
# $Producttoinstall = "Dell-Command-Update-Application_034D2_WIN_4.6.0_A00.EXE"
$Producttoinstall = "Dell-Command-Update-Application_714J9_WIN_4.8.0_A00.EXE"

#$OutputFolder = 

cmd /c del "C:\Temp\*" /q

#Edited to mask curl urls
cmd /c curl -k "Software" -o "C:\Temp\$Producttoinstall"

get-childitem "C:\Temp" | unblock-file

cmd /c C:\Temp\$Producttoinstall /s /f /l=C:\Temp\DCU_install.log

cmd /c timeout -t 5

Write-Output "Install completed"


# Start the service

Set-Service -Name "DellClientManagementService" -Status running -StartupType automatic

cmd /c timeout -t 5

# Settings

$Folder = "C:\Program Files (x86)\Dell\CommandUpdate"

if (Test-Path -Path $Folder) {

# 32 bit install

cd "C:\Program Files (x86)\Dell\CommandUpdate"

cmd /c dcu-cli.exe /configure -scheduleauto 
# cmd /c dcu-cli.exe /configure -scheduleAction=DownloadAndNotify
cmd /c dcu-cli.exe /configure -scheduleAction=DownloadInstallAndNotify
cmd /c dcu-cli.exe /configure -scheduledreboot=30
cmd /c dcu-cli.exe /configure -scheduleDeferUpdates=1
# cmd /c dcu-cli.exe /scan -silent
cmd /c dcu-cli.exe /applyUpdates -silent
cmd /c dcu-cli.exe /configure -systemRestartDeferral=enable -deferralRestartInterval=2 -deferralRestartCount=3


} else {

# 64 bit install

cd "C:\Program Files\Dell\CommandUpdate"

cmd /c dcu-cli.exe /configure -scheduleauto 
# cmd /c dcu-cli.exe /configure -scheduleAction=DownloadAndNotify
cmd /c dcu-cli.exe /configure -scheduleAction=DownloadInstallAndNotify
cmd /c dcu-cli.exe /configure -scheduledreboot=30
cmd /c dcu-cli.exe /configure -scheduleDeferUpdates=1
# cmd /c dcu-cli.exe /scan -silent
cmd /c dcu-cli.exe /applyUpdates -silent
cmd /c dcu-cli.exe /configure -systemRestartDeferral=enable -deferralRestartInterval=2 -deferralRestartCount=3

}

# Cleanup

cmd /c timeout -t 5

cd C:\Temp

cmd /c del C:\Temp\$Producttoinstall

Write-Output "Cleanup Completed"