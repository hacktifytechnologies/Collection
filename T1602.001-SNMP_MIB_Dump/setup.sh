#!/bin/bash
set -euo pipefail
PLAYER="player"; PASS="Player@123"
FLAG="HACKTIFY{SNMP_MIB_DUMP_$(hostname|sha256sum|cut -c1-8)}"
id "$PLAYER" &>/dev/null || { useradd -m -s /bin/bash "$PLAYER"; echo "$PLAYER:$PASS"|chpasswd; }
echo "$PLAYER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/player-snmp; chmod 440 /etc/sudoers.d/player-snmp
mkdir -p /root/.flags && chmod 700 /root/.flags
echo "$FLAG" > /root/.flags/flag.txt && chmod 644 /root/.flags/flag.txt
# Configure SNMP with a weak community string for the challenge
cat > /etc/snmp/snmpd.conf << 'SNMPEOF'
rocommunity public default
rocommunity hacktify_community default
sysLocation "Hacktify-Lab Corp HQ"
sysContact "admin@corp.internal (Flag: PLACEHOLDER)"
extend FLAG /bin/sh -c 'cat /root/.flags/flag.txt'
SNMPEOF
sed -i "s/PLACEHOLDER/$FLAG/" /etc/snmp/snmpd.conf
systemctl restart snmpd 2>/dev/null || service snmpd restart 2>/dev/null || true
cat > /home/$PLAYER/README.txt << 'RMEOF'
=== T1602.001 SNMP MIB Dump (Data from Configuration Repository) ===
Login  : player / Player@123
Goal   : Use SNMP to dump device/system configuration data.
Step 1 : Check SNMP is running: netstat -unl | grep 161
Step 2 : Community string discovery (try default strings):
         snmpget -v2c -c public localhost sysDescr.0
         snmpget -v2c -c hacktify_community localhost sysDescr.0
Step 3 : Full MIB walk to collect all data:
         snmpwalk -v2c -c public localhost
Step 4 : Find the flag in the SNMP data:
         snmpwalk -v2c -c public localhost | grep -i "flag\|hacktify\|sysContact"
RMEOF
chown $PLAYER:$PLAYER /home/$PLAYER/README.txt
echo "[+] T1602.001 setup complete."
