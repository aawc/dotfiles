#!/bin/bash

function run
{
  local MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  local GOOG_DIR="${MY_DIR}/../goog"
  local GOOG_BASH_RC="${GOOG_DIR}/bashrc.sh"

  [ -f "${GOOG_BASH_RC}" ] && source "${GOOG_BASH_RC}"

  local FUNCTIONS_FILE="${MY_DIR}/functions.sh"
  [ -f "${FUNCTIONS_FILE}" ] && source "${FUNCTIONS_FILE}"

  local ALIAS_FILE="${MY_DIR}/alias.sh"
  [ -f "${ALIAS_FILE}" ] && source "${ALIAS_FILE}"
}

run
