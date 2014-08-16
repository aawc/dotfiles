#!/bin/bash

# Prelude
set -eu
set -o pipefail

export PS4='+ ${FUNCNAME[0]:+${FUNCNAME[0]}():}line ${LINENO}: '
syslogname="$(basename "$0")[$$]"
exec 3<> >(logger -t "$syslogname")
BASH_XTRACEFD=3
echo "Tracing to syslog as $syslogname"
unset syslogname

function bdebug()
{
  echo "$@" >&3
}
# End prelude

function sendEmailOnPageChange()
{
  local notifyEmail="${NOTIFY_EMAIL:-vakh}"
  local urlToMonitor="${URL_TO_MONITOR:-"http://switchproxy.proxify.net/satellite_ids.xml"}"
  local tmp="${TMPDIR:-/tmp}"
  local basename="$(basename ${urlToMonitor})"
  local derivedFilename="${tmp}/${basename}"
  local fullFilename="${FULL_FILENAME:-${derivedFilename}}"
  local oldSuffix="${OLD_SUFFIX:-old}"
  local oldFilename="${fullFilename}.${oldSuffix}"

  bdebug "${notifyEmail}"
  bdebug "${urlToMonitor}"
  bdebug "${tmp}"
  bdebug "${basename}"
  bdebug "${derivedFilename}"
  bdebug "${fullFilename}"
  bdebug "${oldSuffix}"
  bdebug "${oldFilename}"

  wget -O "${fullFilename}" "${urlToMonitor}"

  if [ -f "${oldFilename}" ]; then
    local fileDiff="$(diff --suppress-common-lines <(sort ${oldFilename}) <(sort ${fullFilename}))"
    if [ -n "${fileDiff}" ]; then
      echo "${fileDiff}" | mail -s "File diff for ${urlToMonitor}" "${notifyEmail}"
    fi
  fi
  mv -fv "${fullFilename}" "${oldFilename}"
}

sendEmailOnPageChange
# To debug, run: tail -f /var/log/messages
