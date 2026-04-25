# T1025 – Data from Removable Media | Assessment

## MCQ 1
T1025 (Removable Media collection) is valuable because:
A) USB drives have faster transfer speeds  B) Employees often carry sensitive data on USB drives unencrypted — VPN configs, password databases, certificates  ✅
C) Removable media bypasses DLP  D) USB data is always unencrypted

## MCQ 2
`Get-WmiObject Win32_LogicalDisk | Where-Object {$_.DriveType -eq 2}` finds:
A) CD-ROM drives  B) Network drives  C) Removable storage (USB drives, memory cards)  ✅  D) Fixed hard drives

## MCQ 3
`Get-ChildItem E:\ -Recurse -Include "*.kdbx"` searches for:
A) Excel files  B) KeePass password database files  ✅  C) Kernel files  D) JavaScript files

## Fill 1
`Win32_LogicalDisk` DriveType value for removable media:
**Answer:** `2`

## Fill 2
PowerShell cmdlet to copy files matching a pattern to a staging directory:
**Answer:** `Copy-Item -Path "source" -Destination "dest" -Recurse -Force`
