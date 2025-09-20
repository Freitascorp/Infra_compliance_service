function Collect-VaultCredFileInfo {
    $vaultFolder = "E:\Cyberark\PSM\Vault"
    if (-not (Test-Path $vaultFolder)) {
        return @{ Error = "Vault folder $vaultFolder not found." }
    }

    $iniPath = Join-Path $vaultFolder "Vault.ini"
    $credfile = $null
    if (Test-Path $iniPath) {
        $lines = Get-Content $iniPath
        $line  = $lines | Where-Object { $_ -match "(?i)credfile\s*=" } | Select-Object -First 1
        if ($line) {
            $parts = $line -split '='
            if ($parts.Count -ge 2) {
                $credfile = $parts[1].Trim()
            }
        }
    }

    if (-not $credfile) {
        $cf = Get-ChildItem -Path $vaultFolder -Filter *.ini -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($cf) { $credfile = $cf.Name }
    }

    if (-not $credfile) {
        return @{ Error = "No .cred file found in $vaultFolder." }
    }

    $full = Join-Path $vaultFolder $credfile
    $info = Get-Item $full
    return @{
        Path         = $full
        LastModified = $info.LastWriteTime
    }
}
