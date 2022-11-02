param (
    [parameter(mandatory = $true)]
    [string]$AppPoolName = ""
)

$ModuleName = "WebAdministration"

try {

    if (get-module -name $ModuleName) {
        if (-not(get-module -listavailable | where-object { $_.Name -eq $ModuleName })) {
            write-host "$ModuleName Module not available, exiting..." -foreground red
        }
        else {
            write-host ">> Attempting to restart My Website..." -foreground cyan
            write-host ""
        
            import-module $ModuleName
            $poolState = (Get-WebAppPoolState $AppPoolName).value
            if ($poolState) {
                Write-Host "$AppPoolName is currently $poolState"
                restart-webapppool $AppPoolName
                Write-Host "$AppPoolName was succesfully restarted"
            }
            else {
                Write-Host "$AppPoolName is unavailable"
                exit 1
            }
        }
    } else {
        Write-Host "Unable to find Module $ModuleName"
    }
}
catch {
    Write-Host "Exception :: $_"
}



