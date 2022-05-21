Write-Host "Time to stay awake!!!"
[int]$minutes = Read-Host -Prompt "How many minutes do you want to avoid sleep?" 

$wsh = New-Object -ComObject WScript.Shell
$minutes = $minutes * 60

For ($i=$minutes; $i -gt 0; $i--) {
    Start-Sleep -Milliseconds 1000
    $ts = [timespan]::fromseconds($i)
    Write-Progress -Activity "Staying Awake!" -Status "Time Left: $("{0:hh}h:{0:mm}m:{0:ss}s" -f $ts)" -PercentComplete (($i / $minutes) * 100) -CurrentOperation "Keeping Up!"

    if ($i % 60 -eq 0) {
        $wsh.SendKeys('+{F15}')
    }
}

