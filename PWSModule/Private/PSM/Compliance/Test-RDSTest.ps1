function Test-RDSTest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][psobject] $Exp,  # baseline.RDSTest
        [Parameter(Mandatory)][psobject] $Aud   # audit.RDSTest
    )

    $ok = $true

    if ($Exp.RDSServiceInstalled -ne $Aud.RDSServiceInstalled) {
        $ok = $false
        $fail.Add(
            "RDSTest: RDSServiceInstalled mismatch. Expected '$($Exp.RDSServiceInstalled)', Found '$($Aud.RDSServiceInstalled)'"
        )
    }
    if ($Exp.ServiceStatus -ne $Aud.ServiceStatus) {
        $ok = $false
        $fail.Add(
            "RDSTest: ServiceStatus mismatch. Expected '$($Exp.ServiceStatus)', Found '$($Aud.ServiceStatus)'"
        )
    }
    if ($Exp.ConnectionsAllowed -ne $Aud.ConnectionsAllowed) {
        $ok = $false
        $fail.Add(
            "RDSTest: ConnectionsAllowed mismatch. Expected '$($Exp.ConnectionsAllowed)', Found '$($Aud.ConnectionsAllowed)'"
        )
    }
    if ($Exp.Computer -ne $Aud.Computer) {
        $ok = $false
        $fail.Add(
            "RDSTest: Computer mismatch. Expected '$($Exp.Computer)', Found '$($Aud.Computer)'"
        )
    }

    return $ok
}
