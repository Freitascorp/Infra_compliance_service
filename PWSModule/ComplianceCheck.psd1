@{
    RootModule        = 'ComplianceCheck.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'b6e1f93f-dae0-4578-b54c-91c4b6d73990'
    Author            = 'Pammers'
    CompanyName       = 'CTW'
    Description       = 'Configuration management module for PSM'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('Invoke-PSMComplianceCheck', 'Invoke-PSMAudit')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{}
}
