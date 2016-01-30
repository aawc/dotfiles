#!/bin/bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${MY_DIR}/utils.sh"

function TurnScreenOffAndMuteOnLock
{
  if [ "$(IsScreenSaverActive)" == "is active" ]; then
    TurnScreenOff
    MuteAudio
  fi
}

[ "$0" = "$BASH_SOURCE" ] && TurnScreenOffAndMuteOnLock
