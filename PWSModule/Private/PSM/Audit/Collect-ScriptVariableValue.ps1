function Collect-ScriptVariableValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$FilePath,
        [Parameter(Mandatory)][string]$VariableName
    )

    if (-not (Test-Path -Path $FilePath)) {
        return 'FileNotFound'
    }

    $pattern = '^\s*\$' + [regex]::Escape($VariableName) +
               '\s*=\s*(?:''([^'']*)''|"([^""]*)"|(\S+))'

    foreach ($line in Get-Content -Path $FilePath) {
        if ($line -match $pattern) {
            if ($matches[1])      { return $matches[1] }
            elseif ($matches[2])  { return $matches[2] }
            else                  { return $matches[3] }
        }
    }

    return 'NotFound'
}
