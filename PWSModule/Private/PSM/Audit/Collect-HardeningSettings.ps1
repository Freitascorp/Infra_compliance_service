function Collect-HardeningSettings {
    $script = "E:\Cyberark\PSM\Hardening\PSMHardening.ps1"
    return @{
        SUPPORT_WEB_APPLICATIONS = Collect-ScriptVariableValue -FilePath $script -VariableName "SUPPORT_WEB_APPLICATIONS"
        PSM_CONNECT_USER         = Collect-ScriptVariableValue -FilePath $script -VariableName "PSM_CONNECT_USER"
        PSM_ADMIN_CONNECT_USER   = Collect-ScriptVariableValue -FilePath $script -VariableName "PSM_ADMIN_CONNECT_USER"
    }
}
