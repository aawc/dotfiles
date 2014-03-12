#!/bin/bash

function run
{
  local MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  local GOOG_DIR="${MY_DIR}/../goog"
  local GOOG_BASH_RC="${GOOG_DIR}/bashrc.sh"
  [ -f "${GOOG_BASH_RC}" ] && source "${GOOG_BASH_RC}"
}

run
