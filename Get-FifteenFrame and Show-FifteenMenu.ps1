Function Get-FifteenFrame($MenuItems, $Colour) {
    $BiggestLength = 0
    # Search for the biggest one ( oi, oi!)
    foreach ($MenuItem in $MenuItems) {
        if ($MenuItem.Length -gt $BiggestLength) {
            $BiggestLength = $MenuItem.Length
        }
    }
    # Create Frame
    $Frame = "+-"
    for ($i = 0; $i -lt $BiggestLength; $i++) {
        $Frame = $Frame + "-"
    }
    $Frame = $Frame + "-+"
    # Print it out
    $Frame | Write-Host -ForegroundColor $Colour
    foreach ($MenuItem in $MenuItems) {
        $PaddingOffset = $BiggestLength - $MenuItem.Length
        $FramedMenuItem = "| $MenuItem"
        for ($i = 0; $i -lt $PaddingOffset; $i++) {
            $FramedMenuItem = $FramedMenuItem + " "
        }
        $FramedMenuItem = $FramedMenuItem + " |"
        $FramedMenuItem | Write-Host -ForegroundColor $Colour
    }
    $Frame | Write-Host -ForegroundColor $Colour
}
Function Show-FifteenMenu {
    $MenuItems = @(
        "1: Press '1' for Option 1", `
            "2: Press '2' for Option 2", `
            "", `
            "R: Press 'R' to Refresh.", `
            "Q: Press 'Q' to Quit."
    )
    Get-FifteenFrame -MenuItems $MenuItems -Colour "Cyan"
}

Do {
    Do {
        Clear-Host
        Show-FifteenMenu
        $OptionSelection = Read-Host "What option did you want to select?"
        Switch ($OptionSelection) {
            '1' {
                "This is option 1" | Write-Host -ForegroundColor Cyan
                Start-Sleep 3
            }
            '2' {
                "This is option 2" | Write-Host -ForegroundColor Cyan
                Start-Sleep 3
            }
            default {
                "You have to choose an option..." | Write-Host -ForegroundColor Cyan
                $OptionSelection = 'r'
                "Refreshing..." | Write-Host -ForegroundColor Cyan
            }
            'r' { "Refreshing..." | Write-Host -ForegroundColor Cyan }
            'q' { "Cya!" | Write-Host -ForegroundColor Cyan }
        }
    } Until ($OptionSelection -eq 'q' -or $OptionSelection -eq 'r')
    # Tidy up before closing here
    if ($OptionSelection -eq 'q') {
        
    }
} While ($OptionSelection -ne 'q')