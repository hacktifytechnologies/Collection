#Requires -RunAsAdministrator
$PlayerUsr = "player"; $PlayerPwd = ConvertTo-SecureString "Player@123!" -AsPlainText -Force
$FlagPath  = "C:\Windows\System32\flag_T1025.txt"
$Flag      = "HACKTIFY{REMOVABLE_MEDIA_DATA_$($env:COMPUTERNAME)}"
if (-not (Get-LocalUser $PlayerUsr -EA SilentlyContinue)) {
    New-LocalUser $PlayerUsr -Password $PlayerPwd -FullName "Player" -PasswordNeverExpires
    Add-LocalGroupMember -Group "Administrators" -Member $PlayerUsr }
# Simulate removable media as a local directory
$UsbPath = "C:\SimulatedUSB_Read"
New-Item -ItemType Directory -Path $UsbPath -Force | Out-Null
Set-Content "$UsbPath\flag.txt" $Flag
Set-Content "$UsbPath\vpn_config.ovpn" "remote corp-vpn.example.com 1194`nauth-user-pass`n# Username: vpnadmin`n# Password: VPN@C0rp2024"
Set-Content "$UsbPath\credentials.txt" "WiFi_SSID=CorpWifi`nWiFi_Pass=W1F1@Corp2024!`nServer_IP=192.168.1.100"
Set-Content "$UsbPath\backup_keys.kdbx.b64" "PLACEHOLDER_KEEPASS_DB_DATA"
Set-Content $FlagPath $Flag
$acl = Get-Acl $FlagPath; $acl.SetAccessRuleProtection($true,$false)
$acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl","Allow")))
Set-Acl $FlagPath $acl
# Create collection script
@'
# T1025 – Collect data from removable media
$UsbPath = "C:\SimulatedUSB_Read"  # Replace with actual drive: E:\, F:\, etc.
$Staging = "C:\Users\Public\usb_loot"
New-Item -ItemType Directory -Path $Staging -Force | Out-Null
Write-Host "[*] Collecting from: $UsbPath"
# Copy all files:
Copy-Item "$UsbPath\*" $Staging -Recurse -Force
# Search for credential files:
Get-ChildItem $UsbPath -Recurse -Include "*.txt","*.conf","*.ovpn","*.kdbx*","*.pfx","*.key" |
    ForEach-Object { Write-Host "[+] Found: $($_.FullName)" }
# Show sensitive content:
Get-ChildItem $Staging | ForEach-Object { Write-Host "`n=== $($_.Name) ==="; Get-Content $_ }
'@ | Set-Content "C:\ProgramData\collect_usb.ps1"
Set-Content "C:\Users\Public\Desktop\README.txt" @"
=== T1025 Data from Removable Media ===
Login   : $PlayerUsr / Player@123!
Simulated USB: C:\SimulatedUSB_Read\
Goal    : Collect all data from the simulated removable media.
Step 1 : List USB contents: Get-ChildItem C:\SimulatedUSB_Read
Step 2 : Run collector: powershell -File C:\ProgramData\collect_usb.ps1
Step 3 : Check staged data: Get-ChildItem C:\Users\Public\usb_loot\
Step 4 : Read the flag from USB: type C:\SimulatedUSB_Read\flag.txt
"@
Write-Host "[+] T1025 setup complete."
