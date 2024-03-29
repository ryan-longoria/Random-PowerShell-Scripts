Get-Content "$_" | foreach { Add-CMDeviceCollectionDirectMembershipRule -Collectionname $_ -ResourceID (Get-CMDevice -Name $_).ResourceID }
