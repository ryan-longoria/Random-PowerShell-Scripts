$user = ""
Write-Output $user
do {
	Get-Date
	Get-ADUser $user -Properties * | Select-Object Lockedout
	start-sleep -Seconds 60
} until ($infinity)