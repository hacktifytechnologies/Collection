#!/bin/bash
apt-get update -y && apt-get install -y python3 python3-pip
pip3 install pynput --break-system-packages 2>/dev/null || true
