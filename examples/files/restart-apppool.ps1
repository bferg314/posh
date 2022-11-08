param (
    [parameter(mandatory = $true)]
    [string]$AppPoolName,
    [parameter(mandatory = $true)]
    [ValidateSet("Check", "Reset", "Validate")]
    [string]$Action
)

# $WebAdminModule = "IISAdministration"
$WebAdminModule = "WebAdministration"

try {
    if (-not(get-module -listavailable | where-object { $_.Name -eq $WebAdminModule })) {
        write-host "$WebAdminModule Module not available, exiting..." -foreground red
        exit 1
    }
    else {
        write-host ">> Attempting to restart My Website..." -foreground cyan
        write-host ""
        
        import-module $WebAdminModule
        $poolState = (Get-WebAppPoolState $AppPoolName).value
        if ($poolState) {
            if ($Action -eq "Check") {
                Write-Host "$AppPoolName EXISTS. State is currently $poolState"
                Exit 0
            }
            elseif ($Action -eq "Reset") {
                Write-Host "$AppPoolName is currently $poolState"
                Restart-WebAppPool $AppPoolName
                Write-Host "$AppPoolName was succesfully restarted"
                Exit 0
            }
            elseif ($Action -eq "Validate") {

            }
            else {
                Write-Host "No valid action provided"
                Exit 3
            }

        }
        else {
            Write-Host "$AppPoolName is unavailable"
            Exit 2
        }
    }
}
catch {
    Write-Host "Exception :: $_"
    Exit 99
}



