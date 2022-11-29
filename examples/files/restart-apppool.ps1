param (
    [parameter(mandatory = $true)]
    [string]$apppoolname,
    [parameter(mandatory = $true)]
    [ValidateSet("Check", "Reset", "Validate", "View", "ForceSuccess", "ForceError")]
    [string]$action
)

if ($action -eq "ForceSuccess") {
    Write-Host "Success return code was forced" -Foreground Green
    Exit 0
}
elseif ($action -eq "ForceError") {
    Write-Host "Failure return code was forced" -Foreground Red
    Exit 999
}

try {
    $WebAdminModule = "WebAdministration"
    if (-not(get-module -listavailable | where-object { $_.Name -eq $WebAdminModule })) {
        write-host "$WebAdminModule Module not available, exiting..." -foreground red
        exit 1
    }
    else {
        write-host ">> Attempting AppPool actions..." -foreground cyan
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
            elseif ($Action -eq "View") {
                $result = Get-WmiObject Win32_Process -Filter "name = 'w3wp.exe'" | 
                Select-Object Name, @{"name" = "ApplicationPool"; expression = {
                    (($_).CommandLine).split('"')[1] }
                }, @{"name" = "Starttime"; expression = { $_.ConvertToDateTime($_.CreationDate)
                    }
                } | Sort-Object Starttime -Descending   
                if ($result) {
                    Write-Host $result
                } else {
                    Write-Host "No app pools running"
                }      
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


