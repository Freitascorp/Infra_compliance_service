# ComplianceCheck.psm1

# Import all private functions
Get-ChildItem -Path $PSScriptRoot\Private -Recurse -Filter *.ps1 | ForEach-Object {
    . $_.FullName
}

# Import all public functions
Get-ChildItem -Path $PSScriptRoot\Public -Filter *.ps1 | ForEach-Object {
    . $_.FullName
}


