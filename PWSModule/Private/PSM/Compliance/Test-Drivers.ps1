function Test-Drivers {
    param(
        [array] $ExpDrivers,
        [array] $AudDrivers
    )
    $result = $true

    foreach ($driver in $ExpDrivers) {
        $audObj = $AudDrivers |
            Where-Object { $_.Driver -and $_.Driver.ToLower() -eq $driver.Driver.ToLower() } |
            Select-Object -First 1

        if (-not $audObj) {
            $result = $false
            $fail.Add("Drivers: Driver '$($driver.Driver)' not found")
            continue
        }

        $installedVersion = $audObj.Version
        if (-not $installedVersion) {
            $result = $false
            $fail.Add("Drivers: '$($driver.Driver)' has no version reported")
            continue
        }

        try {
            $audVer = [version]$installedVersion
        } catch {
            $result = $false
            $fail.Add("Drivers: Unable to parse installed version '$installedVersion' for driver '$($driver.Driver)'")
            continue
        }
        try {
            $expVer = [version]$driver.MinVersion
        } catch {
            $result = $false
            $fail.Add("Drivers: Unable to parse expected version '$($driver.MinVersion)' for driver '$($driver.Driver)'")
            continue
        }

        if ($audVer -ne $expVer) {
            $result = $false
            $fail.Add("Drivers: '$($driver.Driver)' version mismatch. Expected exactly $($driver.MinVersion), Found $installedVersion")
        }
    }

    return $result
}
