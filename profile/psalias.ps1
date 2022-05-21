Set-Alias -name "c" -value "clear"

function QuitReplacement{
    Invoke-command -ScriptBlock {exit}
}

Set-Alias -Name "x" -Value "QuitReplacement"

Set-Alias -Name "rdn" -Value Resolve-DnsName

# Custom Functions/Aliases
# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }