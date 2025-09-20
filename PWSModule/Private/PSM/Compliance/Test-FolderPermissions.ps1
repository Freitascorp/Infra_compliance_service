function Test-FolderPermissions {
    param(
        [hashtable] $Exp,
        [hashtable] $Aud
    )
    $result = $true

    foreach ($kvp in $Exp.GetEnumerator()) {
        $folderName    = $kvp.Key
        $expFolderData = $kvp.Value

        if (-not $Aud.ContainsKey($folderName)) {
            $result = $false
            $fail.Add("Folder Permissions: Folder '$folderName' not found in audit results")
            continue
        }
        $audFolderData = $Aud[$folderName]

        if ($audFolderData.Owner -ne $expFolderData.Owner) {
            $result = $false
            $fail.Add("Folder Permissions: Owner mismatch for folder '$folderName'. Expected '$($expFolderData.Owner)', Found '$($audFolderData.Owner)'")
        }

        $actualDenies = $audFolderData.Permissions |
            Where-Object { $_.AccessControlType -eq 'Deny' } |
            ForEach-Object { $_.IdentityReference }

        foreach ($deny in $expFolderData.DenyIdentities) {
            if (-not ($actualDenies -contains $deny)) {
                $result = $false
                $fail.Add("Folder Permissions: Missing deny for identity '$deny' in folder '$folderName'")
            }
        }
    }

    return $result
}
