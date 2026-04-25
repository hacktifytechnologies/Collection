# T1113 – Screen Capture | Assessment

## MCQ 1
`[System.Drawing.Graphics]::CopyFromScreen()` captures:
A) The active window only  B) A region of the physical display, including all visible content on screen  ✅
C) Only text content  D) The last rendered frame from GPU memory

## MCQ 2
Screen capture (T1113) is valuable for attackers because:
A) It reveals encryption keys  B) It captures visible credentials, MFA codes, emails, and confidential documents regardless of file system permissions  ✅
C) It breaks screen savers  D) It bypasses Windows Defender

## MCQ 3
`[System.Windows.Forms.Clipboard]::GetText()` retrieves:
A) The clipboard image  B) The current text content of the Windows clipboard, potentially including copied passwords or data  ✅
C) All clipboard history  D) Clipboard metadata

## Fill 1
Windows API function used for screen capture in native code (copies screen region to DC):
**Answer:** `BitBlt`

## Fill 2
PowerShell command to set text in the Windows clipboard:
**Answer:** `Set-Clipboard "text"`
