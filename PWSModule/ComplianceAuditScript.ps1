# ComplianceAuditScript.ps1
# Wrapper script for .NET Windows Service to execute CyberArk PSM compliance audit
# This script imports the ComplianceCheck module and runs the audit, outputting JSON
param(
    [string]$OutputFolder = (Get-Location),
    [ValidateSet('TEST','POC','INT','PROD')][string]$Environment = 'TEST',
    [ValidateSet('europe','americas','africa','china')][string]$Region = 'europe'
)

try {
    Write-Host "Starting CyberArk PSM compliance audit script..." -ForegroundColor Green
    
    # Get the directory where this script resides
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $ModulePath = Join-Path $ScriptDir "ComplianceCheck.psd1"
    
    # Import the ComplianceCheck module
    if (Test-Path $ModulePath) {
        Write-Host "Loading ComplianceCheck module from: $ModulePath"
        Import-Module $ModulePath -Force -ErrorAction Stop
    } else {
        throw "ComplianceCheck module not found at: $ModulePath"
    }
    
    # Run the audit first
    Write-Host "Step 1: Running PSM audit collection..." -ForegroundColor Yellow
    $auditReportPath = Invoke-PSMAudit -OutputFolder $OutputFolder
    
    if ($auditReportPath -and (Test-Path $auditReportPath)) {
        Write-Host "Audit report created successfully: $auditReportPath" -ForegroundColor Green
        
        # Run compliance check
        Write-Host "Step 2: Running compliance check..." -ForegroundColor Yellow
        $complianceReportPath = Join-Path $OutputFolder "$($env:COMPUTERNAME)_Compliance_Report.txt"
        Invoke-PSMComplianceCheck -Environment $Environment -Region $Region -AuditConfig $auditReportPath -OutputPath $complianceReportPath
        
        if (Test-Path $complianceReportPath) {
            Write-Host "Compliance check completed successfully: $complianceReportPath" -ForegroundColor Green
        }
        
        # Also copy the JSON audit file to the expected location for the web service
        $webServiceJsonPath = Join-Path $OutputFolder "directories.json"
        if (Test-Path $auditReportPath) {
            Copy-Item $auditReportPath $webServiceJsonPath -Force
            Write-Host "JSON audit file copied for web service: $webServiceJsonPath" -ForegroundColor Green
        }
    } else {
        throw "Audit report was not created successfully"
    }
    
    Write-Host "Compliance audit script completed successfully!" -ForegroundColor Green
} catch {
    Write-Error "Error in compliance audit script: $_"
    throw
}