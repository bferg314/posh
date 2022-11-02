param (
    [parameter(mandatory = $true)]
    [string]$AppPoolName = ""
)

try {
    if (get-module -name "IISAdministration") {
        if (-not(get-module -listavailable | where-object { $_.Name -eq "IISAdministration" })) {
            write-host "IISAdministration Module not available, exiting..." -foreground red
        }
        else {
            write-host ">> Attempting to restart My Website..." -foreground cyan
            write-host ""
        
            import-module "IISAdministration"
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
}
catch {
    Write-Host "Exception :: $_"
}



