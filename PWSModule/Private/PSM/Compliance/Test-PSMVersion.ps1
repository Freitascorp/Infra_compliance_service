function Test-PSMVersion {
    param([hashtable]$Exp, [hashtable]$Aud)
    if (-not (Test-PropertyExists -Object $Aud -PropertyPath "PSM_Version")) { 
        $fail.Add("PSM Version: PSM_Version property not found in audit results")
        return $false 
    }
    if ($Aud.PSM_Version -ne $Exp.PSM_Version.Version) { 
        $fail.Add("PSM Version: Version mismatch. Expected '$($Exp.PSM_Version.Version)', Found '$($Aud.PSM_Version)'")
        return $false 
    }
    return $true
}
