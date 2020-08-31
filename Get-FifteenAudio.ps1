Function Get-FifteenAudio {

    $AudioDir = "D:\Audio"

    $searching = $True
    While ($searching) {
        if ($PlayMe -match "fail") {
            Write-Host "Artist not found, please try again." -ForegroundColor Magenta
        }
        Add-Type -AssemblyName presentationCore
        $WindowsMediaPlayer = New-Object System.Windows.Media.MediaPlayer
        $Artists = Get-ChildItem $AudioDir -Directory
        # $Artists.Count
        
        Clear-Host
        $SearchArtist = Read-Host -Prompt "Search for an Artist"
        $PlayMe = "fail"
        foreach ($Artist in $Artists) {
            $ArtistName = $Artist.Name
            if ($ArtistName -like $SearchArtist) {
                $SearchArtist = $ArtistName
                $SelectOne = Get-ChildItem "$AudioDir\$SearchArtist" | Out-GridView -OutputMode Single -Title "Searching: $SearchArtist"
                $SelectOneName = $SelectOne.Name
                $SelectOneType = $SelectOne.Mode
                if ($SelectOneType -like "d----") {
                    $SelectTwo = Get-ChildItem "$AudioDir\$SearchArtist\$SelectOneName" | Out-GridView -OutputMode Single -Title "Searching: $SearchArtist\$SelectOneName"
                    $SelectTwoName = $SelectTwo.Name
                    $SelectTwoType = $SelectTwo.Mode
                    if ($SelectTwoType -like "d----") {
                        Write-Host "Too Far Down" -ForegroundColor Yellow
                    } elseif ($SelectTwoType -like "-a---") {
                        $PlayMe = "$AudioDir\$SearchArtist\$SelectOneName\$SelectTwoName"
                        $searching = $False
                        Get-FifteenMediaPlayer -PlayMe $PlayMe -WindowsMediaPlayer $WindowsMediaPlayer
                    }
                } elseif ($SelectOneType -like "-a---") {
                    $PlayMe = "$AudioDir\$SearchArtist\$SelectOneName"
                    $searching = $False
                    Get-FifteenMediaPlayer -PlayMe $PlayMe -WindowsMediaPlayer $WindowsMediaPlayer
                }
            }
        }
    }
}

Function Get-FifteenMediaPlayer($PlayMe, $WindowsMediaPlayer) {
    
    $Host.UI.RawUI.WindowTitle = "Fifteen Media Player"
    $OldWindow = $Host.UI.RawUI
    $NewWindow = $OldWindow.WindowSize
    $NewWindow.Height = 14
    $NewWindow.Width = 100
    $OldWindow.WindowSize = $NewWindow
    $NewBuffer = $OldWindow.BufferSize
    $NewBuffer.Height = 14
    $NewBuffer.Width = 100
    $OldWindow.BufferSize = $NewBuffer
    $WindowsMediaPlayer.Open($PlayMe)
    $TrackName = ($PlayMe).Split("\")
    $TrackName = $TrackName | Select-Object -Last 1
    Start-Sleep 2 # This allows the $wmplayer time to load the audio file
    $Duration = $WindowsMediaPlayer.NaturalDuration.TimeSpan.TotalSeconds
    
    Clear-Host
    Write-Host "Now Playing... $TrackName by $SearchArtist ($Duration)" -ForegroundColor Magenta
    $WindowsMediaPlayer.Play()
    $continue = $True
    $playpause = 'Pause     '
    $stopped = ''
    While ($continue) {
        Write-Host "********************"
        Write-Host "********************"
        Write-Host "**                **"
        Write-Host "** P. $playpause  **"
        if ($stopped -match "stopped") {
            
        } else {
            Write-Host "** S. Stop        **"
        }
        Write-Host "** N. New Search  **"
        Write-Host "** X. Quit        **"
        Write-Host "**                **"
        Write-Host "********************"
        Write-Host "********************"
        Write-Host "Enter your command and press Enter `n" -ForegroundColor Green

        $choice = Read-Host

        Switch ($choice) {
            'P' {
                $SongPositionOne = $WindowsMediaPlayer.Position
                Start-Sleep 0.6
                $SongPositionTwo = $WindowsMediaPlayer.Position
                if ($SongPositionOne -lt $SongPositionTwo) {
                    Clear-Host
                    Write-Host "Paused Music... $TrackName by $SearchArtist" -ForegroundColor Magenta
                    $WindowsMediaPlayer.Pause()
                    $playpause = 'Play      '
                } else {
                    Clear-Host
                    Write-Host "Now Playing... $TrackName by $SearchArtist" -ForegroundColor Magenta
                    $WindowsMediaPlayer.Play()
                    $playpause = 'Pause     '
                    $stopped = ''
                }
            }
            'S' {
                Clear-Host
                Write-Host "Stopped Music... $TrackName by $SearchArtist" -ForegroundColor Magenta
                $WindowsMediaPlayer.Stop()
                $playpause = 'Play      '
                $stopped = 'stopped'
            }
            'N' {
                Clear-Host
                $WindowsMediaPlayer.Stop()
                $WindowsMediaPlayer.Close()
                Get-FifteenAudio
            }
            'X' {
                Clear-Host
                try {
                    $WindowsMediaPlayer.Stop()
                }
                catch {
                    Write-Host "Nothing Playing!" -ForegroundColor Yellow
                }
                try {
                    Write-Host "Closing Windows Media Player..." -ForegroundColor Magenta
                    $WindowsMediaPlayer.Close()
                }
                catch {
                    Write-Host "Not Open!" -ForegroundColor Yellow
                }
                Write-Host "Bye!" -ForegroundColor Magenta
                $continue = $False
            }
            default {
                Write-Host "Unknown choice" -ForegroundColor Red
            }
        }
    }
}

Get-FifteenAudio