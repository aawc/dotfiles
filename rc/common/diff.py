#!/usr/bin/python

import os
import platform
import subprocess
import sys


def gui_main():
  os.system('meld "%s" "%s"' % (sys.argv[2], sys.argv[5]))


def cli_main():
  command = 'colordiff "%s" "%s"' % (sys.argv[2], sys.argv[5])
  os.system(command);


def X_is_running():
  pp = subprocess.Popen(
      ["xset", "-q"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  pp.communicate()
  return pp.returncode == 0


def current_platform():
  return platform.system()


if __name__ == '__main__':
  if current_platform() == "Linux" and X_is_running():
    gui_main()
  else:
    cli_main()
