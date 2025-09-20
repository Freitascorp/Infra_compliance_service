function Get-YamlContent {
    param([string]$Path)
    try {
        Write-Host "Parsing file: $Path"
        $content = Get-Content $Path -Raw
        $yaml = ConvertFrom-Yaml $content
        if ($null -eq $yaml) {
            throw "YAML content is empty or null"
        }
        return $yaml
    } catch {
        Write-Error "Failed to parse YAML file '$Path': $_"
        exit 1
    }
}
