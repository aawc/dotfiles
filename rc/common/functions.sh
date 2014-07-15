#!/bin/bash

function rescreen
{
  local screenName="${1}"
  if [ -z "${screenName}" ]; then
    screen -ls
    return
  fi

  local intendedScreenName="$(screen -ls | grep "^\s.*${screenName}" | awk '{print $1}')"
  if [ -z "${intendedScreenName}" ]; then
    printf "Screen %s not found.\n" $screenName
    printf "$(screen -ls)"
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

function epoch(){
  [[ -z "${1}" ]] || date -d @"${1}"
}

function epoch_milli(){
  [[ -z "${1}" ]] && return

  local time_in_milli="${1}"
  local time_in_secs="$( echo "${time_in_milli} / 1000" | bc -l )"
  epoch "${time_in_secs}"
}

function source_file() {
  local file_to_source="${1}"
  if [[ -f "${file_to_source}" ]]; then
    source "${file_to_source}"
  fi
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
