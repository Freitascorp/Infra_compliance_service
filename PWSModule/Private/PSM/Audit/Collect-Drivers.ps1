function Collect-Drivers {
    param([string]$ComponentsFolder = 'E:\CyberArk\PSM\Components')

    if (-not (Test-Path $ComponentsFolder)) { return }

    $drivers = 'chromedriver.exe','msedgedriver.exe'
    $results = @()

    foreach ($d in $drivers) {
        $f = Get-ChildItem -Path $ComponentsFolder -Recurse -Filter $d -ErrorAction SilentlyContinue | Select-Object -First 1
        if (-not $f) {
            $results += [PSCustomObject]@{ Driver=$d; Path=$null; Version=$null; LastModified=$null; Error="Not found" }
            continue
        }

        $ver = $f.VersionInfo.FileVersion
        if ($d -ieq 'chromedriver.exe' -and [string]::IsNullOrWhiteSpace($ver)) {
            try {
                $out = & $f.FullName --version 2>&1
                if ($out -match '(\d+\.\d+\.\d+\.\d+)') { $ver = $matches[1] } else { $ver = 'Unknown' }
            } catch { $ver = 'Unknown' }
        }

        $results += [PSCustomObject]@{
            Driver       = $d
            Path         = $f.FullName
            Version      = $ver
            LastModified = $f.LastWriteTime
        }
    }

    return $results
}


