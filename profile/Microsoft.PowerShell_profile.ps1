# set proxy
(New-Object System.Net.WebClient).Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

# clear
Set-Alias -name "c" -value "clear"

# exit
function QuitReplacement{
    Invoke-command -ScriptBlock {exit}
}
Set-Alias -Name "x" -Value "QuitReplacement"

# vim
Set-Alias -Name "vim" -Value "C:\apps\vim8\vim8\vim.exe"

# edit PS profile
Function e_ps {
    vim $profile
}

# To edit Vim settings
Function e_vim {
    vim $HOME\.vimrc
}

# Helper function to set location to the User Profile directory
function cuserprofile { Set-Location ~ }
Set-Alias ~ cuserprofile -Option AllScope

# Helper function to show Unicode character
function U
{
    param
    (
        [int] $Code
    )
 
    if ((0 -le $Code) -and ($Code -le 0xFFFF))
    {
        return [char] $Code
    }
 
    if ((0x10000 -le $Code) -and ($Code -le 0x10FFFF))
    {
        return [char]::ConvertFromUtf32($Code)
    }

    throw "Invalid character code $Code"
}

# Ensure that Get-ChildItemColor is loaded
Import-Module Get-ChildItemColor

# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope

# Ensure posh-git is loaded
Import-Module -Name posh-git

# Ensure oh-my-posh is loaded
Import-Module -Name oh-my-posh

# Default the prompt to paradox
Set-Theme paradox

# Enhance Path
$env:Path = "$env:Path;$Env:CMDER_ROOT\vendor\git-for-windows\usr\bin;"
