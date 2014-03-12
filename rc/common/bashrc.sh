#!/bin/bash

function run
{
  local MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

  local FUNCTIONS_FILE="${MY_DIR}/functions.sh"
  [ -f "${FUNCTIONS_FILE}" ] && source "${FUNCTIONS_FILE}"

  local ALIAS_FILE="${MY_DIR}/alias.sh"
  [ -f "${ALIAS_FILE}" ] && source "${ALIAS_FILE}"

  local BASH_PROMPT_FILE="${MY_DIR}/bash_prompt.sh"
  [ -f "${BASH_PROMPT_FILE}" ] && source "${BASH_PROMPT_FILE}"
}

run
