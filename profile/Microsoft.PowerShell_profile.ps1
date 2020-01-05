# PowerShell Settings
Set-PSReadLineOption -HistoryNoDuplicates:$True

# Scripts on the Path
$env:Path = "$env:Path;c:\git\posh\scripts;"

# Custom Functions/Aliases
# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

# clear
Set-Alias -name "c" -value "clear"

# exit
function QuitReplacement{
    Invoke-command -ScriptBlock {exit}
}
Set-Alias -Name "x" -Value "QuitReplacement"

# make dir then cd
function mc ($dir) {
    New-Item -Name $dir -ItemType directory
    Set-Location -Path $dir
}

# reload instance
function rc {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = "-nologo";
    [System.Diagnostics.Process]::Start($newProcess);
    exit
}

Function ClipPath ($file_name) {
    Set-Clipboard(Resolve-Path $file_name).Path
}

function Get-Env($name){
    if ($name){
        (Get-ChildItem env:$name).Value.split(';') | sort-object
    }
    else{
        Get-ChildItem env:* | sort-object name
    }
}