#!/bin/bash

if [ -n "$(which colordiff 2>/dev/null)" ]; then
  export P4DIFF=colordiff
else
  export P4DIFF=diff
fi

if [ -n "${DISPLAY}" -a -n "$(which p4merge 2>/dev/null)" ]; then
  export P4MERGE=p4merge
fi

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth
