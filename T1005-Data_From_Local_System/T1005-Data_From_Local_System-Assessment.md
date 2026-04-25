# T1005 – Data from Local System | Assessment

## MCQ 1
`find / -name "*.conf" -readable 2>/dev/null` finds config files by:
A) Content searching  B) Traversing the file system for readable files matching the pattern  ✅
C) Reading the Windows registry  D) Querying the OS package manager

## MCQ 2
`grep -r "password" /etc/ 2>/dev/null` is effective for credential collection because:
A) All passwords are stored in /etc/  B) Many applications store plaintext configuration including credentials in /etc/ directories  ✅
C) grep decrypts password files  D) /etc/ has no access controls

## MCQ 3
Chrome's `Login Data` file stores browser-saved passwords as:
A) Plaintext  B) MD5 hashes  C) AES-encrypted entries (key stored in OS keychain)  ✅  D) Base64 encoded only

## Fill 1
`find` flag to search only readable files (useful to avoid permission errors):
**Answer:** `-readable`

## Fill 2
Linux file that stores system-wide user password hashes (readable only by root):
**Answer:** `/etc/shadow`
