#!/bin/bash

function LockScreen
{
  local desktopEnv="`echo $XDG_CURRENT_DESKTOP | tr '[:upper:]' '[:lower:]'`"
  if [[ $desktopEnv =~ "cinnamon" ]]; then
    bash -c "cinnamon-screensaver-command -l; xset dpms force off;"
  elif [[ $desktopEnv =~ "gnome" ]]; then
    DISPLAY=:0 gnome-screensaver-command -l
  fi
}

# Start the screensaver automatically so that the machine gets locked and I
# don't miss my bus.
LockScreen
# Mute the system so that others aren't disturbed in my absence.
amixer -D pulse set Master 1+ mute >/dev/null 2>&1
