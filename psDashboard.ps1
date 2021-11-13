#####################
# psDashboard       #
# author: psFifteen #
# version: 0.1      #
#####################

Function Invoke-Promotion() {
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Start-Process powershell.exe "-NoProfile -NoExit -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        Exit
    }
}

Function Get-Settings() {
    $Script:Settings = @{
        BackgroundColour = "Black"
        BorderCharacter  = "#"
        BorderColour     = "Magenta"
        DisplayHeight    = 49  # Window Height
        DisplayWidth     = 150 # Window Width
        MarginLeft       = 2
        Padding          = 1
        TextColour       = "Gray"
        TitleColour      = "Cyan"
        WindowTitle      = 'New-Dashboard'
        WindowX          = 0
        WindowY          = 0
        WorkingHeight    = 43  # Inside Border Height
        WorkingWidth     = 143 # Inside Border Width
        Username         = (Get-Culture).TextInfo.ToTitleCase(($env:Username).ToLower())
    }
}

Function Set-WindowTitle() {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline)][string]$WindowTitle
    )
    # Get window
    $psHost = Get-Host
    $psWindow = $psHost.UI.RawUI
    if ($WindowTitle) {
        $psWindow.WindowTitle = "$($Settings.WindowTitle) - $WindowTitle"
    }
    else {
        $psWindow.WindowTitle = $Settings.WindowTitle
    }
}

Function Start-Display() {
    # Get window
    $psHost = Get-Host
    $psWindow = $psHost.UI.RawUI
    $psWindow.BackgroundColor = $Settings.BackgroundColour
    $Height = $Settings.DisplayHeight
    $Width = $Settings.DisplayWidth
    if ($Width -gt $psWindow.MaxWindowSize.Width) {
        $Width = $psWindow.MaxWindowSize.Width
    }
    if ($Height -gt $psWindow.MaxWindowSize.Height) {
        $Height = $psWindow.MaxWindowSize.Height
    }
    $psWindow.WindowSize = New-Object System.Management.Automation.Host.Size($Width, $Height)
    $psWindow.BufferSize = $psWindow.WindowSize
    Set-WindowTitle
    $MemberDefinition1 = @'
[DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr hWnd, int hWndInsertAfter, int X, int Y, int cx, int cy, int wFlags);
'@
    $MemberDefinition2 = @'
[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);
'@
    $User32_1 = Add-Type -MemberDefinition $MemberDefinition1 -Name 'User32' -Namespace 'Win32' -PassThru
    $User32_2 = Add-Type -MemberDefinition $MemberDefinition2 -Name 'User32' -Namespace 'WindowAPI' -PassThru
    $CurrentProcess = Get-Process -Id $PID
    $null = $User32_2::ShowWindowAsync($CurrentProcess.MainWindowHandle, 4)
    $null = $User32_2::SetForegroundWindow($CurrentProcess.MainWindowHandle)
    $null = $User32_1::SetWindowPos($CurrentProcess.MainWindowHandle, 0x1, $Settings.WindowX, $Settings.WindowY, 0, 0, 0x0040 -bor 0x0020 -bor 0x0001)
    Set-WindowTitle
    Clear-Host
}

Function Invoke-Border {
    $BorderCharacter = $Settings.BorderCharacter
    $BorderColour = $Settings.BorderColour
    for ($x = 0; $x -lt $Settings.MarginLeft; $x++) {
        $LeftMargin += " "
    }
    $EmptyHorizontal = "$($LeftMargin)$($BorderCharacter)"
    $Horizontal += $EmptyHorizontal
    for ($x = 0; $x -lt $Settings.WorkingWidth + ($Settings.Padding * 2); $x++) {
        $EmptyHorizontal += " "
        $Horizontal += $BorderCharacter
    }
    $EmptyHorizontal += $BorderCharacter
    $Horizontal += $BorderCharacter
    for ($x = 0; $x -lt [System.Math]::Round($LeftMargin.Length / 2, 0); $x++) {
        Write-Host ""
    }
    Write-Host $Horizontal -ForegroundColor $BorderColour
    for ($x = 0; $x -lt $Settings.WorkingHeight + ($Settings.Padding * 2); $x++) {
        Write-Host $EmptyHorizontal -ForegroundColor $BorderColour
    }
    Write-Host $Horizontal -ForegroundColor $BorderColour
}

Invoke-Promotion
Get-Settings
Start-Display
Invoke-Border
$null = Read-Host