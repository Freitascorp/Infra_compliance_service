function Collect-PsmRelatedServices {
    Get-Service |
      Where-Object DisplayName -match "CyberArk" |
      ForEach-Object {
        [PSCustomObject]@{
          Name        = $_.Name
          DisplayName = $_.DisplayName
          Status      = $_.Status
        }
      }
}
