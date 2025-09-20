function Test-OSInfo {
    param([hashtable]$Exp, [hashtable]$Aud)
    $result = $true
    if (-not (Test-PropertyExists -Object $Aud -PropertyPath "Windows_Version.Caption")) { 
        $result = $false 
        $fail.Add("OS Information: Caption property not found in audit results")
    } elseif ($Aud.Windows_Version.Caption -ne $Exp.Windows_Version.Caption) { 
        $result = $false 
        $fail.Add("OS Information: Caption mismatch. Expected '$($Exp.Windows_Version.Caption)', Found '$($Aud.Windows_Version.Caption)'")
    }
    
    if (-not (Test-PropertyExists -Object $Aud -PropertyPath "Windows_Version.Version")) { 
        $result = $false 
        $fail.Add("OS Information: Version property not found in audit results")
    } elseif ($Aud.Windows_Version.Version -ne $Exp.Windows_Version.Version) { 
        $result = $false 
        $fail.Add("OS Information: Version mismatch. Expected '$($Exp.Windows_Version.Version)', Found '$($Aud.Windows_Version.Version)'")
    }
    
    if (-not (Test-PropertyExists -Object $Aud -PropertyPath "Windows_Version.OSArchitecture")) { 
        $result = $false 
        $fail.Add("OS Information: OSArchitecture property not found in audit results")
    } elseif ($Aud.Windows_Version.OSArchitecture -ne $Exp.Windows_Version.OSArchitecture) { 
        $result = $false 
        $fail.Add("OS Information: OSArchitecture mismatch. Expected '$($Exp.Windows_Version.OSArchitecture)', Found '$($Aud.Windows_Version.OSArchitecture)'")
    }
    
    return $result
}
