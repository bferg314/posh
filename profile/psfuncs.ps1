function mc ($dir) {
    New-Item -Name $dir -ItemType directory
    Set-Location -Path $dir
}

# reload instance
function rc {
    $parent = (Get-CimInstance win32_process |
        Where-Object processid -eq (Get-CimInstance win32_process |
        Where-Object processid -eq $pid).parentprocessid)
    if ($parent.Name -eq "explorer.exe"){
        $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
        # $newProcess.Arguments = "-nologo";
        [System.Diagnostics.Process]::Start($newProcess);
        exit
    }
    else {
        Write-Host "Windows Terminal is parent process, not closing..."
    }
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

function Search-Dir {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$FileName,
        [string]$Directory="C:\"
    )

    Write-Host "Searching $Directory for $FileName..."
    return Get-ChildItem -Path "$Directory" -Filter "$FileName" -Recurse -ErrorAction SilentlyContinue -Force
}