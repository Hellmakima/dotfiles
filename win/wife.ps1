netsh wlan connect name="alcohol" 1>tmp

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

Write-Host "$ServerIp"

ssh -p8022 -D 1080 -q -o StrictHostKeyChecking=accept-new $ServerIp 2>tmp
