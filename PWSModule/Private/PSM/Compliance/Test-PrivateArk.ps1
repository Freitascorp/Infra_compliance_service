function Test-PrivateArk {
    param([hashtable]$Exp, [hashtable]$Aud)
    $result = $true

    if (-not (Test-PropertyExists -Object $Aud -PropertyPath "Installed")) {
        $result = $false
        $fail.Add("PrivateArk Client: Installed property not found in audit results")
    } elseif (-not $Aud.Installed) {
        $result = $false
        $fail.Add("PrivateArk Client: Client not installed")
    }

    if (-not (Test-PropertyExists -Object $Aud -PropertyPath "Version")) {
        $result = $false
        $fail.Add("PrivateArk Client: Version property not found in audit results")
    } elseif ($Aud.Version -ne $Exp.PrivateArk_Client.Version) {
        $result = $false
        $fail.Add("PrivateArk Client: Version mismatch. Expected '$($Exp.PrivateArk_Client.Version)', Found '$($Aud.Version)'")
    }

    return $result
}
