# T1115 – Clipboard Data | Assessment

## MCQ 1
Clipboard data (T1115) is a high-value collection target because:
A) The clipboard stores encrypted data  B) Users frequently copy passwords, API keys, PII, and financial data — the clipboard is a transient credential store  ✅
C) Clipboard data persists across reboots  D) Clipboard access requires admin privileges

## MCQ 2
`[System.Windows.Forms.Clipboard]::GetText()` requires:
A) Root/SYSTEM privileges  B) A running message loop (STA thread) — it works in PowerShell with Add-Type  ✅
C) Network connectivity  D) The clipboard to be non-empty

## MCQ 3
Detection of clipboard monitoring is difficult because:
A) Clipboard API calls are never logged  B) Reading clipboard content uses legitimate APIs used by thousands of apps; differentiating malicious from benign access requires EDR behavioral analysis  ✅
C) Clipboard monitors require kernel access  D) Clipboard reads generate firewall alerts

## Fill 1
PowerShell command to write text to the Windows clipboard:
**Answer:** `Set-Clipboard "text"` (or `[System.Windows.Forms.Clipboard]::SetText("text")`)

## Fill 2
Windows API function (Win32) to access clipboard content:
**Answer:** `GetClipboardData`
