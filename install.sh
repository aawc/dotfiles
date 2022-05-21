#!/bin/bash

function InstallDotFiles
{
  local git_dir="$(_GetGitRepoPath ${0})"
  local old_extension=".OLD"

  for TARGET in \
    .ackrc \
    .bashrc \
    .config/coc \
    .config/fish \
    .config/nvim/coc-settings.json \
    .config/nvim/init.vim \
    .config/powerline \
    .config/redshift.conf \
    .config/sublime-text-3/Packages/User \
    .gdbinit \
    .gitconfig \
    .gitignore \
    .local/share/nvim/site/autoload/plug.vim \
    .pdbrc \
    .pylintrc \
    .screenrc \
    .tmux.conf \
    .tmuxinator \
    .vimrc \
    .vim \
    .zshrc \
    rc
  do
    local filepath_git="${git_dir}/${TARGET}"
    if [ -f "${filepath_git}" -o -d "${filepath_git}" ];
    then
      local filepath_home="${HOME}/${TARGET}"
      local filename="$(basename ${TARGET})"
      if [[ ! -e "${filepath_home}" ]]; then
        mkdir -p -v "$(dirname ${filepath_home})"
        ln -svi "${filepath_git}" "${filepath_home}"
      else
        echo "Exists: ${filepath_home}"
      fi
    fi
  done

  local hostname="$(hostname)"
  local os_dir_path="${git_dir}/rc/${hostname}"
  if [[ ! -e "${os_dir_path}" ]]; then
    local lower_os="$(uname | tr [A-Z] [a-z])"
    ln -svi "${git_dir}/rc/${lower_os}" "${os_dir_path}"
  fi
}

function ShowSuggestions
{
  echo "====================="
  echo "Thanks for installing"
  echo "Consider: sudo apt-get install aptitude fish tmuxinator neovim powerline powerline-gitstatus nodejs locate"
}

function _GetGitRepoPath
{
  local script_path="${PWD}/${0}"
  local script_dir="$(dirname ${script_path})"
  local old_dir="${PWD}"
  cd "${script_dir}"
  script_dir="${PWD}"
  cd "${old_dir}"
  echo "${script_dir}"
}

InstallDotFiles $0
ShowSuggestions
