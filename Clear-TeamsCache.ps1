Get-Process -ProcessName Teams -ErrorAction SilentlyContinue
Stop-Process -Name Teams -Force
Start-Sleep -Seconds 3

Remove-Item -Path "$env:APPDATA\Microsoft\Teams" -Recurse -Force -Confirm:$false