#!/bin/bash

set -x;

export __LATEST__=$(date +%s)
export LOG_FILE="/tmp/sync-chromium-src-${__LATEST__}.log"
rm -f ${LOG_FILE};

export PATH="${HOME}/work/chrome/depot_tools:${PATH}"
echo $PATH >> ${LOG_FILE} 2>&1

cd "${HOME}/work/chrome/src" &&
  pwd >> ${LOG_FILE} 2>&1 &&
  nice git switch clean >> ${LOG_FILE} 2>&1 &&
  nice git fetch origin >> ${LOG_FILE} 2>&1 &&
  nice git rebase >> ${LOG_FILE} 2>&1 &&
  nice gclient sync -D >> ${LOG_FILE} 2>&1 &&
  nice echo "Done!" >> ${LOG_FILE} 2>&1

set +x;
