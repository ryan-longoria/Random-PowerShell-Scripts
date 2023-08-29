
$store = "1501"
$workstations = 'W01', 'W02', 'W03', 'W04', 'W05', 'W06', 'W07', 'W50', 'MGR'

For ($i = 0; $i -le $workstations.Length - 1; $i++)
{
	# get updated hostname
	$hostname = "S"+ $store + $workstations[$i]
	#$hostname = "CANDM022L"
	
	# establish Get-WmiObject classes
	$os = Get-WmiObject win32_operatingSystem -ComputerName $hostname -ErrorAction SilentlyContinue
	
	$bios = Get-WmiObject win32_bios -ComputerName $hostname -ErrorAction silentlyContinue
	
	$computersystem = Get-WmiObject Win32_ComputerSystem -ComputerName $hostname -ErrorAction SilentlyContinue
	
	$processor = Get-WmiObject Win32_Processor -ComputerName $hostname -ErrorAction SilentlyContinue
	
	#$baseboard = Get-WmiObject Win32_Processor -ComputerName $hostname -ErrorAction SilentlyContinue
	
	#$share = Get-WmiObject Win32_Share -ComputerName $hostname -ErrorAction SilentlyContinue
	
	#$logicaldisk = Get-WmiObject Win32_LogicalDisk -ComputerName $hostname -ErrorAction SilentlyContinue
	
	#$physicalmemory = Get-WmiObject Win32_PhysicalMemory -ComputerName $hostname -ErrorAction SilentlyContinue
	
	#$printer = Get-WmiObject Win32_Printer -ComputerName $hostname -ErrorAction SilentlyContinue
	
	#$product = Get-WmiObject Win32_Product -ComputerName $hostname -ErrorAction SilentlyContinue
	
	#$addremoveprograms = Get-WmiObject Win32reg_AddRemovePrograms -ComputerName $hostname -ErrorAction SilentlyContinue
	
	#$addremoveprograms64 = Get-WmiObject Win32reg_AddRemovePrograms64 -ComputerName $hostname -ErrorAction SilentlyContinue
	
	# information gathering starts
	$ComputerModel = $computersystem | Select -ExpandProperty Model
	
	$SerialNumber = $bios | select -ExpandProperty Serialnumber
	
	$OSName = $os | Select -ExpandProperty *caption*
	
	$CPUUtilization = $processor | Measure-Object -Property LoadPercentage -Average | Select -ExpandProperty Average
	
	$TotalVisibleMemory = [Math]::Floor((($os | Select -ExpandProperty *totalvisiblememorysize*) * 100) / 1MB) / 100
	
	$FreePhysicalMemory = [Math]::Floor((($os | Select -ExpandProperty *freephysicalmemory*) * 100) / 1MB) / 100
	
    if ($os.LastBootUpTime) {
		$uptime = (Get-Date) - $os.ConvertToDateTime($os.LastBootUpTime)
	}
	
	# Output system information
	Write-Output "Workstation: $hostname"
	Write-Output "Computer Model: $ComputerModel"
	Write-Output "Serial Number: $serialnumber"
	Write-Output "OS: $OSName"
	Write-Output "CPU Utilization: $CPUUtilization %"
	Write-Output "Total Visible Memory: $TotalVisibleMemory GB"
	Write-Output "Average Free Physical Memory: $FreePhysicalMemory GB"
	Write-Output ("Last boot: " + $os.ConvertToDateTime($os.LastBootUpTime) )
    Write-Output ("Uptime   : " + $uptime.Days + " Days " + $uptime.Hours + " Hours " + $uptime.Minutes + " Minutes" )
	Write-Output "`n"
}