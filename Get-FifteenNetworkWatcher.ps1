
Function Get-FifteenNetworkWatcher($MacAddress) {

    Clear-Host
    $DateNow = Get-Date
    $24Hours = (Get-Date).AddDays(1)

    Write-Host "*****************************************" -ForegroundColor Cyan
    Write-Host "*       psFifteen Network Watcher       *" -ForegroundColor Cyan
    Write-Host "*****************************************" -ForegroundColor Cyan

    While ($DateNow -lt $24Hours) {

        Start-Sleep 1
        $IntStatus = (Get-NetAdapter -Physical | Where-Object {$_.MacAddress -eq $MacAddress}).InterfaceOperationalStatus

        if ($IntStatus -eq 1) {

            $ConnectTime = Get-Date
            Write-Host "* " -ForegroundColor Cyan -NoNewline
            Write-Host "$ConnectTime - Connected" -ForegroundColor Green -NoNewline
            Write-Host "       *" -ForegroundColor Cyan

            do {

                Start-Sleep 1
                $IntStatus = (Get-NetAdapter -Physical | Where-Object {$_.MacAddress -eq $MacAddress}).InterfaceOperationalStatus
                $StillConnectTime = Get-Date
                Write-Host "* " -ForegroundColor Cyan -NoNewline
                Write-Host "$StillConnectTime - Still Connected" -ForegroundColor Green -NoNewline
                Write-Host " *" -ForegroundColor Cyan
                Write-Host "*****************************************" -ForegroundColor Cyan
                $CursorPosition = $Host.UI.RawUI.CursorPosition
                $CursorPosition.Y -= 2
                $Host.UI.RawUI.CursorPosition = $CursorPosition

            } until ($IntStatus -eq 2)

            $DisconnectTime = Get-Date
            Write-Host "* " -ForegroundColor Cyan -NoNewline
            Write-Host "$DisconnectTime - Disconnected" -ForegroundColor Red -NoNewline
            Write-Host "    *" -ForegroundColor Cyan -NoNewline
            $SecondsUp = ($DisconnectTime - $ConnectTime).Seconds

            if ($SecondsUp -lt 60) {

                $TimeUp = "$SecondsUp Seconds"

            } else {

                $RoundUp = [Math]::Round((240 / 60))
                $TimeUp = "$RoundUp Minutes"

            }

            Write-Host " (Uptime: $TimeUp)" -ForegroundColor Red
            Write-Host "*****************************************" -ForegroundColor Cyan

        }

    }

}

Get-FifteenNetworkWatcher -MacAddress "AA-BB-CC-11-22-33"