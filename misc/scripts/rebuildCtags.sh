#!/bin/bash

set -x;

function RebuildCtagsInDir
{
  echo "$@"

  local srcDir="${1}"
  [ -d "${srcDir}" ] && \
    pushd "${srcDir}" && \
    ctags --languages=C++ \
          --exclude=third_party \
          --exclude=.git \
          --exclude=build \
          --exclude=out \
          -R -f .tmp_tags && \
    mv .tmp_tags .tags && \
    popd
}

function RebuildCtags
{
  for srcDir in "$@"
  do
    RebuildCtagsInDir "${srcDir}"
  done
}

CHROME_SRC_BASE_DIR="/usr/local/google/home/vakh/work/chrome/src"

[ "$0" = "$BASH_SOURCE" ] && RebuildCtags \
  "${CHROME_SRC_BASE_DIR}/components/safe_browsing_db" \
  "${CHROME_SRC_BASE_DIR}/chrome/browser/safe_browsing"
