function Test-InstalledApps {
    param(
        [array] $ExpApps,
        [array] $AudApps
    )
    $result = $true

    foreach ($app in $ExpApps) {
        $audObj = $AudApps |
            Where-Object { $_.DisplayName -and $_.DisplayName.ToLower() -eq $app.DisplayName.ToLower() } |
            Select-Object -First 1

        if (-not $audObj) {
            $result = $false
            $fail.Add("Installed Applications: Application '$($app.DisplayName)' not found")
            continue
        }

        $installedVersion = $audObj.DisplayVersion
        if (-not $installedVersion) {
            $result = $false
            $fail.Add("Installed Applications: '$($app.DisplayName)' has no version reported")
            continue
        }

        try {
            $audVer = [version]$installedVersion
        } catch {
            $result = $false
            $fail.Add("Installed Applications: Unable to parse installed version '$installedVersion' for '$($app.DisplayName)'")
            continue
        }
        try {
            $expVer = [version]$app.MinVersion
        } catch {
            $result = $false
            $fail.Add("Installed Applications: Unable to parse expected version '$($app.MinVersion)' for '$($app.DisplayName)'")
            continue
        }

        if ($audVer -ne $expVer) {
            $result = $false
            $fail.Add(
                "Installed Applications: '$($app.DisplayName)' version mismatch. " +
                "Expected exactly $($app.MinVersion), Found $installedVersion"
            )
        }
    }

    return $result
}
