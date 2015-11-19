#!/bin/bash

function rescreen
{
  local screenName="${1}"
  local runningScreens="$(screen -ls | grep '^\s*[0-9][0-9]*\.' | awk '{print $1}')"

  if [ -z "${screenName}" ]; then
    if [ -z "${runningScreens}" ]; then
      printf "No screens running.\n"
      return
    fi

    printf "Found the following screens running:\n${runningScreens}\n"
    return
  fi

  local intendedScreenName="$(echo ${runningScreens} | tr ' ' '\n' | grep -i "${screenName}")"
  if [ -z "${intendedScreenName}" ]; then
    printf "Screen %s not found.\n" $screenName
    if [ -n "${runningScreens}" ]; then
      printf "Found the following screens running:\n${runningScreens}\n"
    fi
    local startScreen="N"
    read -r -p "Want to start a session named '${screenName}'? [y/N]: " startScreen
    case "${startScreen}" in
      [yY][eE][sS]|[yY])
        screen -S "${screenName}";;
      *)
        ;;
    esac
  else
    local numberOfMatchingScreensFound="$(echo ${intendedScreenName} | wc -w)"
    if [ "${numberOfMatchingScreensFound}" -eq 1 ]; then
      screen -d -r "${intendedScreenName}"
    else
      printf "Found too many screens:\n%s\n" "${intendedScreenName}"
    fi
  fi
}

function remux
{
  local muxName="${1}"
  local runningMuxs="$(tmux list-sessions 2>/dev/null | cut -f1 -d:)"

  if [ -z "${muxName}" ]; then
    if [ -z "${runningMuxs}" ]; then
      printf "No muxs running.\n"
      return
    fi

    printf "Found the following muxs running:\n${runningMuxs}\n"
    return
  fi

  local intendedMuxName="$(echo ${runningMuxs} | tr ' ' '\n' | grep -i "${muxName}")"
  if [ -z "${intendedMuxName}" ]; then
    printf "Mux %s not found.\n" $muxName
    if [ -n "${runningMuxs}" ]; then
      printf "Found the following muxs running:\n${runningMuxs}\n"
    fi
    local startMux="N"
    read -r -p "Want to start a session named '${muxName}'? [y/N]: " startMux
    case "${startMux}" in
      [yY][eE][sS]|[yY])
        tmux new -s "${muxName}";;
      *)
        ;;
    esac
  else
    local numberOfMatchingMuxsFound="$(echo ${intendedMuxName} | wc -w)"
    if [ "${numberOfMatchingMuxsFound}" -eq 1 ]; then
      tmux attach -d -t "${intendedMuxName}"
    else
      printf "Found too many muxs:\n%s\n" "${intendedMuxName}"
    fi
  fi
}

function epoch(){
  [[ -z "${1}" ]] || date -d @"${1}"
}

function epoch_milli() {
  [[ -z "${1}" ]] || _epoch_base ${1} 1000
}

function epoch_micro() {
  [[ -z "${1}" ]] || _epoch_base ${1} 1000000
}

function _epoch_base(){
  [[ "${#}" -ne 2 ]] && return

  local time_input="${1}"
  local base="${2}"
  local time_in_secs="$( echo "${time_input} / ${base}" | bc -l )"
  epoch "${time_in_secs}"
}

function source_file() {
  local file_to_source="${1}"
  if [[ -f "${file_to_source}" ]]; then
    source "${file_to_source}"
  fi
}

function play {
    # Skip DASH manifest for speed purposes. This might actually disable
    # being able to specify things like 'bestaudio' as the requested format,
    # but try anyway.
    # Get the best audio that isn't WebM, because afplay doesn't support it.
    # Use "$*" so that quoting the requested song isn't necessary.
    youtube-dl --default-search=ytsearch: \
               --youtube-skip-dash-manifest \
               --output="${TMPDIR:-/tmp/}%(title)s-%(id)s.%(ext)s" \
               --restrict-filenames \
               --format="bestaudio[ext!=webm]" \
               --exec=afplay "$*"
}

