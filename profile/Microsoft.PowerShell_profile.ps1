# Create the profile if it does not exist.
if (-not(Test-Path $PROFILE)) {New-Item $PROFILE -ItemType File -Force}

. "C:\git\posh\profile\psalias.ps1"
. "C:\git\posh\profile\psprompt.ps1"
. "C:\git\posh\profile\pssettings.ps1"
. "C:\git\posh\profile\psfuncs.ps1"
