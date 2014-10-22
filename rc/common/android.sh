#!/bin/bash

function run
{
  local androidOS="$(echo ${OS} | tr A-Z a-z)"
  export ANDROID_HOME="${HOME}/bin/android-sdk-${androidOS}"
  if [ -n "${ANDROID_HOME}" -a -d "${ANDROID_HOME}" ]; then
    PATH="${PATH}:${ANDROID_HOME}/tools"
    PATH="${PATH}:${ANDROID_HOME}/platform-tools"
    export PATH
  fi
}

run
