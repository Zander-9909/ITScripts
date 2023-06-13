$manufacturer = (gwmi win32_computersystem).Manufacturer
"this pc is a $manufacturer PC"

if ($manufacturer -like "Dell*"){
    #do stuff here
    Write-Output ("this must be a dell!")
}

$chkIfInstalled=(Get-Package | Where-Object {($_.Name -like "Dell Command | Update"-or $_.Name -like "Dell Command | Update for Windows Universal") -and $_.Version -ge 4.8}).fastpackagereference
Write-Output $chkIfInstalled
if($null -ne $chkIfInstalled ) {
    Write-Output "Hi"
}