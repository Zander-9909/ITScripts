$Name = "Dell Command | Update"
$Timestamp = Get-Date -Format "yyyy-MM-dd_THHmmss"
$LogFile = "$env:TEMP\Dell-CU-Uninst_$Timestamp.log"
$ProgramList = @( "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" )
$Programs = Get-ItemProperty $ProgramList -ErrorAction SilentlyContinue
$App = ($Programs | Where-Object { $_.DisplayName -eq $Name -and $_.UninstallString -like "*msiexec*" }).PSChildName

Get-Process | ? {$_.ProcessName -eq "DellCommandUpdate"} | Stop-Process -Force

$Params = @(
    "/qn"
    "/norestart"
    "/X"
	"$App"
	"/L*V ""$LogFile"""
)

Start-Process "msiexec.exe" -ArgumentList $Params -Wait -NoNewWindow