$InformationPreference = "Continue"
#Settings
try {
    $config = Import-PowerShellDataFile -Path "c:\sandboxsource\sandboxconfig.psd1"
}
catch {
    write-error "Error loading sandboxconfig.psd1" -erroraction stop
}
Write-Information "Installing Modules"

# Install modules
foreach ($module in $config.modules.where({$true -eq $_.core})) {
    if ($false -eq $config.useCache) {
        Install-Module -name $module.name -Force -Repository PSGallery }
}

# Set PS 7 profile
Write-Information "Configuring PS 7 Profile"
try {
    new-item -path "$($env:USERPROFILE)\Documents\PowerShell" -type directory -force
    $profileText = '$env:psmodulepath += ";' + "$($config.SandboxSource)\ModuleSource" + '"'
    Set-Content -Value $profileText -Path $profile -force
    Set-PSReadLineOption -PredictionSource History
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
}
catch {
    Write-Error "Error Configuring PS 7 Profile" -errorAction Stop
}