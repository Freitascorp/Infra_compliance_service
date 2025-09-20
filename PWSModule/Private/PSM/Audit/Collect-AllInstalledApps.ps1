function Collect-AllInstalledApps {
    $uninstallPaths = @(
        'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
    $apps = Get-ItemProperty -Path $uninstallPaths -ErrorAction SilentlyContinue |
            Select-Object DisplayName,DisplayVersion,Publisher,InstallDate |
            Where-Object DisplayName |
            Sort-Object DisplayName

    return $apps | ForEach-Object {
        [PSCustomObject]@{
            DisplayName    = $_.DisplayName
            DisplayVersion = $_.DisplayVersion
            Publisher      = $_.Publisher
            InstallDate    = $_.InstallDate
        }
    }
}

