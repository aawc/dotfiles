#!/bin/bash

PROMPT="power"          # sets prompt style.  choices: power or anything else to disable

function host_load()
{
  THRESHOLD_LOAD=50
  COLOUR_LOW=$GREEN
  COLOUR_HIGH=$RED

  if [ $OS = "Linux" -o $OS = "SunOS" ]; then
    ONE=$(uptime | sed -e "s/.*load average: \(.*\...\),\(.*\...\),\(.*\...\)/\1/" -e "s/ //g")
  fi
  if [ $OS = "Darwin" ]; then
    ONE=$(uptime | sed -e "s/.*load averages: \(.*\...\)\(.*\...\)\(.*\...\)/\1/" -e "s/ //g")
  fi
  if [ "${ONE+set}" = "set" ]; then
    ONEHUNDRED=$(echo -e "scale=0 \n $ONE/0.01 \nquit \n" | bc)
    if [ $ONEHUNDRED -gt $THRESHOLD_LOAD ]
    then
      HOST_COLOR=$COLOUR_HIGH
    else
      HOST_COLOR=$COLOUR_LOW
    fi
  else
    HOST_COLOR=$COLOUR_LOW
  fi
}

function set_xtitle()
{
  if [ $TERM == "xterm-256color" ]; then
    echo -ne "\033]0;${USER}: ${PWD}\007"
  fi
}

function power_prompt()
{
  host_load
  set_xtitle
  local promptTextColor="${cyan}"
  if [ "$UID" -eq 0 ]; then
    promptTextColor="${red}"
  fi
  local prompColor="${white}"
  local prodaccessStatus=""
  if is_prodaccess_missing ; then
    prodaccessStatus="$(prodaccess_missing_message) "
    prompColor="${RED}"
  fi
  PS1="[\[$HOST_COLOR\]\$(date +%H:%M:%S)\[${NC}\]]"
  PS1="$PS1[\[${promptTextColor}\]\u@\h\[$NC\]: \[$YELLOW\]$(pretty_pwd)\[$NC\]]"
  PS1="$PS1[\#]\[${prompColor}\]\$ ${prodaccessStatus}\[$NC\]"

  PS2="\[$WHILE\]=>\[$NC\]"
}

function parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}

function parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

function g4_client() {
  local g4DirCommonPrefix="${1}"
  # grep so that if the current directory does not match the pattern, it's skipped.
  echo $PWD | grep "${g4DirCommonPrefix}" | sed -e "s#${g4DirCommonPrefix}/\([^/]*\)/google3.*#\1#"
}

function g4_dir_prefix() {
  local g4DirCommonPrefix="${1}"
  local g4Client="${2}"
  echo $PWD | sed -e "s#\(${g4DirCommonPrefix}/${g4Client}\/google3[/]*\).*#\1#"
}

function git_parent_of_root_dir() {
  local rootDirectory="$(git rev-parse --show-toplevel 2>/dev/null)"
  dirname $rootDirectory
}

function pretty_pwd() {
  local pwd="${PWD}"
  local g4DirCommonPrefix="/google/src/cloud/${USER}"
  local g4Client="$(g4_client ${g4DirCommonPrefix})"
  if [[ -n "${g4Client}" ]]; then
    local g4DirPrefix="$(g4_dir_prefix ${g4DirCommonPrefix} ${g4Client})"
    pwd="${pwd/${g4DirPrefix}/@${g4Client} }"
  fi

  # Is git directory?
  git rev-parse --git-dir > /dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    local gitBranch="$(parse_git_branch)"
    local parentOfRoot="$(git_parent_of_root_dir)"
    pwd=${pwd/${parentOfRoot}\//@"\[${red}\]"${gitBranch}"\[${YELLOW}\] "}
  fi
  pwd=${pwd/$HOME/\~}
  echo $pwd
}

if [ $PROMPT = "power" ]; then
  PROMPT_COMMAND=power_prompt
else
  if [ "$UID" -eq 0 ]; then
    PS1="[\A][\[${red}\]\u@\h: \w]\$\[${NC}\] "
  else
    PS1="[\A][\[${cyan}\]\u@\h\[${NC}\]: \w]\$ "
  fi
fi

# Bash permanent history
HISTTIMEFORMAT='%F %T '
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo $$ $USER \ "$(history 1)" >> ~/.bash_permanent_history'
