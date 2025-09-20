function Collect-DiskSpace {
    $diskInfo = @()
    try {
        $disks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"
        foreach ($disk in $disks) {
            $diskInfo += @{
                DeviceID    = $disk.DeviceID
                VolumeName  = $disk.VolumeName
                FreeSpaceGB = [math]::Round($disk.FreeSpace / 1GB, 2)
                SizeGB      = [math]::Round($disk.Size / 1GB, 2)
            }
        }
    } catch {
        return "Error retrieving disk space info"
    }
    return $diskInfo
}
