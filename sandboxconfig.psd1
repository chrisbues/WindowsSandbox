@{
    SandboxSource = "c:\SandboxSource";
    SandboxShared = "C:\SandboxShared";
    useCache = $true;
    # Modules 
    psmodules = @(
    @{ name = 'Microsoft.Graph'; desktop = $true; core = $true },
    @{ name = 'Az'; desktop = $true; core = $true },
    @{ name = 'MSCloudLoginAssistant'; desktop = $true; core = $true },
    @{ name = 'Microsoft.PowerApps.Administration.PowerShell'; desktop = $true; core = $true },
    @{ name = 'ReverseDSC'; desktop = $true; core = $true },
    @{ name = 'PnP.PowerShell'; desktop = $true; core = $true },
    @{ name = 'DSCParser'; desktop = $true; core = $true },
    @{ name = 'MicrosoftTeams'; desktop = $true; core = $true },
    @{ name = 'AzureAd'; desktop = $true; core = $false },
    @{ name = 'ExchangeOnlineManagement'; desktop = $true; core = $true },
    @{ name = 'ImportExcel'; desktop = $true; core = $true }
    );
    vscodeExtensions = @(
        @{ name = 'ms-vscode.PowerShell';}
    );
    chromeProfiles = @('Example');
    chromeHomepage = 'http://msportals.io';
    chromeBookmarks = @(
        @{ name = 'Bing'; url = 'https://www.bing.com/'; },
        @{ name = 'Google'; url = 'https://www.google.com/'; },
        @{ name = 'Microsoft'; url = 'https://www.microsoft.com/'; }
    );
}