#!/bin/bash

function run
{
  local MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

  local COMMON_DIR="${MY_DIR}/../${BASH_COMMON_DIR}"
  local COMMON_BASH_RC="${COMMON_DIR}/bashrc.sh"
  includeFile "${COMMON_BASH_RC}"

  local FUNCTIONS_FILE="${MY_DIR}/functions.sh"
  includeFile "${FUNCTIONS_FILE}"

  local ALIAS_FILE="${MY_DIR}/alias.sh"
  includeFile "${ALIAS_FILE}"

  local CHROME_FILE="${MY_DIR}/chrome.sh"
  includeFile "${CHROME_FILE}"

  export PATH="/usr/local/google/home/vakh/work/chrome/depot_tools:$PATH"
}

run
