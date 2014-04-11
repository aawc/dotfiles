alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias be="vi ~/.bashrc;source ~/.bashrc"
alias c="clear"
alias cdcd='cd && cd -'
alias df="df -h"

alias l="ls"
alias s="ls"
alias lh="ls -lh .[a-zA-Z0-9]*"
alias ll="ls -lh"
alias l1="ls -1h"
alias lla="ls -lha"

alias mkdir="mkdir -p"
alias mv="mv -i"
alias path="env | grep PATH"
alias pcd="cd -"
alias pico="vi"
alias psa="ps aux"
alias rl="source $HOME/.bashrc"
alias showx="echo USE_X current status = $USE_X"
alias ve="vi ~/.vimrc"
alias vi="vim"
alias vim="vim -X"
alias md='mkdir'
alias rf='rm -rf'
alias dir='echo "" ; find * -follow -maxdepth 0 -type d -printf "%f/ " ; echo;echo;'
alias chex='chmod u+x '
alias topme='top -u ${USER}'
alias g='g4'
alias v='vim'
alias make='nice make'
alias gvim='gvim -p'
alias sl='ls'
alias grep='grep --color="auto"'
alias disp='export DISPLAY=:0.0'
alias diff='diff --suppress-common-lines --strip-trailing-cr -y'
alias flux='rm /tmp/redshift.log 2>/dev/null; nohup redshift -l 37.3894:-122.0819 -t 5700:3600 -g 0.8 -m vidmode 2>&1 > /tmp/redshift.log '
alias less='less -i --follow-name -N -R'
alias bash_completion='source /etc/bash_completion'
alias pdfx='wine ~/Dropbox/Stuff/Runnables/Windows/PDFX_Vwr_Port/PDFXCview.exe'
alias scls='screen -ls'
alias scrd='screen -d -R'
alias apti='sudo aptitude install'
alias issyn='ps -efA | grep synergyc'
alias goh='goto h'
alias gow='goto www'
alias goroi='goto roi'
alias roi='goto roi'

alias upgrade='sudo aptitude update && sudo aptitude safe-upgrade'
