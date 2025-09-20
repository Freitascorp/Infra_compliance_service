function Collect-EnvironmentVariables {
    $envVars = @{}
    [System.Environment]::GetEnvironmentVariables('Machine').GetEnumerator() |
        ForEach-Object { $envVars[$_.Key] = $_.Value }
    return $envVars
}

