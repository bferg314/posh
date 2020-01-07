# Longhand
Get-ChildItem -Path V:\Myfolder -Filter CopyForbuild.bat -Recurse -ErrorAction SilentlyContinue -Force

# Shorthand
ls -r -ea silentlycontinue -fo -inc "filename.txt" | % { $_.fullname }

# Function
function Search-Dir {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$FileName,
        [string]$Directory="C:\"
    )

    return Get-ChildItem -Path "$Directory" -Filter "$FileName" -Recurse -ErrorAction SilentlyContinue -Force
}