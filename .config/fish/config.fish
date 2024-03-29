set normal (set_color normal)
set magenta (set_color magenta)
set yellow (set_color yellow)
set green (set_color green)
set red (set_color red)
set gray (set_color -o black)

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_dirtystate '*'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_stagedstate '->'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_untrackedfiles 'UT'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_stashstate 'ST'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'


function fish_prompt
  set last_status $status

  set_color $fish_color_cwd
  printf '%s ' (prompt_pwd)
  set_color normal

  set_color -o 586e75
  printf '%s' (date "+%H:%M:%S")
  set_color normal
  printf '%s ' (__fish_git_prompt)
  if [ $last_status -ne 0 ]
    set_color $fish_color_error
    printf '[%s] ' $last_status
    set_color normal
  end

  set_color normal
end

source ~/.config/fish/abbrs.fish

# For signing git commits
set GPG_TTY (tty)

# PATH
if test -d /usr/local/bin
  set -x PATH $PATH /usr/local/bin
end
if test -d $HOME/bin/homebrew/bin
  set -x PATH $PATH $HOME/bin/homebrew/bin
end
if test -d $HOME/bin/pdfjam/bin
  set -x PATH $PATH $HOME/bin/pdfjam/bin
end
set -x PATH $PATH $HOME/rc/common/functions
set -x PATH $PATH $HOME/work/chrome/depot_tools
