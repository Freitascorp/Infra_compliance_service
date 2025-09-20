function Invoke-PSMAudit {
    [CmdletBinding()]
    param (
        [string]$OutputFolder = "E:\CyberArk\Audit"
    )

    # Ensure the script is running with elevated privileges
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        Write-Warning "This command must be run as Administrator."
        return
    }

    Write-Host "Starting CyberArk PSM infrastructure audit..."

    # No longer need YAML module - using native JSON support

    # Define sections for audit data collection
    $sections = [ordered]@{
        PSM_Version               = { Collect-PSMVersion }
        Windows_Version           = { Collect-WindowsVersion }
        Disk_Space                = { Collect-DiskSpace }
        Vault_Connectivity        = { Collect-VaultConnectivity }
        PSM_RelatedServices       = { Collect-PsmRelatedServices }
        PSM_Service               = { Collect-PSMService }
        Certificates              = { Collect-AllCertificates }
        WinRM_Listeners           = { Collect-WinRMListeners }
        PrivateArk_Client         = { Collect-PrivateArkInfo }
        Vault_Credential_File     = { Collect-VaultCredFileInfo }
        Environment_Variables     = { Collect-EnvironmentVariables }
        Hardening_Settings        = { Collect-HardeningSettings }
        AppLocker_Script_Settings = { Collect-AppLockerSettings }
        Applied_GPOs              = { Collect-AppliedGPOs }
        FolderPermissions         = { Collect-FolderPermissions }
        AllInstalledApps          = { Collect-AllInstalledApps }
        PSM_OU                    = { Collect-PSMOU }
        Drivers                   = { Collect-Drivers }
        RDSTest                   = { Collect-RDSTest }
        Components_Version        = { Collect-ComponentsVersion }
    }

    # Collect audit data
    Write-Host "Collecting audit data..."
    $report = @{}
    foreach ($key in $sections.Keys) {
        Write-Host " - $key"
        $report[$key] = & $sections[$key]
    }

    # Ensure output directory exists
    if (-not (Test-Path $OutputFolder)) {
        New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
    }

    # Output file name
    $hostname = $env:COMPUTERNAME
    $jsonPath = Join-Path $OutputFolder "${hostname}_PSM_Audit_Report.json"

    # Save report as JSON
    $report | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonPath -Encoding UTF8

    Write-Host "Audit report saved to: $jsonPath"
    return $jsonPath
}
