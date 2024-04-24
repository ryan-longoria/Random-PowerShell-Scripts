$DeviceList = @()
$Usernames = Import-CSV "Users.csv"

foreach ($Username in $Usernames) {
    $UPN = $Username.'UserPrincipalName'
    Get-AzureADUserRegisteredDevice -ObjectId $UPN | ForEach-Object {
        $DeviceList += New-Object PSObject -property @{
            DeviceOwner = $UPN
            DeviceName = $_.DisplayName
            DeviceOSType = $_.DeviceOSType
            ApproximateLastLogonTimeStamp = $_.ApproximateLastLogonTimeStamp
        }
    }
}
$DeviceList | Select DeviceOwner, DeviceName, DeviceOSType, ApproximateLastLogonTimeStamp