#!/bin/bash
apt-get update -y && apt-get install -y snmp snmpd snmp-mibs-downloader
systemctl enable snmpd && systemctl start snmpd || service snmpd start || true
