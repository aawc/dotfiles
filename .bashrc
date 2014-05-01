
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

if [ ${SHELL_IS_INTERACTIVE} ]; then  # If running interactively, then run till fi at EOF:

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

function pfp
{ export P4PORT=${FPPORT}; export P4CLIENT=${FPCLIENT}; export P4USER=${FPUSER}; }
function pfpl
{ pfp; p4 login; }

function killsyn ()
{
  SYN_PID=`issyn | grep -v grep | grep 'synergyc.*vk-vista' | awk '{print $2}'`;
  if [ -n "${SYN_PID}" ]; then
  kill "${SYN_PID}"
  else
  echo "Are you sure synergy is running? This is what I got:";
  issyn;
  fi
}

#P4
export P4CURRDIR=""

#P4: Set P4 working directory
function p4cd()
{
  if [ ${#1} -gt 0 ]; then
    if [ "/" == ${1:${#1}-1} ]; then
      export P4CURRDIR=${1:0:(${#1}-1)}
    else
      export P4CURRDIR=$1
    fi
  else
    export P4CURRDIR=""
  fi
  echo "P4CURRDIR="$P4CURRDIR
}

#P4: Filelog for Nova Main
function p4log()
{
  if [ -n "$P4CURRDIR" ]; then
    COMMAND="p4 filelog //Releases/9X/Rel3/$P4CURRDIR/$@ | grep '^\s*\.\.\. #.*change' | less"
  else
    COMMAND="p4 filelog //Releases/9X/Rel3/$@ | grep '^\s*\.\.\. #.*change' | less"
  fi
  eval $COMMAND;
}

if [ "${OS}" = "Linux" ]; then
  SUDO="sudo";
elif [ "${OS}" = "SunOS" ]; then
  SUDO="pfexec";
fi
unset mounting
function mounting()
{
  if [ "${DEBUG_BASH+set}" = "set" ]; then
    set -x;
  fi

  LOGIN_AUTH_OPTS="workgroup=,username=,password="
  AUTH_OPTS="${LOGIN_AUTH_OPTS},ro"
  RW_AUTH_OPTS="${LOGIN_AUTH_OPTS},rw,dir_mode=0777,file_mode=0777"
  if [ "${OS}" = "Linux" ]; then
    MOUNT_FLAG="t";
    NFS_OPTS="";
  elif [ "${OS}" = "SunOS" ]; then
    MOUNT_FLAG="F";
    NFS_OPTS="-o vers=3";
  fi
  export SUDO MOUNT_FLAG NFS_OPTS;

  ARG=$@;
  INFILE="${HOME}/mounting"
  INFILELEN=`wc -l $INFILE | cut -d' ' -f 1`

  if [ "$ARG" ]; then
    echo -n;
  else
    ARG="LIST";
  fi

  ArgWithoutDigits=`echo $ARG | sed 's/^[0-9][0-9]*//'`
  ArgIsString=0;
  if [ "$ArgWithoutDigits" ]; then
    ArgIsString=1;
  fi

  if [ $ArgIsString -eq 1 ]; then
    if [ $ARG = "LIST" ]; then
      awk 'BEGIN {i=1;} {print i ".\t"$(NF-1)"\t->\t"$(NF); i++;}' $INFILE
    elif [ $ARG = "ALL" ]; then
      cat $INFILE
    else
      MOUNTCOMMAND=`grep "${ARG}" ${INFILE}`
      MOUNTCOUNT=`printf "%s\n" "${MOUNTCOMMAND}" | wc -l`;
      if [ ${MOUNTCOUNT} -lt 1 ]; then
        echo "Invalid argument "$ARG". Valid arguments: \"LIST\", \"ALL\", 1-"$INFILELEN;
      elif [ ${MOUNTCOUNT} -eq 1 ]; then
        echo $MOUNTCOMMAND;
        set -x;
        eval $MOUNTCOMMAND;
        set +x;
      else
        echo; echo "${MOUNTCOMMAND}";
      fi
    fi
  elif ( [ $ARG -gt 0 ] && [ $ARG -le $INFILELEN ] ); then
    MOUNTCOMMAND=`head -${ARG} ${INFILE} | tail -1`
    echo $MOUNTCOMMAND;
    eval $MOUNTCOMMAND
  else
    echo "Invalid input: "$ARG"."
    echo "Should be (> 0) and (< "$INFILELEN").";
  fi

  if [ "${DEBUG_BASH+set}" = "set" ]; then
    set +x;
  fi
}

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
#alias cd='CD'

function ExportAndSetAlias()
{
  if [ $# -eq 2 ]; then
    export $1="${2}";
    alias $1="cd ${2}";
  fi
}
#--U9--
#ExportAndSetAlias ACRO_ROOT_DIR_U9 "/work/varunk/vobs/${U9CLIENT}/";

if [ "${OS}" = "Linux" ]; then
  if [[ "$(uname -m)" =~ i*86 ]]; then
    PlatArch="l86";
  fi
elif [ "${OS}" = "Solaris" ]; then
  if [ "$(uname -p)" =~ "i*86" ]; then
    PlatArch="s86";
  elif [ "$(uname -p)" =~ "sparc" ]; then
    PlatArch="sol";
  fi
fi

function goto()
{
  if [ $# -eq 0 ]; then
    COMMAND="echo $FUNCNAME [vesuvius|h|roi|w]'?";
  else
    shift $(($#-1));
    ARGUMENT=$1;

    success=1;
    case $ARGUMENT in
      vesuvius)
        COMMAND="cd onlinesales/riskops/vesuvius";;
      h)
        COMMAND="cd ${HOME}";;
      roi | ro-i)
        COMMAND="g4d ro-i";;
      w | www)
        COMMAND="cd ~/www";;
      *) echo "Did you mean one of '$FUNCNAME [vesuvius|h|roi|w]'?";;
    esac

    if [ $success -eq 1 ]; then echo $COMMAND; fi
  fi

  if [ -n "${COMMAND}" ]; then
    eval $COMMAND;
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
PATH=$PATH:$HOME/bin
PATH=$PATH:$HOME/scripts
PATH=$PATH:${HOME}/bin/Adobe/Reader9/bin
PATH=$PATH:${HOME}/bin/w
#PATH=$PATH:/home/varunk/bin/baksmali

# Remove duplicate path
export PATH=$(echo $PATH | awk -F: '
{ for (i = 1; i <= NF; i++) arr[$i]; }
END { for (i in arr) printf "%s:" , i; printf "\n"; } ')
PATH=$HOME/bin:$PATH
PATH=$PATH:/sbin

# Misc Variables
export EDITOR="vim"
export VISUAL="vim"
export HISTCONTROL=ignoredups
export HISTSIZE=1000
export HISTTIMEFORMAT="%h/%d - %H:%M:%S | "
export HOSTFILE=$HOME/.hosts

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


function android_dev()
{
  if [ "${1+set}" != "set" ]; then
    PlatformVersion=1.5;
  else
    PlatformVersion="${1}";
  fi

  ANDROID_PATH="${AndroidNDKHome}/build/prebuilt/linux-x86/arm-eabi-4.2.1/bin"
  ANDROID_PATH="${ANDROID_PATH}:${AndroidSDKBase}/tools"
  ANDROID_PATH="${ANDROID_PATH}:`GetAndroidPlatformVersionHome "${PlatformVersion}"`/tools"
  export PATH="$ANDROID_PATH:$PATH"
}

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

function psg()
{
  if [ $# -lt 1 ] || [ $# -gt 2 ]; then  # cool way to find null $1.  also can use $# -eq 0
    echo grep running processes
    echo usage: psg [process]
  else
    ps aux | grep USER | grep -v grep
    ps aux | grep -i $1 | grep -v grep
  fi
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
  echo -e "\nYou are logged onto ${RED}$HOST"
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

function V()
{
  V_DELIMITER=":";
  FILENAME="";
  LINENUMBER="";

  if [ $# != 1 ]; then
    "$EDITOR" $@
  else
    FILENAME="${1}";
    LINENUMBER="`printf "%s" $1 | grep "${V_DELIMITER}" | sed -e 's#.*:\([0-9]*\)$#\1#g'`";

    if [ "${LINENUMBER}" != "" ]; then
      FILENAME="${1%:*}";
    else
      if [ "${2+set}" = "set" ]; then
        case "$2" in
          [0-9]*) LINENUMBER="$2";;
        esac
      fi
    fi

    if [ "${LINENUMBER}" != "" ]; then
      "$EDITOR" +"$LINENUMBER" "$FILENAME";
    else
      "$EDITOR" $@
    fi
  fi
}

function start_fish()
{
  which_fish=`which fish`
  if [ ${which_fish+set} = "set" ]; then
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
