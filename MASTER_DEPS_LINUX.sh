#!/bin/bash
apt-get update -y && apt-get install -y bash findutils grep tar zip openssl samba samba-client cifs-utils snmp snmpd python3 python3-pip
pip3 install pynput --break-system-packages 2>/dev/null || true
echo '[+] Collection Linux deps installed.'
