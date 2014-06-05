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
    g4 describe -s -c ${open_cls} | grep -E '^Change|$' | less -r
  fi
}
