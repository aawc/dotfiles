#!/bin/bash

if [ -n "${DISPLAY}" -a -n "$(which meld)" ]; then
  export P4DIFF=meld
elif [ -n "$(which colordiff)" ]; then
  export P4DIFF=colordiff
else
  export P4DIFF=diff
fi
