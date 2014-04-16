#!/bin/bash

function run
{
  local MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

  local COLORS_FILE="${MY_DIR}/bash_colors.sh"
  includeFile "${COLORS_FILE}"

  local FUNCTIONS_FILE="${MY_DIR}/functions.sh"
  includeFile "${FUNCTIONS_FILE}"

  local ALIAS_FILE="${MY_DIR}/alias.sh"
  includeFile "${ALIAS_FILE}"

  local BASH_PROMPT_FILE="${MY_DIR}/bash_prompt.sh"
  includeFile "${BASH_PROMPT_FILE}"
}

run
