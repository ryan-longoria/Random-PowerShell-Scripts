Import-Module ActiveDirectory

$FP = "UsernameList.xlsx"

$usernames = Import-Excel -Path $FP | Select-Object -ExpandProperty Username

foreach ($username in $usernames) {
    try {
        $user = Get-ADUser -Identity $username -Properties Manager
        if ($user.Manager) {
            $manager = (Get-ADUser -Identity $user.Manager).Name
            Write-Host "Manager: $manager | User: $username"
        } else {
            Write-Host "Manager not found | User: $username"
        }
    } catch {
        Write-Host "$username not found"
    }
}