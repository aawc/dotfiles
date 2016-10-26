#!/bin/bash -i

rm -f /tmp/compiling.txt;
cd "${HOME}/work/chrome/src" &&
  pwd >>/tmp/compiling.txt 2>&1 &&
  nice gn check out/gn_out >>/tmp/compiling.txt 2>&1 &&
  nice ninja -C out/gn_out -j 10 components/safe_browsing_db:safe_browsing_db >>/tmp/compiling.txt 2>&1 &&
  nice ninja -C out/gn_out -j 10 components_unittests >>/tmp/compiling.txt 2>&1 &&
  nice ninja -C out/gn_out -j 10 browser_tests >>/tmp/compiling.txt 2>&1
