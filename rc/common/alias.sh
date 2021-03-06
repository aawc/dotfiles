alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias bash_permanent_history="less ~/.bash_permanent_history"
alias be="vi ~/.bashrc;source ~/.bashrc"
alias blaze="nice blaze"
alias c="clear"
alias cinnamon-restart='cinnamon –replace -d :0.0 > /dev/null 2>&1 &'
alias cm='git commit -m'
alias df="df -h"
alias dotfiles='cd ${HOME}/git/hub/aawc/dotfiles'

alias gh='cd ${HOME}/git/hub'

alias l="ls"
alias s="ls"
alias lh="ls -lh .[a-zA-Z0-9]*"
alias ll="ls -lh"
alias l1="ls -1h"
alias lla="ls -lha"

alias mkdir="mkdir -p"
alias mv="mv -i"

alias network_reset="sudo service network-manager stop; sudo service network-manager start"

alias path='echo -e ${PATH//:/\\n}'
alias pcd="cd -"
alias pico="vi"
alias psa="ps aux"
alias rl="source ${HOME}/.bashrc"
alias ve="vi ~/.vimrc"
alias vi="vim"
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
alias flux='rm /tmp/redshift.log 2>/dev/null; nohup redshift -l 37.3894:-122.0819 -t 5700:3600 -g 0.8 -m vidmode 2>&1 > /tmp/redshift.log &'
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
