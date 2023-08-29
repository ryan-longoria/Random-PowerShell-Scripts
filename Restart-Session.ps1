$hostname = "s1515w01"
$service = "moneriswindowsservice"

Get-Service -ComputerName $hostname -Name $service | Stop-Service -Force
Get-Service -ComputerName $hostname -Name $service | Start-Service