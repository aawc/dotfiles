#!/bin/bash

# Cancel the mute from last evening.
amixer -d set Master unmute >/dev/null 2>&1
