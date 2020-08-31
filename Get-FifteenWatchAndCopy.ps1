# Set the folder watch and target
$PathToMonitor = "C:\Monitor\This\Folder"
$CopyToHere = "D:\CopyTo\This\Folder"

# Set how long you want to wait for files to not change in length before copying
$SleepWait = 3

##### Nothing to change below here #####

# Start a FileSystemWatcher in an object
$FileSystemWatcher = New-Object System.IO.FileSystemWatcher
$FileSystemWatcher.Path = $PathToMonitor
$FileSystemWatcher.IncludeSubdirectories = $true

# Set emits events
$FileSystemWatcher.EnableRaisingEvents = $true

# Define change actions
$Action = {
    $Details = $event.SourceEventArgs
    # Name of file or folder
    $Name = $Details.Name
    # Full path of original file or folder
    $FullPath = $Details.FullPath
    # What type of change
    $ChangeType = $Details.ChangeType
    # Generate the new "FullPath" of file or folder
    $NewDestination = $CopyToHere + "\" + $Name
    # Get the parent of the new destination file or folder (i.e where it is going to be put)
    $NewJustDir = [system.io.path]::GetDirectoryName($NewDestination)
    # Check if the original JustDir is actually a JustDir
    $IsDirOrNot = (Get-Item $FullPath) -is [System.IO.DirectoryInfo]

    # Show that something happened in the host output (confidence)
    # $text = "{0} was {1} at {2}" -f $FullPath, $ChangeType, $Timestamp
    # Write-Host $text -ForegroundColor DarkCyan

    # Define change types
    switch ($ChangeType) {
        'Changed' {
            if ($IsDirOrNot -eq $true) {
                Write-Host "Folder ($Name) has changed! Forcing Directory... " -ForegroundColor Yellow -NoNewline
                # Force Directory Location
                New-Item -ItemType Directory -Force -Path $NewDestination
                Write-Host "Done!" -ForegroundColor Green
            } else {
                Write-Host "File ($Name) has changed! Forcing Destination Directory... " -ForegroundColor Yellow -NoNewline
                # Force Parent Directory Location
                New-Item -ItemType Directory -Force -Path $NewJustDir
                Write-Host "Done!" -ForegroundColor Green
                Write-Host "Checking the file isn't still changing in size... " -ForegroundColor Yellow -NoNewLine
                # Make sure it isn't still changing in size
                $LastLength = 1
                $NewLength = (Get-Item $FullPath).Length
                while ($NewLength -ne $LastLength) {
                    $LastLength = $NewLength
                    Write-Host "`nWaiting $SleepWait Seconds... " -ForegroundColor Green -NoNewLine
                    Start-Sleep -Seconds $SleepWait
                    $NewLength = (Get-Item $FullPath).Length
                }
                Write-Host "Done!" -ForegroundColor Green
                Write-Host "Copying to Destination... " -ForegroundColor Yellow -NoNewLine
                # Copy File
                Copy-Item -Path $FullPath -Destination $NewDestination
                Write-Host "Done!" -ForegroundColor Green
            }
        }
        'Created' {
            if ($IsDirOrNot -eq $true) {
                Write-Host "Folder ($Name) has appeared! Forcing Directory... " -ForegroundColor Yellow -NoNewline
                # Force Directory Location
                New-Item -ItemType Directory -Force -Path $NewDestination
                Write-Host "Done!" -ForegroundColor Green
            } else {
                Write-Host "File ($Name) has appeared! Forcing Destination Directory... " -ForegroundColor Yellow -NoNewline
                # Force Parent Directory Location
                New-Item -ItemType Directory -Force -Path $NewJustDir
                Write-Host "Done!" -ForegroundColor Green
                Write-Host "Checking the file isn't still changing in size... " -ForegroundColor Yellow -NoNewLine
                # Make sure it isn't still changing in size
                $LastLength = 1
                $NewLength = (Get-Item $FullPath).Length
                while ($NewLength -ne $LastLength) {
                    $LastLength = $NewLength
                    Write-Host "`nWaiting $SleepWait Seconds... " -ForegroundColor Green -NoNewLine
                    Start-Sleep -Seconds $SleepWait
                    $NewLength = (Get-Item $FullPath).Length
                }
                Write-Host "Done!" -ForegroundColor Green
                Write-Host "Copying to Destination... " -ForegroundColor Yellow -NoNewLine
                # Copy File
                Copy-Item -Path $FullPath -Destination $NewDestination
                Write-Host "Done!" -ForegroundColor Green
            }
        }
        'Deleted' {
            # Removed, Moved or Deleted
            # $text = "File {0} was removed, moved or deleted" -f $Name
            # Write-Host $text -ForegroundColor Yellow
        }
        'Renamed' { 
            # Renamed
            # $text = "File {0} was renamed to {1}" -f $OldName, $Name
            # Write-Host $text -ForegroundColor Yellow
        }
        default {
            Write-Host $_ -ForegroundColor Red -BackgroundColor White
        }
    }
}

# Set event handlers
$handlers = . {
    Register-ObjectEvent -InputObject $FileSystemWatcher -EventName Changed -Action $Action -SourceIdentifier FSChange
    Register-ObjectEvent -InputObject $FileSystemWatcher -EventName Created -Action $Action -SourceIdentifier FSCreate
    Register-ObjectEvent -InputObject $FileSystemWatcher -EventName Deleted -Action $Action -SourceIdentifier FSDelete
    Register-ObjectEvent -InputObject $FileSystemWatcher -EventName Renamed -Action $Action -SourceIdentifier FSRename
}

# Show where is being watched
Write-Host "Watching: $PathToMonitor" -ForegroundColor Cyan

try {
    do {
        # Keep adding confidence that more changes are being watched for
        Write-Host 'Watching for changes...' -ForegroundColor Cyan
        Wait-Event -Timeout 60

    } while ($true)
}
finally {
    # End script actions + CTRL+C executes the remove event handlers
    Unregister-Event -SourceIdentifier FSChange
    Unregister-Event -SourceIdentifier FSCreate
    Unregister-Event -SourceIdentifier FSDelete
    Unregister-Event -SourceIdentifier FSRename

    # Remaining cleanup
    $handlers | Remove-Job
    $FileSystemWatcher.EnableRaisingEvents = $false
    $FileSystemWatcher.Dispose()

    Write-Warning -Message 'Event Handler completed and disabled.'
}