# How to configure powershell
This is a copy and paste pileup of things that I am used to in bash.  

## Laying the groundwork  
Do all of this in regular powershell before switching to cmder.

### Enable remote signed
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Set the proxy (if required)
```powershell
(New-Object System.Net.WebClient).Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
```

### Scoop
```powershell
[environment]::setEnvironmentVariable('SCOOP','c:\apps\Scoop','User')
$env:SCOOP='c:\apps\scoop'
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
scoop bucket add extras
```

### Create profile
```powershell
New-Item -path $profile -type file –force
```

## Cmder Install
It's really not a question of whether or not to install cmder, it's how. Depending on your environment you may want to install through scoop, or you may want to grab the full version from the site.

#### Use scoop to install cmder
```powershell
scoop install 7zip git openssh cmder
```

#### Manually install
Go the site and install the full version manually.  
http://cmder.net/

Then close the regular PowerShell...

## Setting up cmder
There are lots of little tweaks you can do, but there are really only two important ones for PowerShell.  
* Set PowerShell as the default
* Set the PowerShell tasks to use the profile you just created 
```
PowerShell -ExecutionPolicy Bypass -NoLogo -NoExit -NoProfile -Command "Invoke-Expression '. ''%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1'''" -new_console:d:"%USERPROFILE%"
```

### Pull down some libs
```powershell
Install-PackageProvider NuGet -MinimumVersion '2.8.5.201' -Force -Scope CurrentUser
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name 'posh-git' -Scope CurrentUser
Install-Module -Name 'oh-my-posh' -Scope CurrentUser
Install-Module -Name 'Get-ChildItemColor' -Scope CurrentUser
```

## Add stuff to your profile
Take what you want from here:
https://raw.githubusercontent.com/bferg314/dotfiles/master/winscript/posh/Microsoft.PowerShell_profile.ps1

# Sources
* https://www.howtogeek.com/50236/customizing-your-powershell-profile/  
* https://gist.github.com/jchandra74/5b0c94385175c7a8d1cb39bc5157365e  
* https://github.com/AmrEldib/cmder-powershell-powerline-prompt  
