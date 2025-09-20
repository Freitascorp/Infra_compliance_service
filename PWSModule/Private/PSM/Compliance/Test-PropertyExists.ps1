function Test-PropertyExists {
    param(
        [hashtable]$Object,
        [string]$PropertyPath
    )
    $properties = $PropertyPath -split '\.'
    $current = $Object
    foreach ($prop in $properties) {
        if (-not $current.ContainsKey($prop)) {
            return $false
        }
        $current = $current[$prop]
    }
    return $true
}