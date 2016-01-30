#!/bin/bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${MY_DIR}/utils.sh"

function LeaveWork
{
  # Start the screensaver automatically so that the machine gets locked and I
  # don't miss my bus.
  LockScreen
  TurnScreenOff
  # Mute the system so that others aren't disturbed in my absence.
  MuteAudio
}

[ "$0" = "$BASH_SOURCE" ] && LeaveWork
