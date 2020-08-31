Function Get-FifteenInventory {

    # Get Details
    $AllProcessor = Get-CimInstance -ClassName Win32_Processor | Select-Object Name, NumberOfCores, Status
    $AllMemory = Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object Capacity
    $Machine = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Manufacturer, Model, Name, Domain, Status, SystemType
    $OSDetails = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Caption, LastBootUpTime, Manufacturer, Name, OSArchitecture, Status, Version
    $AllDisks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, FileSystem, FreeSpace, Size, VolumeName

    # Process Stuff - CPU
    Write-Host "CPU Count: $($AllProcessor.Count)" -ForegroundColor Cyan
    $CPUNumber = 1
    foreach ($Processor in $AllProcessor) {
      Write-Host "CPU $CPUNumber Name: $($Processor.Name)" -ForegroundColor Cyan
      Write-Host "CPU $CPUNumber No. of Cores: $($Processor.NumberOfCores)" -ForegroundColor Cyan
      Write-Host "CPU $CPUNumber Status: $($Processor.Status)" -ForegroundColor Cyan
      $CPUNumber++
    }

    # Process Stuff - Memory
    if ($AllMemory.Count -eq 1) {
      Write-Host "Memory: $($AllMemory.Capacity / 1GB)GB" -ForegroundColor Cyan
    }
    elseif ($AllMemory.Count -gt 1) {
      $TotalMemoryCapacity = 0
      foreach ($Memory in $AllMemory) {
        $MemoryCapacity = ($Memory.Capacity / 1GB)
        if ($TotalMemoryCapacity -eq 0) {
          $MemoryCapacityDisplay = "$($MemoryCapacity)GB"
        }
        else {
          $MemoryCapacityDisplay = "$MemoryCapacityDisplay + $($MemoryCapacity)GB"
        }
        $TotalMemoryCapacity = $TotalMemoryCapacity + $MemoryCapacity
      }
      Write-Host "Memory: $($TotalMemoryCapacity)GB ($MemoryCapacityDisplay)" -ForegroundColor Cyan
    }

    # Process Stuff - Machine
    Write-Host "Machine Manufacturer: $($Machine.Manufacturer)" -ForegroundColor Cyan
    Write-Host "Machine Model: $($Machine.Model)" -ForegroundColor Cyan
    Write-Host "Machine Name: $($Machine.Name)" -ForegroundColor Cyan
    Write-Host "Machine Domain: $($Machine.Domain)" -ForegroundColor Cyan
    Write-Host "Machine Status: $($Machine.Status)" -ForegroundColor Cyan
    Write-Host "Machine SystemType: $($Machine.SystemType)" -ForegroundColor Cyan

    # Process Stuff - OS
    Write-Host "OS Caption: $($OSDetails.Caption)" -ForegroundColor Cyan
    Write-Host "OS LastBootUpTime: $($OSDetails.LastBootUpTime)" -ForegroundColor Cyan
    Write-Host "OS Manufacturer: $($OSDetails.Manufacturer)" -ForegroundColor Cyan
    Write-Host "OS Device: $(($OSDetails.Name).Split("|")[2])" -ForegroundColor Cyan
    Write-Host "OS Location: $(($OSDetails.Name).Split("|")[1])" -ForegroundColor Cyan
    Write-Host "OS Architecture: $($OSDetails.OSArchitecture)" -ForegroundColor Cyan
    Write-Host "OS Status: $($OSDetails.Status)" -ForegroundColor Cyan
    Write-Host "OS Version: $($OSDetails.Version)" -ForegroundColor Cyan

    # Process Stuff - Disks
    Write-Host "Disk Count: $($AllDisks.Count)" -ForegroundColor Cyan
    $DiskNumber = 1
    foreach ($Disk in $AllDisks) {
      $DiskSize = [int][Math]::Round($Disk.Size / 1GB)
      $DiskFreeSpace = [int][Math]::Round($Disk.FreeSpace / 1GB)
      $DiskUsedSpace = $DiskSize - $DiskFreeSpace
      $DiskPercentRemaining = [int][Math]::Round(($DiskFreeSpace / $DiskSize) * 100)
      Write-Host "Disk $DiskNumber ID: $($Disk.DeviceID) ($($Disk.VolumeName))" -ForegroundColor Cyan
      Write-Host "Disk $DiskNumber FileSystem: $($Disk.FileSystem)" -ForegroundColor Cyan
      Write-Host "Disk $DiskNumber Used: $($DiskUsedSpace)GB" -ForegroundColor Cyan
      Write-Host "Disk $DiskNumber Free: $($DiskFreeSpace)GB" -ForegroundColor Cyan
      Write-Host "Disk $DiskNumber Size: $($DiskSize)GB" -ForegroundColor Cyan
      Write-Host "Disk $DiskNumber Percent Free: $($DiskPercentRemaining)%" -ForegroundColor Cyan
      $DiskNumber++
    }

}

Get-FifteenInventory