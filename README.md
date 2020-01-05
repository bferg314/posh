# How to configure PowerShell
I have been using PowerShell daily for a while now, and here are the basic configurations for a fresh Win 10 build.

### Enable remote signed
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Scoop
Scoop is a wonderful way to manage all of your local software.
```powershell
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
scoop install git aria2
scoop bucket add extras
scoop install pshazz hack-font mremoteng sharex telegram vim vscode
```

### Install PowerShell Core/PowerShell Preview 
And of course the latest versions of PowerShell...
```powershell
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Preview"
```

## Switch away from Windows PowerShell 
Everything before this was done in Windows PowerShell, but now to switch to Core and use a different GUI. I have been using the [Windows Terminal Preview](https://www.microsoft.com/en-us/p/windows-terminal-preview/9n0dx20hk701), and enjoy it so far. I used to use [cmder](https://cmder.net/), but consider this prettier and simpler.

## Customize...
### Create profile
And then you need to set up a profile to do all the cool things you want to do.
```powershell
New-Item -path $profile -type file –force
```

### Configure pshazz
I used to use posh-git and oh-my-posh, but this replaces it all.
```powershell
pshazz use agnoster-alternate
```

### Pull down some libs
```powershell
Install-PackageProvider NuGet -MinimumVersion '2.8.5.201' -Force -Scope CurrentUser
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name 'Get-ChildItemColor' -Scope CurrentUser
```

## Add stuff to your profile
Take what you want from here:
https://raw.githubusercontent.com/bferg314/posh/master/profile/Microsoft.PowerShell_profile.ps1

# Sources
* https://www.howtogeek.com/50236/customizing-your-powershell-profile/  
* https://gist.github.com/jchandra74/5b0c94385175c7a8d1cb39bc5157365e  
* https://github.com/AmrEldib/cmder-powershell-powerline-prompt  
* https://hodgkins.io/ultimate-powershell-prompt-and-git-setup
* https://www.thomasmaurer.ch/2019/07/how-to-install-and-update-powershell-7/
