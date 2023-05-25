function Invoke-DiskCleanup {
    $sections = @(
        'Active Setup Temp Folders',
        'Delivery Optimization Files',
        'Device Driver Packages',
        'Memory Dump Files',
        'Old ChkDsk Files',
        'Previous Installations',
        'Service Pack Cleanup',
        'Setup Log Files',
        'System error memory dump files',
        'System error minidump files',
        'Update Cleanup',
        'Windows Error Reporting Archive Files',
        'Windows Error Reporting Queue Files',
        'Windows Error Reporting System Archive Files',
        'Windows Error Reporting System Queue Files',
        'Windows ESD installation files',
        'Windows Upgrade Log Files'
    )
    try {
        'Clearing previous disk cleanup settings for job 1'
        $getItemParams = @{
            Path        = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\*'
            Name        = 'StateFlags0001'
            ErrorAction = 'SilentlyContinue'
        }
        Get-ItemProperty @getItemParams | Remove-ItemProperty -Name StateFlags0001 -ErrorAction SilentlyContinue

        'Adding settings for job 1'
        foreach ($keyName in $sections) {
            $newItemParams = @{
                Path         = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$keyName"
                Name         = 'StateFlags0001'
                Value        = 1
                PropertyType = 'DWord'
                ErrorAction  = 'SilentlyContinue'
            }
            $null = New-ItemProperty @newItemParams
        }
        log 'Running cleanup'
        Start-Process -FilePath CleanMgr.exe -ArgumentList '/sagerun:1' -NoNewWindow -Wait

        log 'Waiting for termination'
        Get-Process -Name cleanmgr, dismhost -ErrorAction SilentlyContinue | Wait-Process
        Get-FreeSpace
    } catch { log 'Something went wrong with disk cleanup. Anyway...'; log $_ }
}

Invoke-DiskCleanup