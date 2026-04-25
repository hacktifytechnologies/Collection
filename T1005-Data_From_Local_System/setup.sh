#!/bin/bash
set -euo pipefail
PLAYER="player"; PASS="Player@123"
FLAG="HACKTIFY{LOCAL_DATA_COLLECTION_$(hostname|sha256sum|cut -c1-8)}"
id "$PLAYER" &>/dev/null || { useradd -m -s /bin/bash "$PLAYER"; echo "$PLAYER:$PASS"|chpasswd; }
echo "$PLAYER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/player-col; chmod 440 /etc/sudoers.d/player-col
# Plant sensitive data in various locations
mkdir -p /opt/corp-data/{finance,hr,configs}
echo "$FLAG" > /opt/corp-data/configs/system_keys.conf
echo "db_host=10.10.10.50" >> /opt/corp-data/configs/system_keys.conf
echo "db_password=ProdDB@2024!" >> /opt/corp-data/configs/system_keys.conf
echo "Name,Salary,SSN" > /opt/corp-data/hr/employees.csv
echo "John Smith,95000,123-45-6789" >> /opt/corp-data/hr/employees.csv
echo "Q4_Revenue=$12.5M" > /opt/corp-data/finance/q4_report.txt
echo "Acquisition_Budget=$450M" >> /opt/corp-data/finance/q4_report.txt
# Plant "credentials" in common locations
echo "postgres://admin:DBpass123@localhost/prod" > /home/$PLAYER/.db_url
echo "AWS_SECRET_KEY=wJalrXUtnFEMI" > /home/$PLAYER/.env
chmod 644 /home/$PLAYER/.db_url /home/$PLAYER/.env
chown $PLAYER:$PLAYER /home/$PLAYER/.db_url /home/$PLAYER/.env
chmod -R 644 /opt/corp-data
cat > /home/$PLAYER/README.txt << 'RMEOF'
=== T1005 Data from Local System ===
Login  : player / Player@123
Goal   : Locate and collect sensitive data from the local system.
Step 1 : Search for sensitive files systematically:
         find / -name "*.conf" -readable 2>/dev/null | head -20
         find / -name "*.csv" -readable 2>/dev/null
         find / -name ".env" -readable 2>/dev/null
Step 2 : Search file contents for keywords:
         grep -r "password\|secret\|key\|FLAG" /opt/corp-data/ 2>/dev/null
         grep -r "HACKTIFY" /opt/corp-data/ 2>/dev/null
Step 3 : Enumerate credentials in standard locations:
         cat ~/.db_url ~/.env
Step 4 : Read the flag from the config file you find
RMEOF
chown $PLAYER:$PLAYER /home/$PLAYER/README.txt
echo "[+] T1005 setup complete."
