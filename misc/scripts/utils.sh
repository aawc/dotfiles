#!/bin/bash

function GetDesktopEnvironment
{
  local desktopEnv="`echo $XDG_CURRENT_DESKTOP | tr '[:upper:]' '[:lower:]'`"
  if [[ -z $desktopEnv ]]; then
    desktopEnv="`w | grep ' :0.* :0' | tr '[:upper:]' '[:lower:]'`"
  fi
  if [[ -z $desktopEnv ]]; then
    # Fallback to assuming cinnamon. Not a great choice but good enough for my
    # current setup.
    desktopEnv = "cinnamon"
  fi
  echo "${desktopEnv}"
}

function IsScreenSaverActive
{
  export DISPLAY=:0
  local desktopEnv="$(GetDesktopEnvironment)"
  if [[ $desktopEnv =~ "cinnamon" ]]; then
    cinnamon-screensaver-command -q | grep -o 'is active'
  elif [[ $desktopEnv =~ "gnome" ]]; then
    gnome-screensaver-command -q | grep -o 'is active'
  fi
}

function LockScreen
{
  export DISPLAY=:0
  local desktopEnv="$(GetDesktopEnvironment)"
  if [[ $desktopEnv =~ "cinnamon" ]]; then
    cinnamon-screensaver-command -a
  elif [[ $desktopEnv =~ "gnome" ]]; then
    gnome-screensaver-command -l
  fi
}

function MuteAudio
{
  amixer -D pulse set Master 1+ mute >/dev/null 2>&1
}

function TurnScreenOff
{
  xset dpms force off
}
