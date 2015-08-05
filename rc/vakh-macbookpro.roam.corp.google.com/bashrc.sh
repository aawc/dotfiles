#!/bin/bash

function run
{
  local MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  local GOOG_DIR="${MY_DIR}/../goog"

  local GOOG_BASH_RC="${GOOG_DIR}/bashrc.sh"
  includeFile "${GOOG_BASH_RC}"

  local FUNCTIONS_FILE="${MY_DIR}/functions.sh"
  includeFile "${FUNCTIONS_FILE}"

  local ALIAS_FILE="${MY_DIR}/alias.sh"
  includeFile "${ALIAS_FILE}"

  local SOURCE_FILE="${MY_DIR}/source.sh"
  includeFile "${SOURCE_FILE}"
}

run
