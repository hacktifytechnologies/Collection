# T1039 – Data from Network Shared Drive | Assessment

## MCQ 1
`smbclient -L //host -N` enumerates shares using:
A) Authenticated access only  B) Null/anonymous session (guest access) to list available SMB shares  ✅
C) WMI protocol  D) NetBIOS name resolution only

## MCQ 2
An attacker mounting a network share with `mount -t cifs` gains:
A) Write access only  B) File system-level access to all files on the share, enabling bulk collection  ✅
C) Only listing capabilities  D) Encrypted access

## MCQ 3
T1039 is particularly high-value for attackers because:
A) Network shares are always unencrypted  B) Shared drives often contain sensitive business data meant for internal teams — finance, HR, configs  ✅
C) Network shares have no access controls  D) Mounted shares bypass AV scanning

## Fill 1
`smbclient` command to connect to a share and download a file:
**Answer:** `smbclient //host/share -N` then `get filename`

## Fill 2
Linux command to unmount a CIFS mount point:
**Answer:** `umount /mnt/mountpoint`
