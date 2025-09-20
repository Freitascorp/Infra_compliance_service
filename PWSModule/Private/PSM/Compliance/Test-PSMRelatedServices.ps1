function Test-PSMRelatedServices {
    param(
        [array] $ExpServices,
        [array] $AudServices
    )
    $result = $true

    foreach ($exp in $ExpServices) {
        $aud = $AudServices |
            Where-Object { $_.Name -eq $exp.Name } |
            Select-Object -First 1

        if (-not $aud) {
            $result = $false
            $fail.Add("PSM Related Services: Service '$($exp.Name)' not found")
            continue
        }

        if ($aud.DisplayName -ne $exp.DisplayName) {
            $result = $false
            $fail.Add("PSM Related Services: DisplayName mismatch for '$($exp.Name)'. Expected '$($exp.DisplayName)', Found '$($aud.DisplayName)'")
        }

        if ($aud.Status -ne $exp.Status) {
            $result = $false
            $fail.Add("PSM Related Services: Status mismatch for '$($exp.Name)'. Expected '$($exp.Status)', Found '$($aud.Status)'")
        }
    }

    return $result
}
