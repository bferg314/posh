Set-PSReadLineOption -HistoryNoDuplicates:$True
Set-PSReadLineOption -BellStyle None

# Scripts on the Path
$env:Path = "$env:Path;c:\git\posh\scripts;"

Set-Location "C:\"