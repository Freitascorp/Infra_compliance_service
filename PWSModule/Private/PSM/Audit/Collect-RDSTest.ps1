function Collect-RDSTest {
    param([string]$ComputerName = $env:COMPUTERNAME)
    try {
        $svc = Get-Service -Name TermService -ComputerName $ComputerName -ErrorAction Stop
        $installed     = $true
        $serviceStatus = $svc.Status
    } catch {
        $installed     = $false
        $serviceStatus = $null
    }

    $regPath = 'SYSTEM\CurrentControlSet\Control\Terminal Server'
    try {
        $deny = if ($ComputerName -eq $env:COMPUTERNAME) {
            (Get-ItemProperty -Path "HKLM:\$regPath" -Name 'fDenyTSConnections').fDenyTSConnections
        } else {
            ([Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$ComputerName).OpenSubKey($regPath)).GetValue('fDenyTSConnections')
        }
        $connectionsAllowed = switch ($deny) { 0 { $true } 1 { $false } default { $null } }
    } catch {
        $connectionsAllowed = $null
    }

    return [PSCustomObject]@{
        Computer            = $ComputerName
        RDSServiceInstalled = $installed
        ServiceStatus       = $serviceStatus
        ConnectionsAllowed  = $connectionsAllowed
    }
}

