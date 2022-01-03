$InformationPreference = "Continue"
$startTime = Get-date

#Settings

try {
    $config = Import-PowerShellDataFile -Path "c:\sandboxsource\sandboxconfig.psd1"
}
catch {
    Throw "Error loading sandboxconfig.psd1. Ensure it exists in the same directory as this script."
}


Write-Information "Configuring PSGallery"

try {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Install-Module -Name PackageManagement -Force -MinimumVersion 1.4.6 -Scope CurrentUser -AllowClobber -Repository PSGallery

}
catch {
    Write-Error "Error Configuring PSGallery" -errorAction Stop
}

if ($config.psmodules) {
    Write-Information "Installing Modules"

    # Install modules
    try {
        foreach ($module in $config.psmodules.where({$true -eq $_.desktop})) {
            if ($false -eq $config.useCache) {
                Install-Module -name $module.name -Force -Repository PSGallery }
        }
    }
    Catch {
        Write-Error "Error Installing Modules" -errorAction Stop
    }
}


Write-Information "Installing Winget"
# This is the VC Libs package
# https://www.microsoft.com/store/productId/9NBLGGH4RV3K
# Go here (https://store.rg-adguard.net/) and use the url above to get the store links

try {
    # Install VCLibs
    Add-AppxPackage "$($config.sandboxsource)\Microsoft.VCLibs.140.00.UWPDesktop_14.0.30704.0_x64__8wekyb3d8bbwe.Appx"
    # Install Winget
    Add-AppPackage "$($config.sandboxsource)\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
}
catch {
    Write-Error "Error Installing Winget" -errorAction Stop
}

Write-Information "Installing Applications via Winget"
try {
    winget import -i "$($config.sandboxsource)\winget.json" --accept-package-agreements --accept-source-agreements
}
catch {
    write-error "Error Installing Applications" -errorAction Stop
}

# Visual Studio Code Extensions
Write-Information "Installing VSCode Extensions"


try {
    foreach ($extension in $config.vscodeExtensions) {
        start-process "C:\Users\WDAGUtilityAccount\AppData\Local\Programs\Microsoft VS Code\bin\code" -argumentList "--install-extension $($extension.name)" -wait
    }
}
catch {
    Write-Error "Error Installing VSCode Extensions" -errorAction Stop
}


<# MSI install of Chrome for when winget has issues with the chrome package 
Remove-Item "$($config.SandboxShared)\GoogleChromeStandaloneEnterprise64.msi" -Force
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri 'https://dl.google.com/edgedl/chrome/install/GoogleChromeStandaloneEnterprise64.msi' -OutFile "$($config.SandboxShared)\GoogleChromeStandaloneEnterprise64.msi"
start-process -filepath 'msiexec.exe' -argumentList  "/i $($config.SandboxShared)\GoogleChromeStandaloneEnterprise64.msi /quiet" -Wait
start-process -filepath 'msiexec.exe' -argumentList "/i $($config.sandboxsource)\KeeperSetup32.msi /quiet" -wait
 #>

Write-Information "Configuring PowerShell 7"

try {
    start-process -FilePath "pwsh.exe" -ArgumentList "-file $($config.sandboxsource)\bootstrap7.ps1" -wait
}
catch {
    Write-Error "Error Configuring PowerShell 7" -errorAction Stop
}


# chrome profiles
# https://www.chromium.org/developers/creating-and-using-profiles

if ($config.chromeProfiles) {
    Write-Information "Configuring Chrome Profiles"
    $masterPreferences = get-content "$($config.sandboxsource)\master_preferences_source" | ConvertFrom-Json
    $masterPreferences.homepage = $config.chromeHomepage
    $masterPreferences.first_run_tabs = @($config.chromeHomepage)
    $masterPreferences.distribution.import_bookmarks_from_file = ("$($config.sandboxshared)\adminfav.html").replace('\','\\')
    $masterPreferences | ConvertTo-Json | Set-Content -Path "$($config.sandboxshared)\master_preferences" -Force -Encoding UTF8

    $adminFav = @"
    <!DOCTYPE NETSCAPE-Bookmark-file-1>
    <!-- This is an automatically generated file.
         It will be read and overwritten.
         DO NOT EDIT! -->
    <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
    <TITLE>Bookmarks</TITLE>
    <H1>Bookmarks</H1>
    <DL><p>
        <DT><H3 PERSONAL_TOOLBAR_FOLDER="true">Favorites bar</H3>
        <DL><p>

"@

    foreach ($link in $config.chromeBookmarks) {
        $adminFav += '<DT><A HREF="' + $link.url + '">' + $link.name + '</A>' + [Environment]::NewLine
    }

    $adminFav += '</DL><p></DL><p>'
    $adminFav | set-content -path "$($config.sandboxshared)\adminfav.html" -force -encoding utf8 


    try {
        copy-item "$($config.sandboxshared)\master_preferences" "C:\Program Files\Google\Chrome\Application\"
        foreach ($profile in $config.chromeProfiles) {

            New-Item -Path "$env:TEMP\Chrome\$profile" -ItemType Directory -Force | out-null
            $linkPath        =  "$env:USERPROFILE\Desktop\$profile.lnk"
            $targetPath      = "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
            $link            = (New-Object -ComObject WScript.Shell).CreateShortcut($linkPath)
            $link.TargetPath = $targetPath
            $link.Arguments = "--user-data-dir=$env:TEMP\Chrome\$profile"
            [void]$link.Save()
        }
    }
    catch {
        Write-Error "Error Configuring Chrome Profiles" -errorAction Stop
    }
}

# Set PS 5 profile
Write-Information "Configuring PS 5 Profile"
try {
    $profileText = '$env:psmodulepath += ";' + "$($config.SandboxSource)\ModuleSource" + '"'
    Set-Content -Value $profileText -Path $profile -Force
}
catch {
    Write-Error "Error Configuring PS 5 Profile" -errorAction Stop
}

# Finish up
$endTime = Get-date
$duration = new-timespan -start $startTime -end $endTime
Write-Information "Complete in $($duration.TotalMinutes) minutes."
Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
exit