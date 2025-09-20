CyberArk ComplianceCheck PowerShell Module
==========================================

A modular PowerShell framework to audit and validate the configuration of **CyberArk Windows components** against a JSON-based compliance baseline.

Currently implemented: **Privileged Session Manager (PSM)**.

Features
--------
- Audits CyberArk PSM infrastructure
- Compares actual state with JSON-defined baselines
- Generates detailed compliance reports
- Modular structure to easily support additional CyberArk components (CPM, PVWA, etc.)
- Native PowerShell JSON support for config parsing

Folder Structure
----------------
ComplianceCheck/
├── Baseline/
│   └── psm_baseline.json
├── Public/
│   ├── Invoke-PSMAudit.ps1
│   └── Invoke-PSMComplianceCheck.ps1
├── Private/
│   └── PSM/
│       ├── Audit/
│       │   └── Collect-*.ps1
│       └── Compliance/
│       |    └── Test-*.ps1
│       ├── Config/
│       │   └── users.json
├── ComplianceCheck.psd1
├── ComplianceCheck.psm1
└── README.txt

Installation
------------
1. Copy the module to a valid PowerShell module path (or load by full path)
2. Import the module (no additional dependencies required):
   Import-Module "E:\CyberArk\Audit\ComplianceCheck\ComplianceCheck.psd1" -Force

Usage (for PSM)
---------------

1. Run audit collection:
   Invoke-PSMAudit

   This generates:
   E:\CyberArk\Audit\<COMPUTERNAME>_PSM_Audit_Report.json

2. Run compliance check:
   Invoke-PSMComplianceCheck

   Automatically uses:
   - Audit file: E:\CyberArk\Audit\<COMPUTERNAME>_PSM_Audit_Report.json
   - Baseline: Baseline\psm_baseline.json
   - Output: E:\CyberArk\Audit\<COMPUTERNAME>_Compliance_Report.txt

Output Format
-------------
- Passed checks listed clearly
- Failed checks include detailed mismatch descriptions

Adding Support for Other Components
-----------------------------------
To support additional components like CPM or PVWA:
1. Add audit collectors in: `Private\<Component>\Audit\Collect-*.ps1`
2. Add compliance check functions in: `Private\<Component>\Compliance\Test-*.ps1`
3. Create a public entry point in: `Public\Invoke-<Component>*.ps1`
4. Update the module loader and manifest as needed

Requirements
------------
- PowerShell 5.1 or newer
- Administrator privileges (for auditing)
- No external dependencies required (uses native JSON support)

License
-------
CTW
