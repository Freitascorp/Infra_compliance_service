function Test-AppLocker {
    param([hashtable]$Exp, [hashtable]$Aud)
    $result = $true
    if (-not (Test-PropertyExists -Object $Aud -PropertyPath "DEFAULT_PSM_PATH")) {
        $result = $false
        $fail.Add("AppLocker Settings: DEFAULT_PSM_PATH property not found in audit results")
    } elseif ($Aud.DEFAULT_PSM_PATH -ne $Exp.AppLocker_Script_Settings.DEFAULT_PSM_PATH) {
        $result = $false
        $fail.Add("AppLocker Settings: DEFAULT_PSM_PATH mismatch. Expected '$($Exp.AppLocker_Script_Settings.DEFAULT_PSM_PATH)', Found '$($Aud.DEFAULT_PSM_PATH)'")
    }

    if (-not (Test-PropertyExists -Object $Aud -PropertyPath "PSM_ADMIN_CONNECT")) {
        $result = $false
        $fail.Add("AppLocker Settings: PSM_ADMIN_CONNECT property not found in audit results")
    } elseif ($Aud.PSM_ADMIN_CONNECT -ne $Exp.AppLocker_Script_Settings.PSM_ADMIN_CONNECT) {
        $result = $false
        $fail.Add("AppLocker Settings: PSM_ADMIN_CONNECT mismatch. Expected '$($Exp.AppLocker_Script_Settings.PSM_ADMIN_CONNECT)', Found '$($Aud.PSM_ADMIN_CONNECT)'")
    }

    if (-not (Test-PropertyExists -Object $Aud -PropertyPath "PSM_CONNECT")) {
        $result = $false
        $fail.Add("AppLocker Settings: PSM_CONNECT property not found in audit results")
    } elseif ($Aud.PSM_CONNECT -ne $Exp.AppLocker_Script_Settings.PSM_CONNECT) {
        $result = $false
        $fail.Add("AppLocker Settings: PSM_CONNECT mismatch. Expected '$($Exp.AppLocker_Script_Settings.PSM_CONNECT)', Found '$($Aud.PSM_CONNECT)'")
    }

    return $result
}
