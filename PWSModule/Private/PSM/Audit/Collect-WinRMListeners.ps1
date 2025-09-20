function Collect-WinRMListeners {
    try {
        $output = winrm enumerate winrm/config/listener 2>$null
        if (-not $output) { return "None configured" }

        $listeners = @()
        $current   = @{}
        foreach ($line in $output) {
            $trim = $line.Trim()
            if ($trim -eq "" -or $trim -eq "Listener") {
                if ($current.Count) {
                    $listeners += $current
                    $current = @{}
                }
                continue
            }
            if ($trim -match "^(.*?)=(.*)$") {
                $current[$matches[1].Trim()] = $matches[2].Trim()
            } else {
                $current[$trim] = ""
            }
        }
        if ($current.Count) { $listeners += $current }

        if ($listeners.Count) {
            return $listeners
        } else {
            return "None configured"
        }
    } catch {
        Write-Host "Error enumerating WinRM listeners: $_"
        return "Error"
    }
}
