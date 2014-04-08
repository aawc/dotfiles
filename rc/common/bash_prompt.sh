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

function power_prompt()
{
  host_load
  set_xtitle
  if [ "$UID" -eq 0 ]; then
    PS1="[\[${HOST_COLOR}\]\A\[${NC}\]][\[${red}\]\u@\h: \w]\$\[${NC}\] "
  else
    PS1="[\[${HOST_COLOR}\]\A\[${NC}\]][\[${cyan}\]\u@\h\[${NC}\]: $(pretty_pwd)]\$ "
  fi
}

function parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}

function parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

function pretty_pwd() {
  local pwd=${PWD}

  pwd=${pwd/\/google\/src\/cloud\/${USER}\//@}
  pwd=${pwd/${HOME}\/work\/git\//@${red}$(parse_git_branch)${NC}\/}
  pwd=${pwd/${HOME}\/github\//@${red}$(parse_git_branch)${NC}\/}
  pwd=${pwd/$HOME/\~}
  echo $pwd
}

if [ $PROMPT = "power" ]; then
  PROMPT_COMMAND=power_prompt
elif [ $PROMPT == "pretty" ]; then
  PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] $(pretty_pwd) \$\[\033[00m\] '
else
  if [ "$UID" -eq 0 ]; then
    PS1="[\A][\[${red}\]\u@\h: \w]\$\[${NC}\] "
  else
    PS1="[\A][\[${cyan}\]\u@\h\[${NC}\]: \w]\$ "
  fi
fi
