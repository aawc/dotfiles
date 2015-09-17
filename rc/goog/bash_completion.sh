#!/bin/bash

function run
{
  local localBashCompletionFile="/etc/bash_completion.d/span"
  local remoteBashCompletionFile="/google/data/ro/projects/spanner/span.completion"
  if [ ! -f "${localBashCompletionFile}" -a -f "${remoteBashCompletionFile}" ]; then
    local command="sudo cp ${remoteBashCompletionFile} ${localBashCompletionFile}"
    echo "${command}"
    $command
  fi

  local localBorgCompletionFile="/etc/bash_completion.d/borgcfg"
  local remoteBorgCompletionFile="/google/data/ro/projects/spanner/borgcfg.completion"
  if [ ! -f "${localBorgCompletionFile}" -a -f "${remoteBorgCompletionFile}" ]; then
    local command="sudo cp ${remoteBorgCompletionFile} ${localBorgCompletionFile}"
    echo "${command}"
    $command
  fi
}

run
