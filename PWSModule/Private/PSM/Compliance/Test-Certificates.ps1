function Test-Certificates {
    param(
        [array] $ExpCerts,
        [array] $AllCertificates
    )
    $result = $true

    foreach ($cert in $ExpCerts) {
        $pattern = $cert.SubjectPattern
        $matches = $AllCertificates | Where-Object { $_.Subject -like $pattern }

        if (-not $matches) {
            $result = $false
            $fail.Add("Certificates: No certificate matching pattern '$pattern' was found")
            continue
        }

        $certObj = $matches[0]

        $expVal = $certObj.Expiration
        if ($expVal -is [System.Collections.IEnumerable] -and -not ($expVal -is [string])) {
            $expVal = $expVal[0]
        }

        if (-not $expVal -or [string]::IsNullOrWhiteSpace($expVal)) {
            continue
        }

        try {
            $expiry = [datetime]$expVal
        } catch {
            $result = $false
            $fail.Add("Certificates: Unable to parse expiration '$expVal' for certificate matching '$pattern'")
            continue
        }

        $daysRemaining = ($expiry - (Get-Date)).Days
        if ($daysRemaining -lt $cert.MinDaysToExpire) {
            $result = $false
            $fail.Add("Certificates: Certificate matching '$pattern' expires in $daysRemaining days (expected ≥ $($cert.MinDaysToExpire) days)")
        }
    }

    return $result
}
