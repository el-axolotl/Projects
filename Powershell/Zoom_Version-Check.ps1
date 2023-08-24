# Update the software name and version number for each application
$software = "Zoom"
$packageVer = "5.8.1736"

# Do not change
$paths = @("HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall", 
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall")

Foreach ($path in $paths) {
    $apps = Get-ChildItem -Path $path |
    ForEach-Object { Get-ItemProperty $_.PSPath } |
    Where-Object { $_.DisplayName -match $software } |
    Select-Object -Property DisplayName, DisplayVersion

    Foreach ($app in $apps) {
        $currentVer = $app.DisplayVersion

        If ($currentVer -lt $packageVer) {
            Write-Output "Install"
            Exit
        }
    }
}