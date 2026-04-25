# T1119 – Automated Collection | Assessment

## MCQ 1
T1119 Automated Collection differs from T1005 (manual collection) because:
A) It collects different data types  B) It uses scripts/tools to systematically collect data across many locations simultaneously without manual intervention  ✅
C) It requires elevated privileges  D) Automated collection is always faster

## MCQ 2
`find / -name "*.conf" | xargs grep -l "password"` finds:
A) Files named "password"  B) All readable .conf files that contain the string "password"  ✅
C) Password hashes  D) Encrypted password files only

## MCQ 3
Archiving collected data with `tar czf` before exfiltration helps because:
A) Archives bypass DLP  B) Reduces transfer size and combines multiple files into a single exfiltration event  ✅
C) Archives are self-decrypting  D) tar bypasses file permissions

## Fill 1
`find` flag to search only files (not directories) matching a pattern:
**Answer:** `-type f`

## Fill 2
`grep` flag to search recursively through directories:
**Answer:** `-r` (or `-R`)
