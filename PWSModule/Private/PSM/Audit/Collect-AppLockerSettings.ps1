function Collect-AppLockerSettings {
    $script = "E:\Cyberark\PSM\Hardening\PSMConfigureAppLocker.ps1"
    return @{
        PSM_CONNECT       = Collect-ScriptVariableValue -FilePath $script -VariableName "PSM_CONNECT"
        PSM_ADMIN_CONNECT = Collect-ScriptVariableValue -FilePath $script -VariableName "PSM_ADMIN_CONNECT"
        DEFAULT_PSM_PATH  = Collect-ScriptVariableValue -FilePath $script -VariableName "DEFAULT_PSM_PATH"
    }
}

