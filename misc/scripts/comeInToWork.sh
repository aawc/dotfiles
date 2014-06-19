#!/bin/bash

# Cancel the mute from last evening.
amixer -D pulse set Master 1+ unmute >/dev/null 2>&1
