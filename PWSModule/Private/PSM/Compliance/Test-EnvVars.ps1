function Test-EnvVars {
    param(
        [Parameter(Mandatory)]
        [hashtable]$ExpEnvVars,

        [Parameter(Mandatory)]
        [hashtable]$AudVars
    )

    # Assume pass until proven otherwise
    $result = $true

    # Iterate each expected variable
    foreach ($key in $ExpEnvVars.Keys) {
        $expectedValue = $ExpEnvVars[$key]

        if (-not $AudVars.ContainsKey($key)) {
            $result = $false
            $fail.Add("Environment Variables: Missing variable '$key'")
            continue
        }

        $actualValue = $AudVars[$key]

        # If expected value is itself a hashtable => treat as "Contains" rule
        if ($expectedValue -is [hashtable] -and $expectedValue.ContainsKey('Contains')) {
            $fragment = $expectedValue['Contains']
            if ($actualValue -notlike "*$fragment*") {
                $result = $false
                $fail.Add("Environment Variables: '$key' does not contain expected fragment '$fragment'")
            }
        }
        else {
            # Otherwise require exact match
            if ($actualValue -ne $expectedValue) {
                $result = $false
                $fail.Add("Environment Variables: '$key' mismatch. Expected '$expectedValue', Found '$actualValue'")
            }
        }
    }

    return $result
}

