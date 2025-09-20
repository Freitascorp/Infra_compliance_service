function Test-DiskSpace {
    param([hashtable]$Exp, [array]$AudDisks)
    $result = $true
    foreach($drive in $Exp.Disk_Space.GetEnumerator()) {
        $audDisk = $AudDisks | Where-Object { $_.DeviceID -eq $drive.Key }
        if (-not $audDisk) {
            $result = $false
            $fail.Add("Disk Space: Disk '$($drive.Key)' not found in audit results")
        } elseif ([double]$audDisk.FreeSpaceGB -lt $drive.Value.MinFreeGB) {
            $result = $false
            $fail.Add("Disk Space: Disk '$($drive.Key)' free space mismatch. Expected at least $($drive.Value.MinFreeGB) GB, Found $($audDisk.FreeSpaceGB) GB")
        }
    }
    return $result
}
