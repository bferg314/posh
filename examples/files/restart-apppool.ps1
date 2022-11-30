param (
    [parameter(mandatory = $true)]
    [string]$apppoolname,
    [parameter(mandatory = $true)]
    [ValidateSet("Check", "Reset", "Validate", "View", "ForceSuccess", "ForceError")]
    [string]$action
)

if ($action -eq "ForceSuccess") {
    Write-Host "Success return code was forced" -ForegroundColor Green
    Exit 0
}
elseif ($action -eq "ForceError") {
    Write-Host "Failure return code was forced" -ForegroundColor Red
    Exit 999
}

try {
    $WebAdminModule = "WebAdministration"
    if (-not(get-module -listavailable | where-object { $_.Name -eq $WebAdminModule })) {
        write-host "$WebAdminModule Module not available, exiting..." -ForegroundColor red
        exit 1
    }
    else {
        write-host ">> Attempting AppPool action $action on $apppoolname..." -ForegroundColor cyan
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
                if ($poolState -eq "stopped") {
                    Start-WebAppPool $AppPoolName
                    Write-Host "$AppPoolName was succesfully started"
                    Exit 0
                } else {
                    Restart-WebAppPool $AppPoolName
                    Write-Host "$AppPoolName was succesfully restarted"
                    Exit 0
                }
            }
            elseif ($Action -eq "Validate") {
                Write-Host "Checking if $AppPoolName was restarted recently..."
                $tenMinutesAgo = (Get-Date).AddMinutes(-10)
                $result = Get-WmiObject Win32_Process -Filter "name = 'w3wp.exe'" | 
                Select-Object Name, @{"name" = "ApplicationPool"; expression = {
                    (($_).CommandLine).split('"')[1] }
                }, @{"name" = "Starttime"; expression = { $_.ConvertToDateTime($_.CreationDate)
                    }
                } | Where-Object -Property ApplicationPool -EQ $AppPoolName

                if ($result) {
                    if ($result.Starttime -gt $tenMinutesAgo) {
                        Write-Host "The $AppPoolName app pool process is LESS than 10 minutes old $($result.Starttime)"
                        Exit 0
                    } else {
                        Write-Host "The $AppPoolName app pool process is MORE than 10 minutes old $($result.Starttime)"
                        Exit 4
                    }
                } else {
                    Write-Host "The $AppPoolName app pool process was not found"
                    Exit 4
                }
            }
            elseif ($Action -eq "View") {
                Write-Host "Looking for active app pools..."
                $result = Get-WmiObject Win32_Process -Filter "name = 'w3wp.exe'" | 
                Select-Object Name, @{"name" = "ApplicationPool"; expression = {
                    (($_).CommandLine).split('"')[1] }
                }, @{"name" = "Starttime"; expression = { $_.ConvertToDateTime($_.CreationDate)
                    }
                } | Sort-Object Starttime -Descending  

                if ($result) {
                    $result
                } else {
                    Write-Host "No app pools running"
                }      
            }
            else {
                Write-Host "No valid action provided" -ForegroundColor Red
                Exit 3
            }

        }
        else {
            Write-Host "$AppPoolName is unavailable" -ForegroundColor Red
            Exit 2
        }
    }
}
catch {
    Write-Host "Exception :: $_" -ForegroundColor Red
    Exit 99
}


