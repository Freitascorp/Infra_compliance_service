function Get-Baseline {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][ValidateSet('TEST','POC','INT','PROD')][string] $Environment,
        [Parameter(Mandatory)][ValidateSet('europe','americas','africa','china')][string] $Region
    )

    # (1) hard-coded paths
    $PathBaseline = 'E:\CyberArk\Audit\ComplianceCheck\Baseline\psm_baseline.yml'
    $PathUsers    = 'E:\CyberArk\Audit\ComplianceCheck\Public\Config\users.yml'

    if (-not (Test-Path $PathBaseline)) { throw "Baseline not found at $PathBaseline" }
    if (-not (Test-Path $PathUsers))    { throw "Users config not found at $PathUsers" }

    # (2) load raw YAML
    $raw = Get-Content $PathBaseline -Raw
    $usersAll = ConvertFrom-Yaml (Get-Content $PathUsers -Raw)

    if (-not $usersAll.ContainsKey($Environment) -or -not $usersAll[$Environment].ContainsKey($Region)) {
        throw "No mapping for $Environment / $Region in users.yml"
    }
    $pair = $usersAll[$Environment][$Region]
    $HOST = $env:COMPUTERNAME
    $REGION_UP = $Region.ToUpperInvariant()

    # (3) do our simple templating
    $filled = $raw `
      -replace '\{\{\s*Users\[ENV\]\[REGION\]\.Admin\s*\}\}',   [regex]::Escape($pair.Admin) `
      -replace '\{\{\s*Users\[ENV\]\[REGION\]\.Connect\s*\}\}', [regex]::Escape($pair.Connect) `
      -replace '\{\{\s*HOSTNAME_LOWER\s*\}\}',                  $HOST.ToLower() `
      -replace '\{\{\s*HOSTNAME\s*\}\}',                        $HOST `
      -replace '\{\{\s*ENV\s*\}\}',                             $Environment `
      -replace '\{\{\s*REGION\s*\}\}',                          $REGION_UP

    # (4) parse it
    $baseline = ConvertFrom-Yaml $filled

    # (5) inject *only* the Computer override
    if (-not $baseline.PSObject.Properties.Name.Contains('RDSTest')) {
        # fallback: add a full block
        $baseline | Add-Member NoteProperty RDSTest (@{
            Computer            = $HOST
            RDSServiceInstalled = $baseline.RDSTest.RDSServiceInstalled
            ServiceStatus       = $baseline.RDSTest.ServiceStatus
            ConnectionsAllowed  = $baseline.RDSTest.ConnectionsAllowed
        })
    }
    else {
        $baseline.RDSTest.Computer = $HOST
    }

    return $baseline
}
