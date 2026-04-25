#!/bin/bash
set -euo pipefail
PLAYER="player"; PASS="Player@123"
FLAG="HACKTIFY{LOCAL_DATA_STAGING_$(hostname|sha256sum|cut -c1-8)}"
id "$PLAYER" &>/dev/null || { useradd -m -s /bin/bash "$PLAYER"; echo "$PLAYER:$PASS"|chpasswd; }
echo "$PLAYER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/player-stage; chmod 440 /etc/sudoers.d/player-stage
# Create distributed loot to be staged
for d in /opt/loot-source/{configs,creds,docs}; do mkdir -p "$d"; done
echo "$FLAG" > /opt/loot-source/configs/main.conf
echo "db_pass=Prod@DB2024" >> /opt/loot-source/configs/main.conf
echo "root:x:0:0:root:/root:/bin/bash" > /opt/loot-source/creds/passwd_dump.txt
echo "SSH_KEY_DATA=LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQ==" >> /opt/loot-source/creds/passwd_dump.txt
echo "Q4 Budget: $1.2M" > /opt/loot-source/docs/financial.txt
chmod -R 644 /opt/loot-source && chmod -R +X /opt/loot-source
# Create staging location (hidden directory in /tmp)
mkdir -p /tmp/.stage_area && chmod 700 /tmp/.stage_area
cat > /home/$PLAYER/README.txt << 'RMEOF'
=== T1074.001 Local Data Staging ===
Login  : player / Player@123
Source data: /opt/loot-source/
Staging dir: /tmp/.stage_area/ (hidden, attacker's staging point)
Goal   : Stage all collected data into the hidden staging directory
         before exfiltration. Demonstrate multiple staging techniques.
Step 1 : Copy files to staging: cp -r /opt/loot-source/* /tmp/.stage_area/
Step 2 : Compress staged data: tar czf /tmp/.stage_area/loot.tar.gz -C /opt/loot-source .
Step 3 : Encrypt for exfil: openssl enc -aes-256-cbc -k 'StageKey' -pbkdf2 \
           -in /tmp/.stage_area/loot.tar.gz -out /tmp/.stage_area/loot.enc
Step 4 : Find the flag in the staged data
RMEOF
chown $PLAYER:$PLAYER /home/$PLAYER/README.txt
echo "[+] T1074.001 setup complete."
