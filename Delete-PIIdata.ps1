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

$extensions = "*.doc*", "*.xls*", "*.ppt*", "*.pdf", "*.csv", "*.txt"
$tempdirs = "$env:SystemDrive\Windows\Temp", "$env:TEMP"
$profiles = (Get-ChildItem "$env:SystemDrive\Users").FullName -match "^(?!.*Public)"
$paths = $tempdirs, $profiles

ForEach ($path in $paths) {
    Get-ChildItem -Recurse -Path $path -Include $extensions | Remove-Item -Force -WhatIf
}
