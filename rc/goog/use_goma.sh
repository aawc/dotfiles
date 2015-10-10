#!/bin/bash

echo "Assuming this is run from src/ directory"
export GOMA_DIR=${HOME}/goma
python ${GOMA_DIR}/goma_ctl.py ensure_start
export GYP_GENERATORS=ninja && ./build/gyp_chromium -D use_goma=1
echo "Now go use ninja build mechanism!"

echo "\# For build and run:"
echo "nice ninja -C out/Debug chrome -j 100 && " \
  "DISPLAY=:20.0 out/Debug/chrome --user-data-dir=/tmp/profile"

echo "\# For unit tests:"
echo "ninja -C out/Debug -j 100 unit_tests && " \
  "out/Debug/unit_tests --gtest_filter=\"\*Mytest.Thing\*\""
