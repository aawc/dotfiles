#!/bin/bash

function run
{
  echo "bash_completion.sh: Update 'UPDATE_THIS_PATH' when needed"
  return

  local localBashCompletionFile="/etc/bash_completion.d/span"
  local remoteBashCompletionFile="/UPDATE_THIS_PATH/span.completion"
  if [ ! -f "${localBashCompletionFile}" -a -f "${remoteBashCompletionFile}" ]; then
    local command="sudo cp ${remoteBashCompletionFile} ${localBashCompletionFile}"
    echo "${command}"
    $command
  fi

  local localBorgCompletionFile="/etc/bash_completion.d/borgcfg"
  local remoteBorgCompletionFile="/UPDATE_THIS_PATH/borgcfg.completion"
  if [ ! -f "${localBorgCompletionFile}" -a -f "${remoteBorgCompletionFile}" ]; then
    local command="sudo cp ${remoteBorgCompletionFile} ${localBorgCompletionFile}"
    echo "${command}"
    $command
  fi
}

run
