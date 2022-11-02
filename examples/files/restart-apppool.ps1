param (
    [parameter(mandatory = $true)]
    [string]$AppPoolName = ""
)

# $ModuleName = "IISAdministration"
$WebAdminModule = "WebAdministration"

try {
    if (-not(get-module -listavailable | where-object { $_.Name -eq $WebAdminModule })) {
        write-host "$WebAdminModule Module not available, exiting..." -foreground red
    }
    else {
        write-host ">> Attempting to restart My Website..." -foreground cyan
        write-host ""
        
        import-module $WebAdminModule
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
}
catch {
    Write-Host "Exception :: $_"
}



