function Collect-WindowsVersion {
    try {
        $os = Get-CimInstance -ClassName Win32_OperatingSystem
        return @{
            Caption        = $os.Caption
            Version        = $os.Version
            BuildNumber    = $os.BuildNumber
            OSArchitecture = $os.OSArchitecture
            Manufacturer   = $os.Manufacturer
        }
    } catch {
        return "Error retrieving Windows version info"
    }
}
