<#
    .SYNOPSIS
        This PowerShell script runs the NDR_EICAR_Client.exe program on a loop to test Sophos NDR's detection capability.
    .DESCRIPTION
        Prompts user to specify number of beacon callbacks and sleep interval between callbacks to simulate C2 traffic.
        
        Prior to running script, run 'Set-Execution-Policy -Scope Process -ExecutionPolicy Unrestricted'
#>


<#
    .FUNCTIONS
#>


$startTime = Get-Date -Format hh:mm:ss
$region = @('ap-east-1','eu-central-2','sa-east-1','ap-southeast-1','us-west-1')
$limit = 100
$position = 0


$c2menu = {

    Clear-Host
    Write-Host 
    Write-Host -------------------------------------------------------------
    Write-Host "------------------` Sophos` NDR` EICAR` Client` ------------------"
    Write-Host -------------------------------------------------------------
    Write-Host 
    Write-Host C2 Activity Simulation
    Write-Host 
    Write-Host -------------------------------------------------------------
    Write-Host 
    Write-Host Current Configuration
    Write-Host 
    Write-Host $limit Beacon Callbacks
    Write-Host 10 Second Interval Between Callbacks
    Write-Host 
    Write-Host -------------------------------------------------------------
    Write-Host 
    Write-Host Press any key to continue...
    [void][System.Console]::ReadKey($true)
    # $limit = Read-Host "Specify number of beacon callbacks"
    # $sleep = Read-Host "Specify time in seconds between callbacks"
    Write-Host 
    Write-Host -------------------------------------------------------------
    
    }

    $c2status = {

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
    
        Clear-Host
        Write-Host 
        Write-Host -------------------------------------------------------------
        Write-Host ------------------` Sophos` NDR` EICAR` Client` ------------------
        Write-Host -------------------------------------------------------------
        Write-Host
        Write-Host Simulated C2 activity 'in' progress...
        Write-Host
        Write-Host -------------------------------------------------------------
        Write-Host "` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` Beacon` Statistics` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` "
        Write-Host -------------------------------------------------------------
        Write-Host
        Write-Host "Callback Attempts: "$attempt
        Write-Host "Region:"$region[$position]
        Write-Host 
        Write-Host Time Elapsed -  $EThrs hours $ETmins minutes $ETsecs seconds
        Write-Host
        Write-Host * Stats refresh each sleep interval
        # Write-Host
        Write-Host -------------------------------------------------------------
    
    }


<#
.C2 MENU
#>

Invoke-Command -ScriptBlock $c2menu


<#
.LOOP
#>

    for ($attempt=0; $attempt -le $limit; $attempt++)
    {
            
        Invoke-Command -ScriptBlock $c2status

        ./NdrEicarClient.exe --region $region[$position] 2>&1 | Out-File -FilePath ./eicar_output

        if($position -ge 4) {
        $position = 0    
        }
        else{
            $position++
        }
    
        Start-Sleep -Seconds 10
    
    }

<#
   .end loop / output runtime results
#>

$endTime = Get-Date -Format hh:mm:ss
$duration = New-TimeSpan -Start $startTime -End $endTime

Clear-Host
Write-Host 
Write-Host ---------------------------------------------------------------
Write-Host "------------------` Sophos` NDR` EICAR` Client` --------------------"
Write-Host ---------------------------------------------------------------
Write-Host
Write-Host Simulated C2 Channel Closed
Write-Host
Write-Host "Time Elapsed `(hh:mm:ss`) - "$duration
Write-Host "Callbacks Attempted - "$limit
Write-Host
Write-Host Check the Sophos Central Threat Analysis Center 'for' detections.
Write-Host
Write-Host ---------------------------------------------------------------
Start-Sleep -Seconds 30

Clear-Host
