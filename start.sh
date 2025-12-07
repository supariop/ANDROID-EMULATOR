#!/bin/bash

export DISPLAY=:0

# Start virtual display (lightweight)
Xvfb :0 -screen 0 1024x600x24 &

sleep 2

# Start VNC server
x11vnc -forever -usepw -display :0 -shared &

# Boot ultra-light Android 5 emulator
emulator -avd android5_x86 \
    -no-accel \
    -no-snapshot-load \
    -no-snapshot-save \
    -gpu off \
    -noaudio \
    -verbose
