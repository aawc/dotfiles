#!/bin/bash

export ANDROID_HOME="${HOME}/bin/android-sdk-${OS}"
if [ -n "${ANDROID_HOME}" -a -d "${ANDROID_HOME}" ]; then
  PATH="${PATH}":"${ANDROID_HOME}/tools"
  PATH="${PATH}":"${ANDROID_HOME}/platform-tools"
  export PATH
fi
