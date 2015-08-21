#!/bin/bash
screensaverstatus=`cinnamon-screensaver-command -q`
if [ "$screensaverstatus" == "The screensaver is active" ]; then
  xset dpms force off
fi
