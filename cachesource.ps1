$InformationPreference = 'Continue'

try {
    $config = Import-PowerShellDataFile -Path ".\sandboxconfig.psd1"
}
catch {
    Throw "Error loading sandboxconfig.psd1. Ensure it exists in the same directory as this script."
}

foreach ($module in $config.psmodules) {
    Write-Information "Caching $($module.name)"
    save-module -Name $module.name -Path "$($config.sandboxSource)\ModuleSource" -Force
}