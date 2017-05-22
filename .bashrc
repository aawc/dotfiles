
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  source /etc/bash_completion
fi

HOSTNAME="$(hostname)"
# for resolving pesky os differing switches
OS="$(uname)"

DOTFILES_DIR_PREFIX="rc"
DOTFILES_DIR="${HOME}/${DOTFILES_DIR_PREFIX}"

export BASH_COMMON_DIR='common'
BashBaseFile="${DOTFILES_DIR}/${BASH_COMMON_DIR}/bash_base.sh"
source "${BashBaseFile}"

HostBashRC="${DOTFILES_DIR}/${HOSTNAME}/bashrc.sh"
includeFile "${HostBashRC}"

case "$-" in
  *i*)
    SHELL_IS_INTERACTIVE=true ;;
  *)
    SHELL_IS_INTERACTIVE=false ;;
esac

if [ ${SHELL_IS_INTERACTIVE} -a -n "${PS1}" ]; then  # If running interactively, then run till fi at EOF:

if [ "$TERM" = "screen" ]; then
  export TERM="xterm"
fi

# Bash settings
#umask 007
#ulimit -S -c 0      # Don't want any coredumps
#set -o notify       # notify when jobs running in background terminate
set -o noclobber    # prevents catting over file
#set -o ignoreeof   # can't c-d out of shell

# Enable options:
shopt -s cdspell         # auto fixes cd / spelling mistakes
shopt -s cdable_vars
shopt -s checkhash
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
shopt -s cmdhist
shopt -s extglob    # necessary for programmable completion
shopt -s histappend histreedit histverify
shopt -s no_empty_cmd_completion  # bash>=2.04 only
shopt -s sourcepath
shopt -u mailwarn

stty stop undef
stty start undef

# Aliases
if [ -f dircolors ]; then
  eval `dircolors -b`
fi
if [ $OS = "Linux" ]; then
  alias ls='ls --color=auto -h'
elif [ $OS = "Darwin" ]; then
  alias ls='ls -G'
fi

if [ "${OS}" = "Linux" ]; then
  SUDO="sudo";
elif [ "${OS}" = "SunOS" ]; then
  SUDO="pfexec";
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

