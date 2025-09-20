function Test-Hardening_Script {
    param([hashtable]$Exp, [hashtable]$Aud)
    $result = $true

    if (-not (Test-PropertyExists -Object $Aud -PropertyPath "SUPPORT_WEB_APPLICATIONS")) {
        $result = $false
        $fail.Add("Security Hardening: SUPPORT_WEB_APPLICATIONS property not found in audit results")
    } elseif ($Aud.SUPPORT_WEB_APPLICATIONS -ne $Exp.Hardening_Settings.SUPPORT_WEB_APPLICATIONS) {
        $result = $false
        $fail.Add("Security Hardening: SUPPORT_WEB_APPLICATIONS mismatch. Expected '$($Exp.Hardening_Settings.SUPPORT_WEB_APPLICATIONS)', Found '$($Aud.SUPPORT_WEB_APPLICATIONS)'")
    }

    if (-not (Test-PropertyExists -Object $Aud -PropertyPath "PSM_ADMIN_CONNECT_USER")) {
        $result = $false
        $fail.Add("Security Hardening: PSM_ADMIN_CONNECT_USER property not found in audit results")
    } elseif ($Aud.PSM_ADMIN_CONNECT_USER -ne $Exp.Hardening_Settings.PSM_ADMIN_CONNECT_USER) {
        $result = $false
        $fail.Add("Security Hardening: PSM_ADMIN_CONNECT_USER mismatch. Expected '$($Exp.Hardening_Settings.PSM_ADMIN_CONNECT_USER)', Found '$($Aud.PSM_ADMIN_CONNECT_USER)'")
    }

    if (-not (Test-PropertyExists -Object $Aud -PropertyPath "PSM_CONNECT_USER")) {
        $result = $false
        $fail.Add("Security Hardening: PSM_CONNECT_USER property not found in audit results")
    } elseif ($Aud.PSM_CONNECT_USER -ne $Exp.Hardening_Settings.PSM_CONNECT_USER) {
        $result = $false
        $fail.Add("Security Hardening: PSM_CONNECT_USER mismatch. Expected '$($Exp.Hardening_Settings.PSM_CONNECT_USER)', Found '$($Aud.PSM_CONNECT_USER)'")
    }

    return $result
}
