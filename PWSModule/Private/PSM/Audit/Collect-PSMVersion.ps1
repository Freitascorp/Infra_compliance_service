function Collect-PSMVersion {
    $version = "Unknown"
    try {
        $regPaths = @(
            "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
            "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
        )
        foreach ($regPath in $regPaths) {
            $apps = Get-ChildItem $regPath -ErrorAction SilentlyContinue |
                    ForEach-Object { Get-ItemProperty $_.PSPath } |
                    Where-Object { $_.DisplayName -like "CyberArk Privileged Session Manager*" }
            if ($apps) {
                $version = $apps[0].DisplayVersion
                break
            }
        }
    } catch { }

    if ($version -eq "Unknown") {
        $psmConsoleLog = "E:\Cyberark\PSM\PSMConsole.log"
        if (Test-Path $psmConsoleLog) {
            $firstLine = Select-String -Path $psmConsoleLog -Pattern "PSM Version" -SimpleMatch |
                         Select-Object -First 1
            if ($firstLine -and $firstLine.Line -match "PSM Version\s*\[([^\]]+)\]") {
                $version = $matches[1]
            }
        }
    }

    Write-Host "Detected PSM Version: $version"
    return $version
}
