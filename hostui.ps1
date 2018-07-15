# Get host details
$PwshHost = Get-Host
# Get window of session
$PwshWindow = $PwshHost.UI.RawUI
# Set title of window
$PwshWindow.WindowTitle = "Hello Mate!"
# Get window size ready for new values
$NewSize = $PwshWindow.WindowSize
# Set new desired values
$NewSize.Height = 50
$NewSize.Width = 50
# Set the window size on the window
$PwshWindow.WindowSize = $NewSize