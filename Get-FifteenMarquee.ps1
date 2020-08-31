Function Get-FifteenMarquee($Text) {

    Clear-Host
    $Length = $Text.Length

    # Start and End points
    $Start = 1
    $End = $Length
    $ZeroCharacters = 0

    # Position of Cursor on the screen, move it
    $Position = $Host.UI.RawUI.CursorPosition
    $Position.X = 4
    $Position.Y = 5

    Do {

        foreach ($Count in $Start .. $End) {

            $Host.UI.RawUI.CursorPosition = $Position
            $Characters = ($Length - $Count)
            $Text.Substring(($ZeroCharacters * $Characters),$Count).Padleft(([int]!$ZeroCharacters * $Length),' ').Padright(($ZeroCharacters * $Length),' ')
            Start-Sleep -Milliseconds 50

        }

        # Flip the counters around
        $Start = ($Length + 1) - $Start
        $End = $Length - $End
        $ZeroCharacters = 1 - $ZeroCharacters

    } Until ($Start -eq -9)

}

Get-FifteenMarquee -Text "hello there!"