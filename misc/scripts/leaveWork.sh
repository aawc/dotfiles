#!/bin/bash

function LockScreen
{
  local desktopEnv="`echo $XDG_CURRENT_DESKTOP | tr '[:upper:]' '[:lower:]'`"
  if [[ -z $desktopEnv ]]; then
      desktopEnv="`w | grep ' :0.* :0' | tr '[:upper:]' '[:lower:]'`"
  fi
  if [[ $desktopEnv =~ "cinnamon" ]]; then
    export DISPLAY=:0 && cinnamon-screensaver-command -a && xset dpms force off;
  elif [[ $desktopEnv =~ "gnome" ]]; then
    export DISPLAY=:0 && gnome-screensaver-command -l && xset dpms force off;
  fi
}

function MuteAudio
{
  amixer -D pulse set Master 1+ mute >/dev/null 2>&1
}

# Start the screensaver automatically so that the machine gets locked and I
# don't miss my bus.
LockScreen
# Mute the system so that others aren't disturbed in my absence.
MuteAudio
