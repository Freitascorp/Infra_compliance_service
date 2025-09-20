function Collect-FolderPermissions {
    [CmdletBinding()]
    param ()

    $folders = @{
        PSMFolder_Permissions           = "E:\Cyberark\PSM"
        PSMRecordingsFolder_Permissions = "E:\Cyberark\PSM\Recordings"
        PSMComponentsFolder_Permissions = "E:\CyberArk\PSM\Components"
    }

    $result = @{}
    foreach ($key in $folders.Keys) {
        $folderPath = $folders[$key]

        if (-not (Test-Path -Path $folderPath)) {
            $result[$key] = "Folder not found"
            continue
        }

        try {
            $acl = Get-Acl $folderPath
            $perms = $acl.Access | ForEach-Object {
                @{
                    IdentityReference = $_.IdentityReference.ToString()
                    FileSystemRights  = $_.FileSystemRights.ToString()
                    AccessControlType = $_.AccessControlType.ToString()
                }
            }

            $result[$key] = @{
                Owner       = $acl.Owner
                Permissions = $perms
            }
        } catch {
            $result[$key] = "Error collecting ACL: $_"
        }
    }

    return $result
}

