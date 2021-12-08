#####################
# psDashboard       #
# author: psFifteen #
# version: 0.1      #
#####################

Function Invoke-Promotion() {
    [CmdletBinding()]
    Param (
    )
    # Elevate to administrator
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        Exit
    }
}

Function Get-Settings() {
    [CmdletBinding()]
    Param (
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGrey", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Grey", "Green", "Magenta", "Red", "White", "Yellow")][string]$BackgroundColour = "Black",
        [string]$BorderCharC = "+", # Corner
        [string]$BorderCharH = "-", # Horizontal
        [string]$BorderCharV = "|", # Vertical
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGrey", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Grey", "Green", "Magenta", "Red", "White", "Yellow")][string]$BorderColour = "Magenta",
        [switch]$Command = $false,
        [switch]$ConsoleBeep = $false,
        [int]$DisplayHeight = 40, # Window Height
        [int]$DisplayWidth = 200, # Window Width
        [int]$EveningCutoff = 18, # 24Hr Clock Start Evening
        [int]$MarginLeft = 2,
        [int]$MenuPanel = -1, # -1 = Last
        [int]$NoOfPanelsX = 3,
        [int]$Padding = 1, # Always best = 1
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGrey", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Grey", "Green", "Magenta", "Red", "White", "Yellow")][string]$TextColour = "Grey",
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGrey", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Grey", "Green", "Magenta", "Red", "White", "Yellow")][string]$TitleColour = "Cyan",
        [string]$Username = $env:Username,
        [string]$WindowTitle = 'psDashboard',
        [int]$WindowX = 0,
        [int]$WindowY = 0,
        [int]$WorkingWidth = 50 # Inside Border (and padding) per panel
    )
    # Get window
    $psHost = Get-Host
    $psWindow = $psHost.UI.RawUI
    # Check values
    if ($DisplayWidth -gt $psWindow.MaxWindowSize.Width) {
        $DisplayWidth = $psWindow.MaxWindowSize.Widt
    }
    if ($DisplayHeight -gt $psWindow.MaxWindowSize.Height) {
        $DisplayHeight = $psWindow.MaxWindowSize.Height
    }
    [int]$MarginTop = [System.Math]::Round($MarginLeft / 2, 0)
    [int]$WorkingHeight = $DisplayHeight - (($MarginTop * 2) + ($Padding * 2) + 2 <# Border #>)
    if ($Command) {
        [int]$CommandX = $MarginLeft + 1 <# Border #> + $Padding
        [int]$CommandY = $MarginTop + 1 <# Command Line Break #> + $WorkingHeight
    }
    else {
        [bool]$CommandX = $false
        [bool]$CommandY = $false
    }
    # Here you go
    $Script:Settings = @{
        BackgroundColour = Optimize-Colour -Colour $BackgroundColour
        BorderCharC      = $BorderCharC
        BorderCharH      = $BorderCharH
        BorderCharV      = $BorderCharV
        BorderColour     = Optimize-Colour -Colour $BorderColour
        Command          = $Command
        CommandX         = $CommandX
        CommandY         = $CommandY
        DisplayHeight    = $DisplayHeight
        DisplayWidth     = $DisplayWidth
        EveningCutoff    = $EveningCutoff
        MarginLeft       = $MarginLeft
        MarginTop        = $MarginTop
        MenuPanel        = $MenuPanel
        NoOfPanelsX      = $NoOfPanelsX
        Padding          = $Padding
        TextColour       = Optimize-Colour -Colour $TextColour
        TitleColour      = Optimize-Colour -Colour $TitleColour
        Username         = (Get-Culture).TextInfo.ToTitleCase(($Username).ToLower())
        WindowTitle      = $WindowTitle
        WindowX          = $WindowX
        WindowY          = $WindowY
        WorkingHeight    = $WorkingHeight
        WorkingWidth     = $WorkingWidth
    }
    if ($ConsoleBeep) {
        $Script:Beep = $true
    }
    else {
        $Script:Beep = $false
    }
    Write-Verbose "Console Beep: $($Beep)"
    Return $Settings.GetEnumerator() | Sort-Object Name
}

