#!/bin/bash

alias buildifier='buildifier -a -v'
alias desc='g4 describe -s'
alias descl='g4 describe'
alias f1-sql-prod=/google/data/ro/projects/storage/f1/tools/f1-sql-prod
alias f1-sql-devel=/google/data/ro/projects/storage/f1/tools/f1-sql-devel
alias g5='/google/data/ro/projects/shelltoys/g5.sar'
alias gg='g4'
alias ggd='g4d'
alias ggcdiff='P4DIFF=colordiff g4 diff'
alias ggvdiff='P4DIFF=vimdiff g4 diff'
alias gjslint='gjslint --jslint_error=all  --strict --closurized_namespaces=goog'
alias openedg4='g4 opened'
alias prodaccess='prodaccess -g --corp_ssh'
alias submitg4='g4 submit'
alias statusg4='g4 status'
alias vesuvius_running_ports='ps aux | grep vesuvius_server | sed -e "s/.*port.\([0-9]*\).*/\1/" | grep "^[0-9]*$" | sort | uniq'


# Directories
alias pqoanon='g4d && cd productquality/common/pqoanon/code'
alias quarry='g4d && cd productquality/safebrowsing/quarry'
