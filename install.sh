#!/bin/bash

function InstallDotFiles
{
  local git_dir="$(GetGitRepoPath ${0})"
  local old_extension=".OLD"

  for TARGET in .bashrc .gdbinit .gitconfig .gitignore .pdbrc .pylintrc .screenrc \
    .tmux.conf .vimrc .config/powerline rc
  do
    local filepath_git="${git_dir}/${TARGET}"
    if [ -f "${filepath_git}" -o -d "${filepath_git}" ];
    then
      local filepath_home="${HOME}/${TARGET}"
      mkdir -p -v $(basename "${filepath_home}")
      ln -svi "${filepath_git}" "${filepath_home}"
    fi
  done
  rm -v "${HOME}/rc/rc" 2>/dev/null
  ln -svi "${git_dir}/rc/common/.vim/colors/" "${HOME}/.vim/"

  local lower_os="$(uname | tr [A-Z] [a-z])"
  ln -svi "${git_dir}/rc/${lower_os}" "${git_dir}/rc/$(hostname)"
  rm -v "${git_dir}/rc/${lower_os}/${lower_os}" 2>/dev/null
}

function GetGitRepoPath
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
