function Collect-AllCertificates {
    $certList = @()
    try {
        $storeCerts = Get-ChildItem -Path Cert:\LocalMachine\My -ErrorAction SilentlyContinue
        foreach ($cert in $storeCerts) {
            $certList += @{
                Subject    = $cert.Subject
                Issuer     = $cert.Issuer
                Expiration = $cert.NotAfter
                Thumbprint = $cert.Thumbprint
            }
        }
    } catch {
        Write-Host "Error enumerating certificates: $_"
    }
    return $certList
}