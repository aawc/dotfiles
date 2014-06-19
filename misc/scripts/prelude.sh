#!/bin/bash

set -eu

# Fail the entire pipeline if any part of it fails.
set -o pipefail

# Stuff prepended to bash’s trace output from set -x
export PS4='+ ${FUNCNAME[0]:+${FUNCNAME[0]}():}line ${LINENO}: '

# Debugging output to file descriptor 3
syslogname="$(basename "$0")[$$]"
exec 3<> >(logger -t "$syslogname")
BASH_XTRACEFD=3
echo "Tracing to syslog as $syslogname"
unset syslogname

debug() { echo "$@" >&3; }
set -x
