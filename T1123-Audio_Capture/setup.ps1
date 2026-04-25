#Requires -RunAsAdministrator
$PlayerUsr = "player"; $PlayerPwd = ConvertTo-SecureString "Player@123!" -AsPlainText -Force
$FlagPath  = "C:\Windows\System32\flag_T1123.txt"
$Flag      = "HACKTIFY{AUDIO_CAPTURE_$($env:COMPUTERNAME)}"
if (-not (Get-LocalUser $PlayerUsr -EA SilentlyContinue)) {
    New-LocalUser $PlayerUsr -Password $PlayerPwd -FullName "Player" -PasswordNeverExpires
    Add-LocalGroupMember -Group "Administrators" -Member $PlayerUsr }
Set-Content $FlagPath $Flag
$acl = Get-Acl $FlagPath; $acl.SetAccessRuleProtection($true,$false)
$acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl","Allow")))
Set-Acl $FlagPath $acl
# Create the audio capture demo script
@'
# T1123 – Audio Capture Demo using Windows NAudio concepts
# (Simulates what a real audio capture implant does)
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class AudioCapture {
    [DllImport("winmm.dll")] public static extern int mciSendString(string cmd, System.Text.StringBuilder ret, int size, IntPtr hwnd);
    public static bool IsAudioAvailable() {
        try {
            var sb = new System.Text.StringBuilder(128);
            int r = mciSendString("sysinfo waveaudio quantity", sb, 128, IntPtr.Zero);
            return r == 0;
        } catch { return false; }
    }
}
"@

Write-Host "=== T1123 Audio Capture Demonstration ==="
Write-Host ""
Write-Host "[*] Checking audio devices..."
$audioAvailable = [AudioCapture]::IsAudioAvailable()
Write-Host "  Audio subsystem available: $audioAvailable"

Write-Host ""
Write-Host "[*] Audio capture techniques attackers use:"
Write-Host "  1. Windows WaveIn API (mciSendString 'open new type waveaudio alias rec')"
Write-Host "  2. NAudio library (C#/.NET) — full microphone recording"
Write-Host "  3. SoundRecorder.exe (Windows XP/Vista era)"
Write-Host "  4. PowerShell + NAudio: Record-Audio cmdlet"
Write-Host ""
Write-Host "[*] In-memory audio capture pipeline:"
Write-Host "  Mic Input → WaveIn API → Buffer → Encode (MP3/WAV) → Encrypt → Exfiltrate"
Write-Host ""
Write-Host "[*] Simulating 5-second 'recording'..."
Start-Sleep 2
Write-Host "  [Recording] 0% . . ."
Start-Sleep 1
Write-Host "  [Recording] 50% . . ."
Start-Sleep 1
Write-Host "  [Recording] 100% Complete"
Write-Host ""
Write-Host "[+] Simulated capture saved to: C:\Windows\Temp\audio_capture.wav (demo)"
Write-Host ""
Write-Host "[*] Flag (what the implant would exfiltrate with the audio):"
Get-Content "C:\Windows\System32\flag_T1123.txt"
'@ | Set-Content "C:\ProgramData\audio_capture_demo.ps1"
Set-Content "C:\Users\Public\Desktop\README.txt" @"
=== T1123 Audio Capture ===
Login   : $PlayerUsr / Player@123!
Goal    : Understand how audio capture works as a collection technique.
Step 1 : Run the demo: powershell -File C:\ProgramData\audio_capture_demo.ps1
Step 2 : Understand the WaveIn API pipeline used by real implants
Step 3 : Use mciSendString to check audio device availability
Step 4 : Retrieve the flag from $FlagPath
Note    : Real audio capture requires NAudio.dll — this is an educational simulation
"@
Write-Host "[+] T1123 setup complete."
