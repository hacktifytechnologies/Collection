#!/bin/bash
set -euo pipefail
PLAYER="player"; PASS="Player@123"
FLAG="HACKTIFY{KEYLOGGER_CAPTURE_$(hostname|sha256sum|cut -c1-8)}"
id "$PLAYER" &>/dev/null || { useradd -m -s /bin/bash "$PLAYER"; echo "$PLAYER:$PASS"|chpasswd; }
echo "$PLAYER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/player-key; chmod 440 /etc/sudoers.d/player-key
mkdir -p /root/.flags && chmod 700 /root/.flags
echo "$FLAG" > /root/.flags/flag.txt && chmod 644 /root/.flags/flag.txt
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p /opt/keylogger
cp "${SCRIPT_DIR}/keylogger.py" /opt/keylogger/
pip3 install pynput --break-system-packages &>/dev/null || true
# Create a simulated "captured" keylog showing what a keylogger would capture
cat > /tmp/simulated_keylog.txt << 'LOGEOF'
[Simulated keylogger capture — /tmp/keylog.txt]
[14:23:11] ssh admin@192.168.1.100[ENTER]
[14:23:15] P@ssw0rd2024![ENTER]
[14:23:22] sudo cat /etc/shadow[ENTER]
[14:23:22] P@ssw0rd2024![ENTER]
[14:23:31] mysql -u root -pR00tDB!2024[ENTER]
[FLAG] LOGEOF
echo "$FLAG" >> /tmp/simulated_keylog.txt
chmod 644 /tmp/simulated_keylog.txt
cat > /home/$PLAYER/README.txt << 'RMEOF'
=== T1056.001 Keylogging ===
Login  : player / Player@123
Goal   : Understand keylogging techniques and detect keystroke capture.
Step 1 : View simulated capture (what a keylogger sees): cat /tmp/simulated_keylog.txt
Step 2 : Run the demo keylogger: python3 /opt/keylogger/keylogger.py
         (requires GUI/TTY access — type some keys then 'STOP' or Esc)
Step 3 : Check captured log: cat /tmp/keylog.txt
Step 4 : Retrieve the flag: sudo cat /root/.flags/flag.txt
RMEOF
chown $PLAYER:$PLAYER /home/$PLAYER/README.txt
echo "[+] T1056.001 setup complete."
