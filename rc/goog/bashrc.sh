#!/bin/bash

function run
{
  local MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

  local COMMON_DIR="${MY_DIR}/../common"
  local COMMON_BASH_RC="${COMMON_DIR}/bashrc.sh"
  [ -f "${COMMON_BASH_RC}" ] && source "${COMMON_BASH_RC}"

  local FUNCTIONS_FILE="${MY_DIR}/functions.sh"
  [ -f "${FUNCTIONS_FILE}" ] && source "${FUNCTIONS_FILE}"

  local ALIAS_FILE="${MY_DIR}/alias.sh"
  [ -f "${ALIAS_FILE}" ] && source "${ALIAS_FILE}"
}

run
