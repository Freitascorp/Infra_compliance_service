function Collect-PSMOU {
    param([string]$ComputerName = $env:COMPUTERNAME)
    try {
        $c = Get-ADComputer -Identity $ComputerName -Properties * -ErrorAction Stop
        return [PSCustomObject]@{
            Name              = $c.Name
            DistinguishedName = $c.DistinguishedName
            Enabled           = $c.Enabled
            Created           = $c.Created
        }
    } catch {
        return @{ Error = "Failed to get AD info for $ComputerName" }
    }
}

