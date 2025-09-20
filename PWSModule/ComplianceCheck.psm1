# ComplianceCheck.psm1

$ModuleDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Public commands
. (Join-Path $ModuleDir 'Public\Invoke-PSMComplianceCheck.ps1')

# Private helpers
. (Join-Path $ModuleDir 'Private\PSM\Compliance\Get-Baseline.ps1')
. (Join-Path $ModuleDir 'Private\PSM\Compliance\Test-EnvVars.ps1')

# Import all private functions
Get-ChildItem -Path $PSScriptRoot\Private -Recurse -Filter *.ps1 | ForEach-Object {
    . $_.FullName
}

# Import all public functions
Get-ChildItem -Path $PSScriptRoot\Public -Filter *.ps1 | ForEach-Object {
    . $_.FullName
}


