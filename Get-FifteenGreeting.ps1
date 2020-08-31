Function Get-FifteenGreeting {
    # Create Greeting
    $Username = "psFifteen"
    $FGColour = "Cyan"
    $AMPM = Get-Date -Format "tt"
    $TimeHH = Get-Date -Format "HH"
    if ($AMPM -eq 'AM') {
        $Greeting = "Good Morning, $Username."
    } elseif ($AMPM -eq 'PM' -and $TimeHH -lt '18') {
        $Greeting = "Good Afternoon, $Username."
    } elseif ($AMPM -eq 'PM' -and $TimeHH -gt '17') {
        $Greeting = "Good Evening, $Username."
    } else {
        $Greeting = "Hello, $Username."
    }
    $FramedGreeting = "| $Greeting |"
    # Create Frame
    $Frame = "+-"
    for ($i=0; $i -lt $Greeting.Length; $i++) {
        $Frame = $Frame + "-"
    }
    $Frame = $Frame + "-+"
    # Print it out
    $Frame | Write-Host -ForegroundColor $FGColour
    $FramedGreeting | Write-Host -ForegroundColor $FGColour
    $Frame | Write-Host -ForegroundColor $FGColour
}