Function Confirm-Variable() {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][array]$Name
    )
    foreach ($N in $Name) {
        if (!(Get-Variable $N -ErrorAction SilentlyContinue)) {
            Write-Warning """$((Get-Culture).TextInfo.ToTitleCase(($N).ToLower()))"" not found! Exiting..."
            Start-Sleep -Seconds 2
            Exit
        }
    }
    Return $true
}

Function Set-WindowTitle() {
    [CmdletBinding()]
    Param (
        [string]$WindowTitle = $Settings.WindowTitle,
        [Parameter(ValueFromPipeline)][string]$AdditionalTitle
    )
    if (Confirm-Variable -Name "Settings") {
        # Get window
        $psHost = Get-Host
        $psWindow = $psHost.UI.RawUI
        # Prep title
        if ($AdditionalTitle) {
            $AdditionalTitle = " - $AdditionalTitle"
        }
        # Set
        $psWindow.WindowTitle = "$($WindowTitle)$($AdditionalTitle)"
    }
}

Function Start-Display() {
    [CmdletBinding()]
    Param (
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGrey", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Grey", "Green", "Magenta", "Red", "White", "Yellow")][string]$BackgroundColour = $Settings.BackgroundColour,
        [int]$DisplayHeight = $Settings.DisplayHeight, # Window Height
        [int]$DisplayWidth = $Settings.DisplayWidth, # Window Width
        [switch]$SetOnly = $false
    )
    if (Confirm-Variable -Name "Settings") {
        # Get window
        $psHost = Get-Host
        $psWindow = $psHost.UI.RawUI
        # Check values
        if ($DisplayWidth -gt $psWindow.MaxWindowSize.Width) {
            $DisplayWidth = $psWindow.MaxWindowSize.Width
        }
        if ($DisplayHeight -gt $psWindow.MaxWindowSize.Height) {
            $DisplayHeight = $psWindow.MaxWindowSize.Height
        }
        # Set
        $psWindow.BackgroundColor = Optimize-Colour -Colour $BackgroundColour
        $psWindow.WindowSize = New-Object System.Management.Automation.Host.Size($DisplayWidth, $DisplayHeight)
        $psWindow.BufferSize = $psWindow.WindowSize
        if (!$SetOnly) {
            Set-WindowTitle
            # Clear
            Clear-Host
            Get-Borders | Out-Null
            Invoke-Borders
        }
    }
}

Function Get-Borders() {
    [CmdletBinding()]
    Param (
        [string]$BorderCharC = $Settings.BorderCharC,
        [string]$BorderCharH = $Settings.BorderCharH,
        [string]$BorderCharV = $Settings.BorderCharV,
        [int]$MarginLeft = $Settings.MarginLeft,
        [int]$Padding = $Settings.Padding,
        [int]$WorkingWidth = $Settings.WorkingWidth, # Inside Border Width
        [int]$NoOfPanelsX = $Settings.NoOfPanelsX
    )
    if (Confirm-Variable -Name "Settings") {
        # Prep left margin and lines
        for ($x = 0; $x -lt $MarginLeft; $x++) {
            $Margin += " "
        }
        $Empty = "$($Margin)$($BorderCharV)"
        $Full = "$($Margin)$($BorderCharC)"
        $PlainEmpty = "$($Margin)$($BorderCharV)"
        $PlainFull = "$($Margin)$($BorderCharC)"
        $Left = "$($Margin)$($BorderCharV)"
        for ($x = 0; $x -lt $Padding; $x++) {
            $Left += " "
            $Right += " "
        }
        # Build Xdivider
        $XDivider = $BorderCharV
        for ($x = 0; $x -lt $Padding; $x++) {
            $XDivider += " "
            $LeftBump += " "
        }
        if ($NoOfPanelsX -eq 0) { $NoOfPanelsX = 1 }
        $XPanels = @()
        for ($x = 0; $x -lt $NoOfPanelsX; $x++) { 
            # Build Xpanel(s) lines
            Remove-Variable XPanel -Force -Confirm:$false -ErrorAction SilentlyContinue
            for ($y = 0; $y -lt ($WorkingWidth + $Padding); $y++) {
                $XPanel += " "
            }
            $XPanels += $XPanel
        }
        $EmptyX = $XPanels -join $XDivider
        $Empty += "$LeftBump$EmptyX"
        # Build border length
        foreach ($XPanel in $XPanels) {
            for ($x = 0; $x -lt ($XPanel.Length + $Padding); $x++) {
                $Full += $BorderCharH
                $PlainEmpty += " "
                $PlainFull += $BorderCharH
            }
            $Full += $BorderCharC
            $PlainEmpty += " "
            $PlainFull += $BorderCharH
        }
        # Single Panel Horizontal
        $Single = $BorderCharC
        for ($x = 0; $x -lt ($XPanel.Length + $Padding); $x++) {
            $Single += $BorderCharH
        }
        $Single += $BorderCharC
        $PlainEmpty = $PlainEmpty -replace ".$"
        $PlainFull = $PlainFull -replace ".$"
        $Empty += $BorderCharV
        $PlainEmpty += $BorderCharV
        $PlainFull += $BorderCharC
        $Right += $BorderCharV
        $Script:Borders = @{
            Empty      = $Empty
            Full       = $Full
            Left       = $Left
            Margin     = $Margin
            PlainEmpty = $PlainEmpty
            PlainFull  = $PlainFull
            Right      = $Right
            Single     = $Single
        }
        Return $Borders.GetEnumerator() | Sort-Object Name
    }
}

Function Invoke-Borders() {
    [CmdletBinding()]
    Param (
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGrey", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Grey", "Green", "Magenta", "Red", "White", "Yellow")][string]$BorderColour = $Settings.BorderColour,
        [string]$Empty = $Borders.Empty,
        [string]$Full = $Borders.Full,
        [string]$PlainEmpty = $Borders.PlainEmpty,
        [string]$PlainFull = $Borders.PlainFull,
        [bool]$Command = $Settings.Command,
        [int]$MarginLeft = $Settings.MarginLeft,
        [int]$MarginTop = $Settings.MarginTop,
        [int]$Padding = $Settings.Padding,
        [int]$WorkingHeight = $Settings.WorkingHeight # Inside Border Height
    )
    if (Confirm-Variable -Name "Settings", "Borders") {
        # Show padding and border
        for ($x = 0; $x -lt $MarginTop; $x++) {
            Write-Host ""
        }
        Write-Host $Full -ForegroundColor (Optimize-Colour -Colour $BorderColour)
        if ($Command) {
            $ThisWorkingHeight = $WorkingHeight - ($Padding * 2)
        }
        else {
            $ThisWorkingHeight = $WorkingHeight + ($Padding * 2)
        }
        for ($x = 0; $x -lt $ThisWorkingHeight; $x++) {
            Write-Host $Empty -ForegroundColor (Optimize-Colour -Colour $BorderColour)
        }
        Write-Host $Full -ForegroundColor (Optimize-Colour -Colour $BorderColour)
        if ($Command) {
            for ($x = 0; $x -lt (($Padding * 2) + 1 <# Command Line #>); $x++) {
                Write-Host $PlainEmpty -ForegroundColor (Optimize-Colour -Colour $BorderColour)
            }
            Write-Host $PlainFull -ForegroundColor (Optimize-Colour -Colour $BorderColour)
        }
        Start-Display -DisplayWidth ($Full.Length + $MarginLeft) -SetOnly
    }
}

Function Get-WorkAreas() {
    [CmdletBinding()]
    Param (
        [int]$MarginLeft = $Settings.MarginLeft,
        [int]$MarginTop = $Settings.MarginTop,
        [int]$NoOfPanelsX = $Settings.NoOfPanelsX,
        [int]$Padding = $Settings.Padding,
        [int]$WorkingHeight = $Settings.WorkingHeight, # Inside Border Height
        [int]$WorkingWidth = $Settings.WorkingWidth   # Inside Border Width
    )
    if (Confirm-Variable -Name "Settings") {
        $Ys = @()
        $Xs = @()
        $Ys += $MarginTop + 1 <# Border #> + $Padding
        $X = $MarginLeft + 1 <# Border #> + $Padding
        $NextX = $WorkingWidth + ($Padding * 2) + 1 <# Border #>
        for ($z = 0; $z -lt $NoOfPanelsX; $z++) {
            $Xs += $X
            $X = $X + $NextX
        }
        $Script:WorkAreas = @{
            X = $Xs
            Y = $Ys
        }
        Return $WorkAreas.GetEnumerator() | Sort-Object Name
    }
}

Function Set-Cursor() {
    [CmdletBinding()]
    Param (
        [bool]$Command = $Settings.Command,
        $CommandX = $Settings.CommandX,
        $CommandY = $Settings.CommandY,
        $DisplayHeight = $Settings.DisplayHeight,
        $X = $false,
        $Y = $WorkAreas.Y
    )
    if (Confirm-Variable -Name "Settings", "WorkAreas") {
        # Get window
        $psHost = Get-Host
        $psWindow = $psHost.UI.RawUI
        $Cursor = New-Object -TypeName System.Management.Automation.Host.Coordinates
        # For showing X locations
        if ($Y.Count -gt 1) {
            $Y = $Y | Select-Object -First 1
        }
        if ($X.Count -gt 1) {
            foreach ($Xx in $X) {
                $Cursor.X = $Xx
                $Cursor.Y = $Y
                $psWindow.CursorPosition = $Cursor
                Write-Host "X" -ForegroundColor Green -NoNewline
            }
            if ($Command) {
                $Cursor.X = $CommandX
                $Cursor.Y = $CommandY
                $psWindow.CursorPosition = $Cursor
            }
            else {
                # Last line
                $Cursor.X = 0
                $Cursor.Y = $DisplayHeight - 1
                $psWindow.CursorPosition = $Cursor
            }
        }
        elseif ($X) {
            $Cursor.X = $X
            $Cursor.Y = $Y
            $psWindow.CursorPosition = $Cursor
        }
        elseif ($Command) {
            $Cursor.X = $CommandX
            $Cursor.Y = $CommandY
            $psWindow.CursorPosition = $Cursor
        }
        else {
            # Last line
            $Cursor.X = 0
            $Cursor.Y = $DisplayHeight - 1
            $psWindow.CursorPosition = $Cursor
        }
    }
}

Function Optimize-WriteLength() {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline)][array]$Value,
        [int]$WorkingWidth = $Settings.WorkingWidth
    )
    if (Confirm-Variable -Name "Settings") {
        if ($Value.Length -gt $WorkingWidth) {
            $Value = "$($Value.Substring(0, ($WorkingWidth - 3)))..."
        }
        Return $Value
    }
}

Function Optimize-Colour() {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline)][ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGrey", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Grey", "Green", "Magenta", "Red", "White", "Yellow")][string]$Colour
    )
    # Because I'm British!
    $Colour = $Colour.Replace("Grey", "Gray")
    Return $Colour
}

Function Write-Panel() {
    [CmdletBinding()]
    Param (
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGrey", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Grey", "Green", "Magenta", "Red", "White", "Yellow")][string]$BorderColour = $Settings.BorderColour,
        [bool]$Command = $Settings.Command,
        [switch]$Horizontal = $false,
        [int]$Line = 0,
        [int]$NoOfPanelsX = $Settings.NoOfPanelsX,
        [int]$Panel = 0,
        [int]$Padding = $Settings.Padding,
        [string]$Single = $Borders.Single,
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGrey", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Grey", "Green", "Magenta", "Red", "White", "Yellow")][string]$TextColour = $Settings.TextColour,
        [Parameter(ValueFromPipeline)][array]$Value,
        $X = $WorkAreas.X,
        $Y = $WorkAreas.Y,
        [int]$WorkingHeight = $Settings.WorkingHeight
    )
    if (Confirm-Variable -Name "Settings", "Borders", "WorkAreas") {
        if ($Command) {
            $WorkingHeight = $WorkingHeight - (($Padding * 3) + 2 <# Border and Command Line #>)
        }
        if ($Panel -lt $NoOfPanelsX) {
            $X = $X[$Panel]
        }
        else {
            $X = $X[($NoOfPanelsX - 1)]
        }
        if ($Line -lt $WorkingHeight) {
            $Y = $Y[0] + $Line
        }
        else {
            $Y = $Y[0] + $WorkingHeight
        }
        if ($Horizontal) {
            $X = $X - $Padding - 1 <# Border #>
            $Value = $Single
            $TextColour = $BorderColour
        }
        foreach ($V in $Value) {
            Set-Cursor -X $X -Y $Y
            $OptimisedValue = $V | Optimize-WriteLength
            Write-Host "$OptimisedValue" -ForegroundColor (Optimize-Colour -Colour $TextColour) -NoNewline
            $Y++
        }
        Set-Cursor
    }
}

Function Set-Beep() {
    [CmdletBinding()]
    Param (
        [switch]$Disable = $false,
        [switch]$Enable = $false
    )
    if (Confirm-Variable -Name "Beep") {
        if ($Disable) {
            $Script:Beep = $false
        }
        elseif ($Enable) {
            $Script:Beep = $true
        }
        else {
            $Script:Beep = $false
        }
    }
}

Function Switch-Beep() {
    [CmdletBinding()]
    Param (
    )
    if (Confirm-Variable -Name "Beep") {
        if ($Script:Beep) {
            Set-Beep -Disable
        }
        else {
            Set-Beep -Enable
        }
    }
}

Function Clear-Keys() {
    [CmdletBinding()]
    Param (
        $psHost = (Get-Host)
    )
    $psWindow = $psHost.UI.RawUI
    $psWindow.FlushInputBuffer()
}

Function Get-ConsoleBeep() {
    [CmdletBinding()]
    Param (
        $GetBeep = $Script:Beep
    )
    if (Confirm-Variable -Name "Beep") {
        if ($GetBeep) {
            [System.Console]::Beep(1800, 200)
        }
    }
}

Function Get-PauseCommand() {
    [CmdletBinding()]
    Param (
    )
    Write-Host "Press a button to continue... " -NoNewline
    Remove-Variable PressedKey -Force -Confirm:$false -ErrorAction SilentlyContinue
    :loopPauseCommand Do {
        if ([System.Console]::KeyAvailable) {
            $PressedKey = [Console]::ReadKey($true)
            Get-ConsoleBeep
            if ($PressedKey.Key) {
                Break loopPauseCommand
            }
        }
    } While ($true)
    Return $PressedKey.Key
}

Function Get-Greeting() {
    [CmdletBinding()]
    Param (
        $EveningCutoff = $Settings.EveningCutoff
    )
    if (Confirm-Variable -Name "Settings") {
        $AMPM = Get-Date -Format "tt"
        $TimeHH = Get-Date -Format "HH"
        if ($AMPM -eq 'AM') {
            $Greeting = "Good Morning, $($Settings.Username)."
        }
        elseif ($AMPM -eq 'PM' -and $TimeHH -lt $Settings.EveningCutoff) {
            $Greeting = "Good Afternoon, $($Settings.Username)."
        }
        elseif ($AMPM -eq 'PM' -and $TimeHH -ge $Settings.EveningCutoff) {
            $Greeting = "Good Evening, $($Settings.Username)."
        }
        else {
            $Greeting = "Hello, $($Settings.Username)."
        }
        Return $Greeting
    }
}

Function Set-Menu() {
    [CmdletBinding()]
    Param (
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGrey", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Grey", "Green", "Magenta", "Red", "White", "Yellow")][string]$TextColour = $Settings.TextColour,
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGrey", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Grey", "Green", "Magenta", "Red", "White", "Yellow")][string]$TitleColour = $Settings.TitleColour
    )
    if (Confirm-Variable -Name "Settings") {
        $Script:Menu = @()
        $Script:Menu += $true | Select-Object @{l = 'Value'; e = { Get-Greeting } }, @{l = 'Line'; e = { 0 } }, @{l = 'TextColour'; e = { Optimize-Colour -Colour $TitleColour } }, @{l = 'Horizontal'; e = { $false } }
        $Script:Menu += $true | Select-Object @{l = 'Value'; e = { $false } }, @{l = 'Line'; e = { 2 } }, @{l = 'TextColour'; e = {} }, @{l = 'Horizontal'; e = { $true } }
    }
}

Function Get-Menu() {
    [CmdletBinding()]
    Param (
        $Menu = $Script:Menu,
        $Panel = $Settings.MenuPanel
    )
    if (Confirm-Variable -Name "Settings", "Menu") {
        foreach ($M in $Menu) {
            if ($M.Horizontal) {
                Write-Panel -Horizontal -Line $M.Line -Panel $Panel
            }
            elseif ($M.Value) {
                Write-Panel -Value $M.Value -Line $M.Line -Panel $Panel -TextColour $M.TextColour
            }
        }
    }
}

Function Add-ToMenu() {
    [CmdletBinding()]
    Param (
        [switch]$Horizontal,
        [int]$Line = 0,
        $Script:Menu = $Script:Menu,
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGrey", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Grey", "Green", "Magenta", "Red", "White", "Yellow")][string]$TextColour = $Settings.TextColour,
        [array]$Value = $false
    )
    if (Confirm-Variable -Name "Settings", "Menu") {
        foreach ($V in $Value) {
            $Script:Menu += $V | Select-Object @{l = 'Value'; e = { $_ } }, @{l = 'Line'; e = { $Line } }, @{l = 'TextColour'; e = { Optimize-Colour -Colour $TextColour } }, @{l = 'Horizontal'; e = { $Horizontal } }
        }
    }
}

Invoke-Promotion
Get-Settings -Command -Username "Fifteen" -ConsoleBeep | Out-Null
Start-Display
Get-WorkAreas
Set-Menu
$l = 7
Do {
    Clear-Host
    Invoke-Borders
    Get-Menu
    Set-Cursor
    $Key = Get-PauseCommand
    Add-ToMenu -Value "Test $l" -Line $l -TextColour Red
    $l++
    $l++
    Add-ToMenu -Line $l -Horizontal
    $l++
} Until ($Key -eq "Q")