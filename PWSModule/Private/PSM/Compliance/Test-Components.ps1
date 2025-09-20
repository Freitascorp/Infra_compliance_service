function Test-Components {
    param(
        [array] $ExpComponents,
        [array] $AudComponents
    )
    $result = $true

    foreach ($comp in $ExpComponents) {
        $audObj = $AudComponents |
            Where-Object { $_.Name -and $_.Name.ToLower() -eq $comp.Name.ToLower() } |
            Select-Object -First 1

        if (-not $audObj) {
            $result = $false
            $fail.Add("Components Version: Component '$($comp.Name)' not found")
            continue
        }

        $installedVersion = $audObj.Version
        if (-not $installedVersion) {
            $result = $false
            $fail.Add("Components Version: '$($comp.Name)' has no version reported")
            continue
        }

        try {
            $audVer = [version]$installedVersion
        } catch {
            $result = $false
            $fail.Add("Components Version: Unable to parse installed version '$installedVersion' for '$($comp.Name)'")
            continue
        }
        try {
            $expVer = [version]$comp.MinVersion
        } catch {
            $result = $false
            $fail.Add("Components Version: Unable to parse expected version '$($comp.MinVersion)' for '$($comp.Name)'")
            continue
        }

        if ($audVer -ne $expVer) {
            $result = $false
            $fail.Add("Components Version: '$($comp.Name)' version mismatch. Expected exactly $($comp.MinVersion), Found $installedVersion")
        }
    }

    return $result
}
