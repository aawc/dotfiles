#!/bin/bash

GOMA_DIR=${HOME}/goma
mkdir ${GOMA_DIR}
cd ${GOMA_DIR}
curl https://clients5.google.com/cxx-compiler-service/download/goma_ctl.py -o goma_ctl.py
python goma_ctl.py update
