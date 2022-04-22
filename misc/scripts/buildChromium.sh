#!/bin/bash

set -x;

export __LATEST__=$(date +%s)
export LOG_FILE="/tmp/build-chromium-src-${__LATEST__}.log"
rm -f ${LOG_FILE};

export PATH="${HOME}/work/chrome/depot_tools:${PATH}"
echo $PATH >> ${LOG_FILE} 2>&1

export __BUILD__="ReleaseWithSymbols"

cd "${HOME}/work/chrome/src" &&
  pwd >> ${LOG_FILE} 2>&1 &&
  nice gn check out/${__BUILD__} >> ${LOG_FILE} 2>&1 &&
  nice autoninja -C out/${__BUILD__} -k 0 chrome >> ${LOG_FILE} 2>&1 &&
  nice autoninja -C out/${__BUILD__} -k 0 base_unittests components_unittests chrome/test:unit_tests browser_tests unit_tests >> ${LOG_FILE} 2>&1
  nice echo "Done!" >> ${LOG_FILE} 2>&1

set +x;
