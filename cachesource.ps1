$InformationPreference = 'Continue'

try {
    $config = Import-PowerShellDataFile -Path ".\sandboxconfig.psd1"
}
catch {
    Throw "Error loading sandboxconfig.psd1. Ensure it exists in the same directory as this script."
}

$modules = @(
    'Microsoft.Graph',
    'Az',
    'MSCloudLoginAssistant',
    'Microsoft.PowerApps.Administration.PowerShell',
    'ReverseDSC',
    'PnP.PowerShell',
    'DSCParser',
    'MicrosoftTeams',
    'AzureAd',
    'ExchangeOnlineManagement',
    'ImportExcel'
)

foreach ($module in $modules) {
    Write-Information "Caching $module"
    save-module -Name $module -Path "$($config.sandboxSource)\ModuleSource" -Force
}