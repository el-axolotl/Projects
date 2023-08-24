<#   
.SYNOPSIS   
Script that returns the Registy Key Path for the Software Name you pass as a parameter.
     
.PARAMETER Software
The Software whose Registry Key Path you need.

.NOTES   
Name: Get-RegistyKeyInfo.ps1
Author: Christopher Munoz
DateCreated: 04/16/2020
.EXAMPLE
	.\Get-RegistryKeyInfo.ps1 -Software "Google Chrome"
#>

param(
    [string]$Software
)

$PATHS = @("HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
               "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall")

ForEach ($path in $PATHS) {
    $installed = Get-ChildItem -Path $path |
        ForEach { Get-ItemProperty $_.PSPath } |
        Where-Object { $_.DisplayName -match $Software } |
        Select-Object -Property DisplayName, DisplayVersion, PSPath, UninstallString

    ForEach ($app in $installed) {
        If ($app) {
            $displayName = "$($app.DisplayName)"
            $displayVersion = "$($app.DisplayVersion)"
            $key = "$($app.PSPath)"
            $uninstall = "$($app.UninstallString)"
            $key = $key.Substring(36)

            Write-Host "SOFTWARE:" $displayName
            Write-Host "VERSION:" $displayVersion
            Write-Host "REGISTRY KEY:" $key
            Write-Host "UNINSTALL STRING:" $uninstallString
        }
    }
}