# Functions Here
Function Get-IPtoINT64() {
    param ($ip)
    $octets = $ip.split(".")
    return [int64]([int64]$octets[0] * 16777216 + [int64]$octets[1] * 65536 + [int64]$octets[2] * 256 + [int64]$octets[3])
}
Function Get-INT64toIP() {
    param ([int64]$int)
    return (([math]::truncate($int / 16777216)).tostring() + "." + ([math]::truncate(($int % 16777216) / 65536)).tostring() + "." + ([math]::truncate(($int % 65536) / 256)).tostring() + "." + ([math]::truncate($int % 256)).tostring() )
}

Function Get-FifteenNetworkDetails {

    # Get my IP address(es)
    $MyNetworks = Get-NetIPAddress | Where-Object { $_.IPv4Address -ne "127.0.0.1" -and $_.AddressFamily -ne "IPv6" }

    # Connections Count
    Write-Host "Connections Count: $($MyNetworks.Count)" -ForegroundColor Cyan

    foreach ($MyNetwork in $MyNetworks) {
        
        # Details
        Write-Host "Connection Alias: ""$($MyNetwork.InterfaceAlias)""" -ForegroundColor Cyan

        # If DHCP
        if ($MyNetwork.PrefixOrigin -eq "Dhcp" -and $MyNetwork.SuffixOrigin -eq "Dhcp") {
            Write-Host "DHCP: True" -ForegroundColor Cyan
        }

        # IP, Subnet Mask, Network, Broadcast
        $MyIPv4 = $MyNetwork.IPAddress
        $MyCidr = [int]$MyNetwork.PrefixLength
        $ipaddr = [Net.IPAddress]::Parse($MyIPv4)
        $maskaddr = [Net.IPAddress]::Parse((Get-INT64toIP -int ([convert]::ToInt64(("1" * $MyCidr + "0" * (32 - $MyCidr)), 2))))
        $networkaddr = new-object net.ipaddress ($maskaddr.address -band $ipaddr.address)
        $broadcastaddr = new-object net.ipaddress (([system.net.ipaddress]::parse("255.255.255.255").address -bxor $maskaddr.address -bor $networkaddr.address))

        # IP, Subnet Mask, Network, Broadcast,
        Write-Host "IP Address: $($ipaddr.IPAddressToString)" -ForegroundColor Magenta
        Write-Host "SN Address: $($maskaddr.IPAddressToString)" -ForegroundColor Magenta
        Write-Host "NW Address: $($networkaddr.IPAddressToString)" -ForegroundColor Magenta
        Write-Host "BC Address: $($broadcastaddr.IPAddressToString)" -ForegroundColor Magenta

    }

}