small `scp` wrapper
on windows use
```py
subprocess.check_output(
    ["powershell", "-Command", "(Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway}).IPv4DefaultGateway.NextHop"],
    text=True,
).strip()
```

linux use
```py
    return subprocess.check_output(
        ["ip", "route", "show", "default"],
        text=True,
    ).split()[2]
```
  ```
```
```
```
