#!/bin/bash

function rescreen
{
  local screenName="${1}"
  if [ -z "${screenName}" ]; then
    screen -ls
    return
  fi

  local intendedScreenName="$(screen -ls | grep "${screenName}" | awk '{print $1}')"
  if [ -z "${intendedScreenName}" ]; then
    printf "Screen %s not found\n" $screenName
  else
    local numberOfMatchingScreensFound="$(echo ${intendedScreenName} | wc -w)"
    if [ "${numberOfMatchingScreensFound}" -eq 1 ]; then
      screen -d -r "${intendedScreenName}"
    else
      printf "Found too many screens:\n%s\n" "${intendedScreenName}"
    fi
  fi
}

function epoch(){
  [[ -z "${1}" ]] || date -d @"${1}"
}

function epoch_milli(){
  [[ -z "${1}" ]] && return

  local time_in_milli="${1}"
  local time_in_secs="$( echo "${time_in_milli} / 1000" | bc -l )"
  epoch "${time_in_secs}"
}
