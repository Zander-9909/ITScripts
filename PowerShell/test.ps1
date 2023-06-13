$ver = Get-Package | Where-Object {$_.Name -like "Dell Command | Update*"}
$ifLE48 = Get-Package | Where-Object {$_.Name -like "Dell Command | Update*" -and $_.Version -lt 4.8}

Write-Output $ver.Version >= 4.8
Write-Output $ifLE48

start-process -FilePath msiexec.exe -ArgumentList "/x $((Get-Package | Where-Object {$_.Name -like "Dell Command | Update for Windows 10"}).fastpackagereference) /qn /norestart"
start-process -FilePath msiexec.exe -ArgumentList "/x $((Get-Package | Where-Object {$_.Name -like "Dell Command | Update*" -and $_.Version -lt 4.8}).fastpackagereference) /qn /norestart"