$trigger = New-SchedueldTaskTrigger -Daily -At 6am
$action = New-ScheduledTaskAction -Execute 'notepad.exe'

Set-ScheduledTask -Trigger $trigger -Action $action -TaskPath "My Tasks" -TaskName "Open-Notepad"