# Enter UPN
$UPN = ""

# Enter username of user searching for
$user = ""

Connect-ExchangeOnline -UserPrincipalName 

Get-Mailbox -Identity $user | Select *
Get-MailboxStatistics -Identity $user | Select *