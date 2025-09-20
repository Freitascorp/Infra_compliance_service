function Collect-PrivateArkInfo {
    $result = @{ Installed = $false }
    try {
        $pa = Get-ItemProperty -Path @(
            'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
            'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
        ) -ErrorAction SilentlyContinue |
        Where-Object DisplayName -like "*PrivateArk*"
        if ($pa) {
            $result.Installed = $true
            $result.Version   = $pa[0].DisplayVersion
        }
    } catch { }
    return $result
}

