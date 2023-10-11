<#
    .SYNOPSIS
        This PowerShell script runs the NDR_EICAR_Client.exe program on a loop to test Sophos NDR's detection capability.
    .DESCRIPTION
        Prompts user to specify number of beacon callbacks and sleep interval between callbacks to simulate C2 traffic.
        
        Prior to running script, run 'Set-Execution-Policy -Scope Process -ExecutionPolicy Unrestricted'
#>


    Clear-Host
    Write-Host 
    Write-Host -------------------------------------------------------------
    Write-Host ------------------` Sophos` NDR` EICAR` Client` ------------------
    Write-Host -------------------------------------------------------------
    Write-Host 
    Write-Host C2 Activity Simulation
    Write-Host
    Write-Host Callback Duration - Approximately 30 seconds
    Write-Host
    Write-Host Recommended Parameters:
    Write-Host
    Write-Host 10 Beacon Callbacks
    Write-Host 30 Second Interval Between Callbacks
    Write-Host 
    Write-Host -------------------------------------------------------------
    Write-Host 
    $limit = Read-Host "Specify number of beacon callbacks"
    $sleep = Read-Host "Specify time between callbacks (in seconds)"
    # $region=Read-Host "Specify AWS region`"
    Write-Host 
    Write-Host -------------------------------------------------------------


<#
   .set variables
#>


    $attempt = 0
    $threshold = @(1..$limit)
    $startTime = Get-Date -Format hh:mm:ss
    # Remove-item alias:curl


<#
   .begin loop
#>


    foreach ($attempt in $threshold) {

        $now = Get-Date -Format hh:mm:ss

        $elapsedTime = New-TimeSpan -Start $startTime -End $now
        IF ($elapsedTime.Seconds -lt 0) 
        {$EThrs = ($elapsedTime.Hours) + 23
        $ETmins = ($elapsedTime.Minutes) + 59
        $ETsecs = ($elapsedTime.Seconds) + 59 
        }
        ELSE 
        {$ETHrs = $elapsedTime.Hours
        $ETMins = $elapsedTime.Minutes
        $ETSecs = $elapsedTime.Seconds 
        }

        
<#
   .display runtime status
#>


            Clear-Host
            Write-Host 
            Write-Host -------------------------------------------------------------
            Write-Host ------------------` Sophos` NDR` EICAR` Client` ------------------
            Write-Host -------------------------------------------------------------
            Write-Host
            Write-Host Simulated C2 activity in progress...
            Write-Host
            Write-Host -------------------------------------------------------------
            Write-Host "` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` Beacon` Statistics` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` "
            Write-Host -------------------------------------------------------------
            Write-Host
            Write-Host Callback Attempts - ($attempt)
            Write-Host Callback Threshold - $limit
            Write-Host Sleep Interval - $sleep seconds
            Write-Host 
            Write-Host Time Elapsed -  $EThrs hours $ETmins minutes $ETsecs seconds
            Write-Host
            Write-Host * Stats refresh each sleep interval
            Write-Host
            Write-Host -------------------------------------------------------------


<#
   .run ndr eicar client

   .syntax options
   $command = { ./sophos_ndr_eicar_client.exe --region "eu-central-2" --all --extra | Out-File -FilePath ./eicar_log.txt }
   $command = { ./sophos_ndr_eicar_client.exe --region "sa-east-1" --all --extra | Out-File -FilePath ./eicar_log.txt }
   $command = { ./sophos_ndr_eicar_client.exe --region "ap-east-1" --all --extra | Out-File -FilePath ./eicar_log.txt }
   $command = { ./sophos_ndr_eicar_client.exe --region "ap-southeast-1" --all --extra | Out-File -FilePath ./eicar_log.txt }
   $command = { ./sophos_ndr_eicar_client.exe --region "us-west-1" --all --extra | Out-File -FilePath ./eicar_log.txt }
   #>

<#
   .ndr eicar client
#>

            $command = { 
                ./sophos_ndr_eicar_client.exe --region "ap-east-1" --all --extra | Out-File -FilePath ./eicar_log.txt 
            }

            Invoke-Command -ScriptBlock $command

            Start-Sleep -s $sleep
            
            $attempt++
           
             }

<#
   .output rutnime results
#>


    $endTime = Get-Date -Format hh:mm:ss
    $duration = New-TimeSpan -Start $startTime -End $endTime
    
    Clear-Host
    Write-Host 
    Write-Host ---------------------------------------------------------------
    Write-Host ------------------` Sophos` NDR` EICAR` Client` --------------------
    Write-Host ---------------------------------------------------------------
    Write-Host
    Write-Host Simulated C2 Channel Closed
    Write-Host
    Write-Host Time Elapsed `(hh:mm:ss`) - $duration
    Write-Host Callbacks Attempted - ($limit)
    Write-Host
    Write-Host Check the Sophos Central Threat Analysis Center for detections.
    Write-Host
    Write-Host ---------------------------------------------------------------
    Start-Sleep -s 30

    Clear-Host