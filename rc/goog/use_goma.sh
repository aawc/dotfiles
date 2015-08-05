#!/bin/bash

echo "Assuming this is run from src/ directory"
GOMA_DIR=${HOME}/goma
python ${GOMA_DIR}/goma_ctl.py ensure_start
GYP_GENERATORS=ninja ./build/gyp_chromium -D use_goma=1
echo "Now go use ninja build mechanism!"
