# Introduction 
Scripts to start and configure Windows Sandbox for a PAWS-esque experience.

# Getting Started
1.  Clone locally. 
2.  Edit sandboxconfig.psd1
    1. You'll need two locations - SandboxSource, which is R/O and should be the location of the locally cloned repo. The second is SandboxShared, which is R/W and is for sharing between the Sandbox and the host system.
    2. Add Chrome profiles if you'd like with the chromeProfiles array.
    3. Add any powershell modules to the psmodules array. 
3. Edit winget.json to relect packaged you'd like to install via winget. 
4. Edit sandbox.wsb to reflect the folder locations.
5. Run cachesource.ps1 to cache all of the powershell modules locally to save time on Sandbox launch. Set useCache = $true in sandboxconfig.psd1 once you've done that.
6. Launch the sandbox by running sandbox.wsb. 