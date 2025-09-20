function Get-JsonContent {
    param([string]$Path)
    try {
        Write-Host "Parsing JSON file: $Path"
        $content = Get-Content $Path -Raw
        $json = ConvertFrom-Json $content
        if ($null -eq $json) {
            throw "JSON content is empty or null"
        }
        return $json
    } catch {
        Write-Error "Failed to parse JSON file '$Path': $_"
        exit 1
    }
}