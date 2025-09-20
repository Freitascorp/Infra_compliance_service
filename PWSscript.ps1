param (
    [string]$RootPath = ".",
    [string]$OutputFile = "directories.json"
)

$FullPath = Resolve-Path $RootPath

$directories = Get-ChildItem -Path $FullPath -Directory -Recurse | ForEach-Object {
    $_.FullName
}

$result = @{
    RootPath = $FullPath.Path
    Directories = $directories
}

$result | ConvertTo-Json -Depth 3 | Out-File -Encoding UTF8 -FilePath $OutputFile

Write-Host "Directory list saved to $OutputFile"
