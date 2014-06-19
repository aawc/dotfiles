#!/bin/bash

# Start the screensaver automatically so that the machine gets locked and I
# don't miss my bus.
DISPLAY=:0 gnome-screensaver-command -l
# Mute the system so that others aren't disturbed in my absence.
amixer -D pulse set Master 1+ mute >/dev/null 2>&1
