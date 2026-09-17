netsh wlan connect name="alcohol"

# Wait for connection
Start-Sleep -Seconds 2

# Get default gateway
$ServerIp = (Get-NetIPConfiguration |
    Where-Object { $_.IPv4DefaultGateway } |
    Select-Object -First 1).IPv4DefaultGateway.NextHop

if (-not $ServerIp) {
    Write-Host "No gateway found."
    exit 1
}

Write-Host "Connecting to $ServerIp..."

# SSH into ther server and open a proxy
ssh -D 1080 $ServerIp -p 8022

netsh wlan disconnect
