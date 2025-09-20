function Test-VaultFile {
    param(
        [hashtable] $Exp,
        [hashtable] $Aud
    )
    $result = $true

    if (-not $Aud.Path) {
        $result = $false
        $fail.Add("Vault Credential File: Path property not found in audit results")
    }
    elseif ($Aud.Path -ne $Exp.Path) {
        $result = $false
        $fail.Add("Vault Credential File: Path mismatch. Expected '$($Exp.Path)', Found '$($Aud.Path)'")
    }

    if ($result) {
        if (-not $Aud.LastModified) {
            $result = $false
            $fail.Add("Vault Credential File: LastModified property not found in audit results")
        } else {
            try {
                $lastMod = [datetime]$Aud.LastModified
            } catch {
                $result = $false
                $fail.Add("Vault Credential File: Unable to parse LastModified '$($Aud.LastModified)'")
            }

            if ($result) {
                $ageDays = (Get-Date) - $lastMod
                if ($ageDays.Days -gt $Exp.MaxAgeDays) {
                    $result = $false
                    $fail.Add("Vault Credential File: File age $($ageDays.Days) days exceeds max $($Exp.MaxAgeDays) days")
                }
            }
        }
    }

    return $result
}
