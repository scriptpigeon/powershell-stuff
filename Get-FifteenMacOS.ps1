Function Get-FifteenMacOS {

    # Get current PowerShell version
    $PSVersion = $PSVersionTable.PSVersion
    # Get PowerShell module locations
    $PSModulePaths = $env:PSModulePath -split ":"

    # Output something
    Write-Host "Testing out some PowerShell on MacOS."
    Write-Host ""
    Write-Host "Is this MacOS? " -NoNewline

    # Am I running on MacOS?
    if ($IsMacOS) {
        Write-Host "Yes" -ForegroundColor "Green"

        # Show Version
        Write-Host "Your version of PowerShell is: " -NoNewline
        Write-Host "$PSVersion" -ForegroundColor Cyan

        # Logged in as
        Write-Host "You are currently logged in as: " -NoNewline
        Write-Host $env:USER -ForegroundColor Cyan

        # Module Locations
        Write-Host "PowerShell Module Path(s): " -NoNewline
        $count = 0
        foreach ($ModulePath in $PSModulePaths) {
            if ($count -match 0) {
                Write-Host "$ModulePath" -ForegroundColor Cyan
                $count++
            } else {
                Write-Host "                           $ModulePath" -ForegroundColor Cyan
            }
        }

    } else {
        Write-Host "No ($PSVersion)" -ForegroundColor "Red"
    }

}