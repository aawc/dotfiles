#!/bin/bash

function prolog
{
  #set -o nounset

  # Closes the terminal if there's an error
  #set -o errexit

  # Useful for debugging
  #set -o xtrace

  trap "{ echo; exit 1; }" INT
}

function includeFile
{
  if [[ -f "$1" ]] && ! shopt -oq posix; then
    source "$1"
  fi
}

prolog
