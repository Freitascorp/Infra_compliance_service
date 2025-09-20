function Test-GPOs {
    param([array]$ExpGPOs, [array]$AudGPOs)
    $result = $true
    foreach($gpo in $ExpGPOs.Required) {
        if (-not ($AudGPOs -contains $gpo)) {
            $result = $false
            $fail.Add("Group Policies: GPO '$gpo' not applied")
        }
    }
    return $result
}
