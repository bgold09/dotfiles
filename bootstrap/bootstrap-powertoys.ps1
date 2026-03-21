Write-Host "restarting PowerToys to apply new settings..."
Stop-Process -Name "PowerToys" -Force -ErrorAction SilentlyContinue
Start-Process -FilePath "$env:LOCALAPPDATA\PowerToys\PowerToys.exe"