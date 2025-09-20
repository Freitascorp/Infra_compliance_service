function Test-WinRMListeners {
    param([array]$ExpListeners, [array]$AudListeners)
    $result = $true
    foreach($listener in $ExpListeners) {
        $audListener = $AudListeners | Where-Object {
            $_.Port -eq $listener.Port -and $_.Transport -eq $listener.Transport
        }
        if (-not $audListener) {
            $result = $false
            $fail.Add("WinRM Listeners: Listener not found. Expected Port $($listener.Port), Transport $($listener.Transport)")
        } elseif ($audListener.Enabled -ne $listener.Enabled) {
            $result = $false
            $fail.Add("WinRM Listeners: Listener status mismatch. Expected Enabled '$($listener.Enabled)', Found '$($audListener.Enabled)' for Port $($listener.Port), Transport $($listener.Transport)")
        }
    }
    return $result
}
