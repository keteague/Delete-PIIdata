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
    https://github.com/keteague?tab=repositories
#>

##  File extensions we wish to look for
$extensions = "*.doc*", "*.xls*", "*.ppt*", "*.pdf", "*.csv", "*.txt"
##  Standard temporary directories
$tempdirs = "$env:SystemDrive\Windows\Temp", "$env:TEMP"
##  All Windows profile directories excluding Public
$profiles = (Get-ChildItem "$env:SystemDrive\Users").FullName -match "[^Public]"
##  Gather all of the directories above into a single variable so we can use a
##  single FOR loop
$paths = $tempdirs, $profiles

##  Brace yourself -- here we go!
ForEach ($path in $paths) {
    Get-ChildItem -Recurse -Path $path -Include $extensions | Remove-Item -Force -WhatIf
}