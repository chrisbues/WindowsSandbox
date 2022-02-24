@{
    # Paths for the two shared folders. Source is R/O, Shared is R/W.
    SandboxSource = "c:\SandboxSource";
    SandboxShared = "C:\SandboxShared";
    # Modules Config

    # Use cache directoryf or modules. Run cachesource.ps1 to populate the cache.
    useCache = $false;

    # PS modules. Name, PS5 and PS6+
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

    # Visual Studio Code extensions to install
    vscodeExtensions = @(
        @{ name = 'ms-vscode.PowerShell';}
    );


    # Chrome Management

    # Profile name and pre-installed theme color in RGB
    chromeProfiles = @(
        @{ name='Example'; color='0,0,0'}
    );
    chromeHomepage = 'http://msportals.io';
    chromeBookmarks = @(
        @{ name = 'PIM'; url = 'https://portal.azure.com/#blade/Microsoft_Azure_PIMCommon/CommonMenuBlade/quickStart' },
        @{ name = 'Admin'; url = 'https://admin.microsoft.com/' },
        @{ name = 'Portal'; url = 'https://portal.azure.com/' },
        @{ name = 'Preview Portal'; url = 'https://preview.portal.azure.com/' },
        @{ name = 'AAD'; url = 'https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Overview' },
        @{ name = 'Sentinel'; url = 'https://portal.azure.com/#blade/HubsExtension/BrowseResourceBlade/resourceType/microsoft.securityinsightsarg%2Fsentinel' },
        @{ name = 'Security'; url = 'https://security.microsoft.com/' },
        @{ name = 'Compliance'; url = 'https://compliance.microsoft.com/' },
        @{ name = 'MDCA'; url = 'https://portal.cloudappsecurity.com/' }
        @{ name = 'MEM'; url = 'https://endpoint.microsoft.com/' }
    );
}