function CD ()
{
  if [ "${DEBUG_BASH+set}" = "set" ]; then
    set -x;
  fi

  if ( [ $# -ne 1 ] || [ ! -d ${1} -a ! -e ${1} ] ); then
    # Number of arguments != 1; OR
    # Argument is neither a directory nor a file.
    # Chicken out!
    cd $@;
  elif [ -d ${1} ]; then
    # Is a directory;
    cd ${1};
  else
    # Is a file (may not be regular; doesn't matter);
    local answer; local parentdirname;
    parentdirname="$(dirname ${1})";
    printf "cd to '%s'? [y]: " ${parentdirname};
    read answer;
    if [ "${answer+set}" = "set" ]; then
      answer="y";
    fi
    if [ "${answer}" = "y" ]; then
      cd ${parentdirname};
    fi
  fi

  if [ "${DEBUG_BASH+set}" = "set" ]; then
    set +x;
  fi
}

function cp_p()
{
  set -e
  strace -q -ewrite cp -- "${1}" "${2}" 2>&1 | awk '{
    count += $NF
      if (count % 10 == 0) {
        percent = count / total_size * 100
        printf "%3d%% [", percent
        for (i=0;i<=percent;i++)
          printf "="
        printf ">"
        for (i=percent;i<100;i++)
          printf " "
        printf "]\r"
      }
    }
    END { print "" }'
  total_size=$(stat -c '%s' "${1}") count=0
}

export GREP_COLOR='1;37;41'

# PATH
PATH=$PATH:/usr/local/sbin:/usr/sbin
PATH=$PATH:$HOME/.local/bin
PATH=$PATH:/usr/local/git/current/bin

# Remove duplicate path
PATH="$(echo "${PATH}" | tr ':' '\n' | sort | uniq | tr '\n' ':')"
PATH="${HOME}/work/chrome/depot_tools:${PATH}"
PATH="/usr/local/bin:${PATH}"
export PATH="$HOME/bin:${PATH}"

# Misc Variables
export EDITOR="vim"
export VISUAL="vim"
export HISTCONTROL=ignoredups
export HISTSIZE=1000
export HISTTIMEFORMAT="%h/%d - %H:%M:%S | "
export HOSTFILE=$HOME/.hosts
export LESS='-RXi#3N'

# Functions
function _exit()
{
  echo -e "${RED}So long and thanks for all the fish${NC}"
}
trap _exit EXIT

function sendrc()
{
  scp ~/.bashrc $1:~/.bashrc.$HOST
  scp ~/.screenrc $1:~/.screenrc.$HOST
  scp ~/.vimrc $1:~/.vimrc.$HOST
  scp ~/.gvimrc $1:~/.gvimrc.$HOST
  scp ~/.muttrc $1:~/.muttrc.$HOST
}

function sendbashrc()
{
  scp ~/.bashrc $1:~/.bashrc.$HOST
}

function sendvimrc()
{
  scp ~/.vimrc $1:~/.vimrc.$HOST
}

function burc()
{
  cp -f ~/.bashrc ~/data/ref/rc/bashrc
  cp -f ~/.bash_profile ~/data/ref/rc/bash_profile
  cp -f ~/.vimrc ~/data/ref/rc/vimrc
  cp -f ~/.gvimrc ~/data/ref/rc/gvimrc
  cp -f ~/.toprc ~/data/ref/rc/toprc
}

function ds()  # invalid du option on mac
{
  echo 'size of directories in MB'
  if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo 'you did not specify a directy, using pwd'
    DIR=$(pwd)
    find $DIR -maxdepth 1 -type d -exec du -sm \{\} \; | sort -nr
  else
    find $1 -maxdepth 1 -type d -exec du -sm \{\} \; | sort -nr
  fi
}

function repeat()
{
  local i max
  max=$1; shift;
  for ((i=1; i <= max ; i++)); do  # --> C-like syntax
  eval "$@";
  done
}

function ii()  # get current host related info  # kind of works on mac.  different interface.  dynamic-able?
{
  echo -e "\nYou are logged onto ${RED}${HOSTNAME}"
  echo -e "\nAdditionnal information:$NC " ; uname -a
  echo -e "\n${RED}Users logged on:$NC " ; w -h
  echo -e "\n${RED}Current date :$NC " ; date
  echo -e "\n${RED}Machine stats :$NC " ; uptime
  echo -e "\n${RED}Disk space :$NC " ; df
  echo -e "\n${RED}Memory stats :$NC " ; free
  my_ip 2>&- ;
  echo -e "\n${RED}Local IP Address :$NC" ; echo ${MY_IP:-"Not connected"}
  echo
}

function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }  # works
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }  # doesn't work on mac. iilegal option -f

function ff() { find . -name '*'$1'*' ; }  # find a file  # works
function fe() { FPAT="${1}"; find . -name '*'${FPAT}'*' -exec ${@} {} \; ; }  # find a file and run $2 on it  # works

function lowercase()  # move filenames to lowercase  # not working on mac
{
  for file ; do
    filename=${file##*/}
    case "$filename" in
      */*) dirname==${file%/*} ;;
      *) dirname=.;;
    esac
    nf=$(echo $filename | tr A-Z a-z)
    newname="${dirname}/${nf}"
    if [ "$nf" != "$filename" ]; then
      mv "$file" "$newname"
      echo "lowercase: $file --> $newname"
    else
      echo "lowercase: $file not changed."
    fi
  done
}

function rot13()
{
  if [ $# -eq 0 ]; then
    tr '[a-m][n-z][A-M][N-Z' '[n-z][a-m][N-Z][A-M]'
  else
    echo $* | tr '[a-m][n-z][A-M][N-Z' '[n-z][a-m][N-Z][A-M]'
  fi
}

function start_fish()
{
  which_fish="`which fish 2>/dev/null`"
  if [ "${which_fish}" != "" ]; then
    ${which_fish}
  fi
}

function create_zip()
{
  #7za a 20130930-GoogleRelocationSubmittedDocuments-col.zip 20130930-* -tzip -p
  OUT_FILE="${1}"
  shift
  IN_FILES="${*}"
  echo "OUT_FILE: $OUT_FILE"
  echo "IN_FILES: $IN_FILES"
  ZIP_COMMAND="7za a ${OUT_FILE} ${IN_FILES} -tzip -p"
  echo ${ZIP_COMMAND}
  eval ${ZIP_COMMAND}
}

fi
#end interactive check