function mp3 {
    # Get the best audio, convert it to MP3, and save it to the current
    # directory.
    youtube-dl --default-search=ytsearch: \
               --restrict-filenames \
               --format=bestaudio \
               --extract-audio \
               --audio-format=mp3 \
               --audio-quality=1 "$*"
}

function goto()
{
  local _command;
  if [ $# -eq 0 ]; then
    _command="echo $FUNCNAME '[prpy|roi|ves|vpy|w]'?";
  else
    shift $(($#-1));
    ARGUMENT=$1;

    success=1;
    case $ARGUMENT in
      prpy)
        _command="cd productquality/ads/accounts/credit_terms";;
      roi | ro-i)
        _command="g4d ro-i";;
      ves)
        _command="cd onlinesales/riskops/vesuvius";;
      vpy)
        _command="cd onlinesales/riskops/vesuvius/credit_terms";;
      w | www)
        _command="cd ~/www";;
      *)
        echo "Did you mean one of \"$FUNCNAME [prpy|roi|ves|vpy|w]\"?";
        success=0;;
    esac

    if [ $success -eq 1 ]; then echo "${_command}"; fi
  fi

  if [ -n "${_command}" ]; then
    eval "${_command}";
  fi
}

function mcd ()
{
  DirToCreateAndChangeTo="$1";
  if ( [ $# -ne 1 ] || [ ! -d "${DirToCreateAndChangeTo}" -a -e "${DirToCreateAndChangeTo}" ] ); then
    # Number of arguments != 1; OR
    # Argument is a file.
    # Chicken out!
    echo "Either incorrect number of arguments, or a file by that name already exists. Bailing!";
  elif [ -d "${DirToCreateAndChangeTo}" ]; then
    # Is a directory;
    echo -n "${PWD} -> "
    cd "${DirToCreateAndChangeTo}";
    echo "${PWD}"
  else
    mkdir -pv "${DirToCreateAndChangeTo}";
    if [ $? -ne 0 ]; then
      echo "Unable to create directory: ${DirToCreateAndChangeTo}. Bailing!";
    else
      echo -n "${PWD} -> "
      cd "${DirToCreateAndChangeTo}";
      echo "${PWD}"
    fi
  fi
}

function show_archive()  # not tested on mac
{
  if [ -f $1 ]; then
    case $1 in
      *.tar.gz)   gunzip -c $1 | tar -tf - -- ;;
      *.tar.bz2)  bunzip2 -c $1 | tar -tf - -- ;;
      *.tar)      tar -tf $1 ;;
      *.tgz)      tar -ztf $1 ;;
      *.zip)      unzip -l $1 ;;
      *)      echo "'$1' Error. Please go away" ;;
    esac
  else
    echo "'$1' is not a valid archive"
  fi
}

function gojo ()
{
  local FILENAME="${1}";
  if [ -f $1 ]; then
  case $1 in
    *.tar)
    tar xvf "$FILENAME";;
    *.tar.gz)
    tar xzvf "$FILENAME";;
    *.tgz)
    tar xzvf "$FILENAME";;
    *.gz)
    gunzip "$FILENAME";;
    *.tbz)
    tar xjvf "$FILENAME";;
    *.tbz2)
    tar xjvf "$FILENAME";;
    *.tar.bz2)
    tar xjvf "$FILENAME";;
    *.tar.bz)
    tar xjvf "$FILENAME";;
    *.bz2)
    bunzip2 "$FILENAME";;
    *.tar.Z)
    tar xZvf "$FILENAME";;
    *.Z)
    uncompress "$FILENAME";;
    *.zip)
    unzip "$FILENAME";;
    *.rar)
    unrar x "$FILENAME";;
  esac
  fi
}

function strjoin ()
{
  local ifs="$1";
  local output=""
  shift;
  for part in "$@"; do
    output="$output$ifs$part"
  done
  echo "${output#${ifs}}"
}

function weather ()
{
  local location="$(strjoin \%20 $*)"
  curl -s "http://api.openweathermap.org/data/2.5/weather?q=$location&units=metric" \
    | jq .main.temp | figlet -kcf big
}
