#!/bin/bash

# Prelude
set -eu
set -o pipefail

export PS4='+ ${FUNCNAME[0]:+${FUNCNAME[0]}():}line ${LINENO}: '
syslogname="$(basename "$0")[$$]"
exec 3<> >(logger -t "$syslogname")
BASH_XTRACEFD=3
unset syslogname

function bdebug()
{
  echo "$@" >&3
}
# End prelude

function getTempFile()
{
  local tmpDir=`mktemp -d`
  bdebug "${tmpDir}"
  mkdir -p "${tmpDir}"
  local scriptName="$(basename $0)"
  local tmpFile="$(mktemp ${tmpDir}/${scriptName}.XXXXXX)"
  bdebug "${tmpFile}"
  echo "$tmpFile"
}

function TRAP()
{
  trap "rm -f ${1}" 0 2 3 15
}

function showMeMySnippets()
{
  local myActivityScript="${HOME}/work/chrome/depot_tools/my_activity.py"
  local myActivityScriptArgs="${ACTIVITY_SCRIPT_ARGS:--m}"

  bdebug "${myActivityScript}"
  bdebug "${myActivityScriptArgs}"

  local tmpFile="$(getTempFile)"
  TRAP "${tmpFile}"
  "${myActivityScript}" ${myActivityScriptArgs} > "${tmpFile}"

  if [ -s "${tmpFile}" ]; then
    cat "${tmpFile}" | grep "^#\|^ "
  fi
}

showMeMySnippets
# To debug, run: tail -f /var/log/messages
