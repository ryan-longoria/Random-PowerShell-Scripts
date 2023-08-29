#Variables used for copying drivers over
$IPAddr = (Get-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily "IPv4").IPAddress
$SplitIPAddr = @($IPAddr.Split("."))
$integer = [int]$SplitIPAddr[2]
IF ($integer -le 10) {
    $StoreNumber = "1" + $SplitIPAddr[1] + "0" + $SplitIPAddr[2]
    } Else {
    $StoreNumber = "1" + $SplitIPAddr[1] + $SplitIPAddr[2]
}

# Prevents the Element Not Found error when installing drivers.
CD HKLM:\
Set-Itemproperty -path 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion' -Name 'DevicePath' -value '%SystemRoot%\inf'
CD C:\

Write-Host "Installing printer drivers."

# Lexmark Driver Install

$DriverTest = Test-path ""
IF ($DriverTest -like "False") {
    New-Item -ItemType Directory -Path "C:\Drivers\Printers"
    New-Item -ItemType Directory -Path "C:\Drivers\Temp"
    Copy-Item -Path "" -Destination "C:\Drivers\Temp" -Recurse
    Set-Location "C:\Drivers\Temp"
    cmd.exe /c "C:\Program Files\7-Zip\7z.exe" x "C:\Drivers\Temp\x64_Printers.zip" -o*
    Copy-Item -Path "" -Destination "" -Recurse
    Remove-Item -Path "C:\Drivers\Temp\*" -Recurse -Force
}

$DriverLocation = ""
# Must enter in driver locations manually in paths above

pnputil.exe -a $DriverLocation
ping localhost -n 10 > null
$LexmarkDriverName = "Lexmark Universal v2 XL"
Add-PrinterDriver -Name $LexmarkDriverName
# Obtains the default gateway of the workstation that we're running the script on.
$DefaultGateway = ((Get-NetIPConfiguration -InterfaceAlias Ethernet).IPv4DefaultGateway).NextHop

# Sets the IP address for the main printer.
If ($DefaultGateway.length -eq 8) {
    $MainPrinter = -join($DefaultGateway.substring(0,7),"99")
    } Else {
    $MainPrinter = -join($DefaultGateway.substring(0,8),"99")
}

# Sets the IP address for the backup printer.
If ($DefaultGateway.length -eq 8) {
    $BackupPrinter = -join($DefaultGateway.substring(0,7),"98")
    } Else {
    $BackupPrinter = -join($DefaultGateway.substring(0,8),"98")
}

# If printer is on a different IP, remark the two above blocks out and use the following variables:
# $MainPrinter = "USE IP ADDRESS"
# $BackupPrinter = "USE IP ADDRESS"

# Adds the printer ports for the main and backup printers.
Add-PrinterPort -Name $MainPrinter -PrinterHostAddress $MainPrinter
Add-PrinterPort -Name $BackupPrinter -PrinterHostAddress $BackupPrinter

# Adds the printers to Print Management.
Add-Printer -Name "REPORTS-MAIN" -DriverName $LexmarkDriverName -PortName $MainPrinter
Add-Printer -Name "REPORTS-BACKUP" -DriverName $LexmarkDriverName -PortName $BackupPrinter
Add-Printer -Name "WU-MAIN" -DriverName $LexmarkDriverName -PortName $MainPrinter
Add-Printer -Name "WU-BACKUP" -DriverName $LexmarkDriverName -PortName $BackupPrinter

# Defaults the WU printers to print on legal-sized paper (the size that the Western Union paper is).
Set-PrintConfiguration -PrinterName WU-MAIN -PaperSize Legal
Set-PrintConfiguration -PrinterName WU-BACKUP -PaperSize Legal