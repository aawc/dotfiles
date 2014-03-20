#!/bin/bash

function rescreen {
  local screenName="${1}"
  if [ -z "${screenName}" ]; then
    return;
  fi

  local intendedScreenName="$(screen -q -ls | grep "${screenName}" | awk '{print $1}')"
  if [ -z ${intendedScreenName} ]; then
    printf "Screen %s not found\n" $screenName
  else
    screen -d -r "${intendedScreenName}"
  fi
}
