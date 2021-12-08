Function Out-FifteenGrid() {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][array]$Data,
        [ValidateSet('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Grey', 'DarkGrey', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')][string]$GridColour = $Host.UI.RawUI.ForegroundColor,
        [ValidateSet('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Grey', 'DarkGrey', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')][string]$HeaderColour = $Host.UI.RawUI.ForegroundColor,
        [array]$Headings,
        [switch]$IgnoreLineColour,
        [switch]$ShowColourColumn
    )
    # Some Default Settings to adjust in one place for this function
    $IgnoreThisColourColumnName = "Colour" # "Colour"
    $VerticalGridChar = "|"      # "|""
    $CornerGridChar = "+"      # "+""
    $HorizontalGridChar = "-"      # "-"
    $PaddingGridChar = " "      # " "
    # I'm British, but this is American! :(
    $GridColour = $GridColour.Replace('Grey', 'Gray')
    $HeaderColour = $HeaderColour.Replace('Grey', 'Gray')
    # Prepare for invalid colours found
    $ShowError = @()
    # Build array of valid colours
    $AllColours = [enum]::GetValues([System.ConsoleColor]) | Where-Object { $_ -ne $Host.UI.RawUI.BackgroundColor }
    # Get default foreground colour
    $DefaultColour = "$($Host.UI.RawUI.ForegroundColor)"
    # Override grid colour if not in list of approved colours or matches default background colour
    if (!($AllColours | Where-Object { $_ -eq $GridColour }) -or $Host.UI.RawUI.BackgroundColor -eq $GridColour) {
        $ShowError += $GridColour
        $GridColour = $DefaultColour
    }
    # Override headers colour if not in list of approved colours or matches default background colour
    if (!($AllColours | Where-Object { $_ -eq $HeaderColour }) -or $Host.UI.RawUI.BackgroundColor -eq $HeaderColour) {
        $ShowError += $HeaderColour
        $HeaderColour = $DefaultColour
    }
    # If no headings are specified, get the ones from the provided data
    if (!$Headings) {
        $Headings = ($Data | Get-Member -MemberType NoteProperty | Sort-Object).Name
    }
    # Check for longest length item in each column, per heading and pad to the right accordingly
    $PaddedHeadings = @()
    foreach ($H in $Headings) {
        Remove-Variable -Name "MaxLength$H" -Force -Confirm:$false -ErrorAction SilentlyContinue
        New-Variable -Name "MaxLength$H" -Value ($Data.$H | ForEach-Object { $_.Length } | Sort-Object -Descending | Select-Object -First 1)
        if ($H -ne $IgnoreThisColourColumnName -or ($H -eq $IgnoreThisColourColumnName -and $ShowColourColumn)) {
            $PaddedHeadings += $H | Select-Object @{l = 'Name'; e = { $_ } }, @{l = 'Heading'; e = { (([string]$_).PadRight((Get-Variable -Name "MaxLength$H" -ValueOnly), "$PaddingGridChar")) } }
        }
    }
    # Created Full Heading
    $FullPaddedHeading = "$VerticalGridChar$PaddingGridChar$($PaddedHeadings.Heading -join "$PaddingGridChar$VerticalGridChar$PaddingGridChar")$PaddingGridChar$VerticalGridChar"
    # Created Full Line
    $HLine = "$CornerGridChar"
    $PaddedHeadings.Heading | ForEach-Object {
        $HLine = "$HLine$HorizontalGridChar"
        for ($HL = 1; $HL -le ($_.Length); $HL++) {
            $HLine = "$HLine$HorizontalGridChar"
        }
        $HLine = "$HLine$HorizontalGridChar$CornerGridChar"
    }
    # Begin the output of data - format is Line, Header, Line, All Data Lines, Line
    Write-Host $HLine -ForegroundColor $GridColour
    foreach ($Char in [char[]]$FullPaddedHeading) {
        # Pipes are part of your grid
        if ($Char -eq $VerticalGridChar) {
            $CharColour = $GridColour
        }
        else {
            $CharColour = $HeaderColour
        }
        Write-Host $Char -ForegroundColor $CharColour -NoNewline
    }
    Write-Host ""
    Write-Host $HLine -ForegroundColor $GridColour
    foreach ($D in $Data) {
        # Check for length of matching header (and padding), and match padding to the right accordingly
        $PaddedDataLine = @()
        foreach ($H in $Headings) {
            if ($H -ne $IgnoreThisColourColumnName -or ($H -eq $IgnoreThisColourColumnName -and $ShowColourColumn)) {
                $PaddedDataLine += "$(([string]$D.$H).PadRight((($PaddedHeadings | Where-Object {$_.Name -eq $H}).Heading.Length), $PaddingGridChar))"
            }
        }
        # Created Full Data Line
        $FullPaddedLine = "$VerticalGridChar$PaddingGridChar$($PaddedDataLine -join "$PaddingGridChar$VerticalGridChar$PaddingGridChar")$PaddingGridChar$VerticalGridChar"
        foreach ($Char in [char[]]$FullPaddedLine) {
            # Pipes are part of your grid
            if ($Char -eq $VerticalGridChar) {
                $CharColour = $GridColour
            }
            else {
                # Check to see if we are ignoring the "Colour"
                if ($IgnoreLineColour) {
                    $CharColour = $DefaultColour
                }
                else {
                    # See if "Colour" column was set in data and use value to write colourful data lines
                    Try {
                        Get-Variable "MaxLength$IgnoreThisColourColumnName" -ErrorAction Stop | Out-Null
                        $CharColour = $D.Colour
                        if ($Host.UI.RawUI.BackgroundColor -eq $D.Colour) {
                            $ShowError += $D.Colour
                            $CharColour = $DefaultColour
                        }
                        if (!($AllColours | Where-Object { $_ -eq $CharColour })) {
                            $ShowError += $CharColour
                            $CharColour = $DefaultColour
                        }
                    }
                    Catch {
                        $CharColour = $DefaultColour
                    }
                }
            }
            Write-Host $Char -ForegroundColor $CharColour -NoNewline
        }
        Write-Host ""
    }
    # Did we get any strange or background matching colour names specified? Show them to the user here and also show list of good options.
    Write-Host $HLine -ForegroundColor $GridColour
    if ($ShowError.Count -gt 0) {
        foreach ($SE in ($ShowError | Select-Object -Unique | Sort-Object)) {
            Write-Warning "$SE - Invalid option or it matches the background."
            Write-Warning "Valid options are: $($AllColours -join ", ")."
        }
    }
    <#

    .SYNOPSIS
    Create a neat grid for your data.
    
    .DESCRIPTION
    Creates a formatted grid from an object.
    Allows colour options for each line of data in the grid if one of the properties/columns is called "Colour".
    
    .PARAMETER Data
    Specifies the data object.
    
    .PARAMETER GridColour
    Specifies the colour of the grid frame.
    
    .PARAMETER Headings
    Specifies an array of headings that override the default and organise the data provided into a specific column order.
    
    .PARAMETER HeaderColour
    Specifies the colour of the column header text.
    
    .PARAMETER IgnoreLineColour
    Specifies if the "Colour" column should be ignored, meaning line colours will be set to default.
    
    .PARAMETER ShowColourColumn
    Specifies if the "Colour" column should be shown if it exists. Ignored if "Headings" are specified.
    
    .INPUTS
    None. You cannot pipe objects to Out-FifteenGrid.
    
    .OUTPUTS
    None. Out-FifteenGrid returns a host printed grid.
    
    .EXAMPLE
    $MyArray = Get-Module | Select-Object Name, Version, @{l='Colour';e={("Red", "Yellow", "Green", "Magenta" | Get-Random)}}
    Out-FifteenGrid -Data $MyArray
    +-----------------------------------+---------+
    | Name                              | Version |
    +-----------------------------------+---------+
    | Microsoft.PowerShell.Management   | 7.0.0.0 |
    | Microsoft.PowerShell.Security     | 7.0.0.0 |
    | Microsoft.PowerShell.Utility      | 7.0.0.0 |
    | Microsoft.WSMan.Management        | 7.0.0.0 |
    | PowerShellEditorServices.Commands | 0.2.0   |
    | PowerShellEditorServices.VSCode   | 0.2.0   |
    +-----------------------------------+---------+

    .LINK
    https://psfifteen.com/powershell

    #>
}