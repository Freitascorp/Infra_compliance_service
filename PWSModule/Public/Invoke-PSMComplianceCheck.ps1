function Invoke-PSMComplianceCheck {
    [CmdletBinding()]
    param(
        [ValidateSet('TEST','POC','INT','PROD')][string] $Environment = 'TEST',
        [ValidateSet('europe','americas','africa','china')][string] $Region      = 'europe',
        [string]                                     $BaseLineConfig = '',
        [string]                                     $AuditConfig    = "$(Join-Path 'E:\CyberArk\Audit' "${env:COMPUTERNAME}_PSM_Audit_Report.json")",
        [string]                                     $OutputPath     = "$(Join-Path 'E:\CyberArk\Audit' "${env:COMPUTERNAME}_Compliance_Report.txt")"
    )

    # ► START TIMER ◄
    $sw = [Diagnostics.Stopwatch]::StartNew()

    # No longer need YAML module - using native JSON support

    # pick up default baseline if none supplied
    if (-not $BaseLineConfig) {
        # Get the current module path for relative baseline path
        $ModuleRoot = Split-Path -Parent $PSScriptRoot
        $BaseLineConfig = Join-Path $ModuleRoot "Baseline\psm_baseline.json"
        Write-Host "No baseline provided; using default: $BaseLineConfig"
    }

    Write-Host "Loading baseline for $Environment / $Region…"
    $expected = Get-Baseline -Environment $Environment -Region $Region

    Write-Host "Parsing audit: $AuditConfig"
    $audit = Get-JsonContent -Path $AuditConfig

    $pass = [System.Collections.Generic.List[string]]::new()
    $fail = [System.Collections.Generic.List[string]]::new()

    # run every Test-* function exactly as before
    $testResults = @{
        'OS Information'         = Test-OSInfo               -Exp $expected        -Aud $audit
        'PSM Version'            = Test-PSMVersion           -Exp $expected        -Aud $audit
        'Installed Applications' = Test-InstalledApps        -ExpApps $expected.AllInstalledApps -AudApps $audit.AllInstalledApps
        'Services'               = Test-Services             -Exp $expected        -Aud $audit
        'Disk Space'             = Test-DiskSpace            -Exp $expected        -AudDisks $audit.Disk_Space
        'WinRM Listeners'        = Test-WinRMListeners       -ExpListeners $expected.WinRM_Listeners -AudListeners $audit.WinRM_Listeners
        'Group Policies'         = Test-GPOs                 -ExpGPOs $expected.Applied_GPOs        -AudGPOs $audit.Applied_GPOs
        'Folder Permissions'     = Test-FolderPermissions    -Exp $expected.FolderPermissions      -Aud $audit.FolderPermissions
        'AppLocker Settings'     = Test-AppLocker            -Exp $expected                         -Aud $audit.AppLocker_Script_Settings
        'Vault Credential File'  = Test-VaultFile            -Exp $expected.Vault_Credential_File   -Aud $audit.Vault_Credential_File
        'Vault Connectivity'     = Test-VaultConnect         -Exp $expected.Vault_Connectivity      -Aud $audit.Vault_Connectivity
        'Drivers'                = Test-Drivers              -ExpDrivers $expected.Drivers          -AudDrivers $audit.Drivers
        'Components Version'     = Test-Components           -ExpComponents $expected.Components_Version -AudComponents $audit.Components_Version
        'Certificates'           = Test-Certificates         -ExpCerts $expected.Certificates       -AllCertificates $audit.Certificates
        'Environment Variables'  = Test-EnvVars              -ExpEnvVars $expected.Environment_Variables.Required -AudVars $audit.Environment_Variables
        'Hardening Settings'     = Test-Hardening_Script     -Exp $expected                         -Aud $audit.Hardening_Settings
        'PrivateArk Client'      = Test-PrivateArk           -Exp $expected                         -Aud $audit.PrivateArk_Client
        'RDSTest'                = Test-RDSTest              -Exp $expected.RDSTest                 -Aud $audit.RDSTest
        'PSM Related Services'   = Test-PSMRelatedServices   -ExpServices $expected.PSM_RelatedServices -AudServices $audit.PSM_RelatedServices
    }

    foreach ($kv in $testResults.GetEnumerator()) {
        if ($kv.Value) {
            $pass.Add("$($kv.Key): Passed")
        }
        # each Test-* already pushes its own failure messages into $fail
    }

    # ► STOP TIMER ◄
    $sw.Stop()
    $duration = $sw.Elapsed  # a TimeSpan


    $report = @"
Compliance Report
-----------------
Date:   $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Duration: $($duration.ToString())
Server: $env:COMPUTERNAME

PASS: $($pass.Count) checks passed
FAIL: $($fail.Count) checks failed

Passed Checks:
$($pass -join "`r`n")

Failed Checks:
$($fail -join "`r`n")
"@

    # ensure the output folder exists
    $outDir = Split-Path $OutputPath
    if (-not (Test-Path $outDir)) {
        New-Item -Path $outDir -ItemType Directory | Out-Null
    }

    $report | Out-File -FilePath $OutputPath -Encoding UTF8
    Write-Host "Compliance report generated at: $OutputPath`n"
    Write-Host $report
}
