Function Get-FifteenRandomColour {

    $Colours = @("Magenta", "Red", "Yellow", "Green", "Cyan", "Gray", "White")
    $Random = Get-Random -Maximum $($Colours.Count - 1) -Minimum 0
    Return $Colours[$Random]

}

Function Get-FifteenRandomColourText($Text) {

    [char[]]$Text | ForEach-Object {

        Write-Host -NoNewline $_ -ForegroundColor $(Get-FifteenRandomColour)
        
    }

}

Function Get-FifteenRainbowText($Text) {

    $i = 0
    $Colours = @("Magenta", "Red", "Yellow", "Green", "Cyan", "Gray", "White")

    [char[]]$Text | ForEach-Object {

        Write-Host -NoNewline $_ -ForegroundColor $($Colours[$i])

        # Only break for a non-whitespace character.
        if ($_ -notmatch "\s") {
            $i++
        }

        if ($i -gt $($Colours.Count - 1)) {
            $i = 0
        }

    }

}

Try {

    # Set Background Colour
    $BG = "Black"
    $Host.UI.RawUI.BackgroundColor = $BG
    $Host.PrivateData.ConsolePaneBackgroundColor = $BG
    
    # All text in a random colour
    Write-Host "hello there!" -ForegroundColor $(Get-FifteenRandomColour)

    # All chars in text in a random colour
    Get-FifteenRandomColourText -Text "hello there!"

    # All chars in text in a "rainbow" (same order) colour
    Get-FifteenRainbowText -Text "hello there!"

}
Catch {
    Write-Host "Error = $_" -ForegroundColor Red -BackgroundColor Black
}