function Collect-VaultConnectivity {
    $vaultIni = "E:\Cyberark\PSM\Vault\Vault.ini"
    if (-not (Test-Path $vaultIni)) {
        return @{ Error = "Vault.ini not found at $vaultIni." }
    }

    Write-Host "Reading Vault.ini from $vaultIni"
    $iniContent  = Get-Content $vaultIni
    $addressLine = $iniContent | Where-Object { $_ -match '^[ \t]*Address[ \t]*=' } | Select-Object -First 1
    $portLine    = $iniContent | Where-Object { $_ -match '^[ \t]*Port[ \t]*=' }    | Select-Object -First 1

    if (-not $addressLine -or -not $portLine) {
        return @{ Error = "Vault.ini missing Address/Port entries." }
    }

    $rawAddrs  = ($addressLine -replace '^[ \t]*Address[ \t]*=[ \t]*', '').Trim()
    $port      = ($portLine -replace '^[ \t]*Port[ \t]*=[ \t]*', '').Trim()
    $addresses = $rawAddrs -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }

    $results = [System.Collections.Generic.List[object]]::new()

    foreach ($addr in $addresses) {
        $entry = [PSCustomObject][ordered]@{
            VaultAddress   = $addr
            VaultPort      = $port
            PingStatus     = $null
            PingResponseMs = $null
            PortConnection = $null
            Role           = 'Unknown'
        }

        Write-Host "Pinging Vault ($addr)…"
        try {
            $ping = Test-Connection -ComputerName $addr -Count 2 -ErrorAction Stop
            $entry.PingStatus     = 'Success'
            $entry.PingResponseMs = [math]::Round(($ping | Measure-Object -Property ResponseTime -Average).Average, 2)
        } catch {
            $entry.PingStatus = 'Failed'
        }

        Write-Host "Testing TCP connection to $($addr):$($port)…"
        try {
            $tcp = Test-NetConnection -ComputerName $addr -Port $port -WarningAction Stop
            $entry.PortConnection = if ($tcp.TcpTestSucceeded) { 'Success' } else { 'Failed' }
        } catch {
            $entry.PortConnection = 'Failed'
        }

        $results.Add($entry)
    }

    $successful = $results | Where-Object PortConnection -eq 'Success'
    if ($successful) {
        foreach ($r in $results) { $r.Role = 'DR' }
        $successful[0].Role = 'Primary'
    }

    if ($results.Count -eq 1) {
        return $results[0]
    } else {
        return $results
    }
}
