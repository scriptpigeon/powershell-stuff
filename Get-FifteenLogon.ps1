Function Get-FifteenLogon($Days) {

    # Get logs
    $EventLogs = Get-EventLog System -ComputerName fifteen-pc -Source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-$Days)
    $Results = @()

    foreach ($EventLog in $EventLogs) {

        if ($EventLog.instanceid -eq 7001) {

            # Logon Event Found
            $type = "Logon"

        }
        elseif ($EventLog.instanceid -eq 7002) {

            # Logoff Event Found
            $type = "Logoff"

        }
        else {

            Continue

        }

        $Results += New-Object PSObject -Property @{
            Time    = $EventLog.TimeWritten
            "Event" = $type
            User    = (New-Object System.Security.Principal.SecurityIdentifier $EventLog.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])
        }

    }

    # Show Results
    Return $Results | Sort-Object Time

}

Get-FifteenLogon -Days 7