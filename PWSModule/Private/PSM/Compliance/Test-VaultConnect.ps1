function Test-VaultConnect {
    param(
        [Parameter(Mandatory)][psobject] $Exp,   # expected block (hashtable)
        [Parameter(Mandatory)][psobject] $Aud    # audit block: PSCustomObject or array
    )

    # Normalize to an array of objects
    $audList = if ($Aud -is [System.Collections.IEnumerable] -and -not ($Aud -is [string])) {
        $Aud
    } else {
        ,$Aud
    }

    # Find the Primary vault entry
    $primary = $audList | Where-Object { $_.Role -eq 'Primary' } | Select-Object -First 1
    if (-not $primary) {
        $fail.Add("Vault Connectivity: No entry with Role='Primary' found")
        return $false
    }

    $result = $true

    # 1) PingStatus
    if (-not $primary.PingStatus) {
        $result = $false
        $fail.Add("Vault Connectivity: Primary entry missing PingStatus")
    }
    elseif ($primary.PingStatus -ne $Exp.PingStatus) {
        $result = $false
        $fail.Add("Vault Connectivity: Primary PingStatus mismatch. Expected '$($Exp.PingStatus)', Found '$($primary.PingStatus)'")
    }

    # 2) Role (sanity check)
    if ($primary.Role -ne $Exp.Role) {
        $result = $false
        $fail.Add("Vault Connectivity: Primary Role mismatch. Expected '$($Exp.Role)', Found '$($primary.Role)'")
    }

    return $result
}


