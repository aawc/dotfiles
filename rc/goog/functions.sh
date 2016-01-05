#!/bin/bash

function list_open_cls_g4
{
  g4 status 2>/dev/null | grep -v ' default ' | awk '{print $5}' | sort -n | uniq
  g4 status 2>/dev/null | grep default | awk '{print $4}' | uniq
}

function pending_cls_g4
{
  local open_cls="$(list_open_cls_g4 | tr '\n' ' ')"
  if [[ -n "${open_cls}" ]]; then
    g4 describe -s -c ${open_cls} | less -p '^Change|$'
  fi
}

function is_prodaccess_missing
{
  [ -d /google -a ! -d /google/src/cloud ]
}

function prodaccess_missing_message
{
  echo "[!]"
}

function git_cleanup_clients
{
  local clients=$(g4 clients -u "${USER}" -e '*git*' | awk '{print $2}' | cut -d ':' -f 2);
  for client in ${clients}; do
    cd "${HOME}";
    echo "Client: ${client}";
    g4d "${client}";
    local pending_cls=$(g4 pending | grep Change | grep -o '[0-9]\{8,\}');
    for pending_cl in ${pending_cls}; do
      echo "CL: ${pending_cl}";
      echo "g4 revert -c ${pending_cl}";
    done
    echo "g4 citc -d ${client}";
    echo;
  done
}
