#!/usr/bin/fish

set -x DISPLAY :20.0
set -x GOMA_DIR $HOME/goma
python $GOMA_DIR/goma_ctl.py ensure_start
