function Test-Services {
    param([hashtable]$Exp, [hashtable]$Aud)
    if (-not (Test-PropertyExists -Object $Aud -PropertyPath "PSM_Service.PSM_ServiceStatus")) { 
        $fail.Add("Services: PSM_ServiceStatus property not found in audit results")
        return $false 
    }
    if ($Aud.PSM_Service.PSM_ServiceStatus -ne $Exp.PSM_Service.PSM_ServiceStatus) { 
        $fail.Add("Services: Service status mismatch. Expected '$($Exp.PSM_Service.PSM_ServiceStatus)', Found '$($Aud.PSM_Service.PSM_ServiceStatus)'")
        return $false 
    }
    return $true
}
