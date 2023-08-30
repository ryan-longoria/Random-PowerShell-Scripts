$hostname = ""
$service = ""

Get-Service -ComputerName $hostname -Name $service | Stop-Service -Force
Get-Service -ComputerName $hostname -Name $service | Start-Service
