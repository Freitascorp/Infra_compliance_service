function Collect-ComponentsVersion {
    param([string]$ComponentsFolder = 'E:\CyberArk\PSM\Components')
    if (-not (Test-Path $ComponentsFolder)) { return }

    return Get-ChildItem -Path $ComponentsFolder -Recurse -Include *.exe,*.dll -File -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notlike "$ComponentsFolder\Connectors\*" } |
        ForEach-Object {
            $v = $_.VersionInfo.FileVersion
            if ([string]::IsNullOrWhiteSpace($v)) { $v = 'not versioned' }
            [PSCustomObject]@{
                Name         = $_.Name
                Path         = $_.FullName
                Version      = $v
                LastModified = $_.LastWriteTime
            }
        }
}

