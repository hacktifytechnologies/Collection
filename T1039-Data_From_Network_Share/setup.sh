#!/bin/bash
set -euo pipefail
PLAYER="player"; PASS="Player@123"
FLAG="HACKTIFY{NETWORK_SHARE_COLLECTION_$(hostname|sha256sum|cut -c1-8)}"
id "$PLAYER" &>/dev/null || { useradd -m -s /bin/bash "$PLAYER"; echo "$PLAYER:$PASS"|chpasswd; }
echo "$PLAYER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/player-smb; chmod 440 /etc/sudoers.d/player-smb
# Create a local samba share simulating network drive
mkdir -p /srv/corp-share/{Documents,Finance,HR}
echo "$FLAG" > /srv/corp-share/Finance/budget_2024.txt
echo "Q4 Revenue: $12.5M" >> /srv/corp-share/Finance/budget_2024.txt
echo "Name,Role,Salary" > /srv/corp-share/HR/staff_list.csv
echo "Alice,Manager,95000" >> /srv/corp-share/HR/staff_list.csv
echo "Server: dc01.corp.local" > /srv/corp-share/Documents/servers.txt
echo "Admin pass: Corp@Admin2024" >> /srv/corp-share/Documents/servers.txt
chmod -R 755 /srv/corp-share
# Configure Samba
cat >> /etc/samba/smb.conf << 'SAMBEOF' 2>/dev/null || true
[corpshare]
   path = /srv/corp-share
   browseable = yes
   read only = yes
   guest ok = yes
SAMBEOF
systemctl restart smbd nmbd 2>/dev/null || service smbd restart 2>/dev/null || true
cat > /home/$PLAYER/README.txt << 'RMEOF'
=== T1039 Data from Network Shared Drive ===
Login  : player / Player@123
Goal   : Enumerate and collect data from the simulated network share.
Step 1 : List shares: smbclient -L //localhost -N
Step 2 : Browse share: smbclient //localhost/corpshare -N
Step 3 : Mount and collect:
         sudo mount -t cifs //localhost/corpshare /mnt -o guest
         find /mnt -type f | xargs grep -l "password\|FLAG\|budget" 2>/dev/null
         cp /mnt/Finance/budget_2024.txt /tmp/
Step 4 : Read the flag from the Finance directory
RMEOF
chown $PLAYER:$PLAYER /home/$PLAYER/README.txt
echo "[+] T1039 setup complete."
