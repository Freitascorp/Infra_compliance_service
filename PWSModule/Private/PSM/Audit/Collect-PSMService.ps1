function Collect-PSMService {
    $svc = Get-Service -Name 'Cyber-Ark Privileged Session Manager' -ErrorAction SilentlyContinue
    return @{ PSM_ServiceStatus = if ($svc) { $svc.Status } else { 'NotFound' } }
}
