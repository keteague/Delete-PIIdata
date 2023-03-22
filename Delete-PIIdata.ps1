#REQUIRES -Version 2.0
#REQUIRES -RunAsAdministrator

<#
.SYNOPSIS
  Delete PII data
.DESCRIPTION
  Locate and delete specific file types in specific paths that can 
  potentially contain Personal Identifiable Information.
.NOTES
  File Name      : Delete-PIIdata.ps1
  Author         : Ken Teague <ken at onxinc dot com>
  Prerequisite   : PowerShell v2 or higher
.LINK
  https://github.com/keteague/Delete-PIIdata
#>


# Set variables
$include = "*.doc","*.docx","*.xls","*.xlsx","*.ppt","*.pptx","*.pdf","*.csv","*.txt"
$logFile = "$env:SYSTEMDRIVE\Temp\DeletePIIdata_$(Get-Date -Format 'yyyy-MM-dd@HHmm').log"
$excludePath = "$env:SYSTEMDRIVE\Users\Public"
$excludeFolders = "*OneDrive*"

# Create $env:SYSTEMDRIVE\Temp if it does not exist
if (!(Test-Path "$env:SYSTEMDRIVE\Temp")) {
    New-Item -ItemType Directory -Path "$env:SYSTEMDRIVE\Temp"
}

# Define function to log data
function Write-Log {
    Param ([string]$logText)
    $logTime = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Add-Content $logFile -Value "$logTime  $logText"
}

# Delete files in $env:SYSTEMDRIVE\Users (excluding $excludePath and folders containing $excludeFolders) and log data
Write-Log "Deleting files in $env:SYSTEMDRIVE\Users (excluding $excludePath)"
Get-ChildItem -Path "$env:SYSTEMDRIVE\Users" -Recurse -Include $include | Where-Object { $_.FullName -notlike $excludePath -and $_.FullName -notlike $excludeFolders } | Sort-Object $_.FullName | ForEach-Object {
    Remove-Item $_.FullName -Force
    Write-Log "$_.Fullname"
}


# Delete files in $env:WINDIR\Temp and $env:TEMP and log data
$paths = "$env:WINDIR\Temp","$env:TEMP"
$paths | ForEach-Object {
    Write-Log "Deleting files in $_"
    Get-ChildItem -Path $_ -Recurse -Include $include | Sort-Object $_.FullName | ForEach-Object {
        Remove-Item $_.FullName -Force
        Write-Log "$($_.FullName)"
    }
}


# Notify completion
Write-Log "Script execution completed."
