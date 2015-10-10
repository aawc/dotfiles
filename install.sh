#!/bin/bash

function InstallDotFiles
{
  local git_dir="$(GetGitRepoPath ${0})"
  local old_extension=".OLD"

  for TARGET in .bashrc .gdbinit .gitconfig .gitignore .pdbrc .pylintrc .screenrc \
    .vimrc rc
  do
    local filepath_git="${git_dir}/${TARGET}"
    if [ -f "${filepath_git}" -o -d "${filepath_git}" ];
    then
      local filepath_home="${HOME}/${TARGET}"
      ln -svi "${filepath_git}" "${filepath_home}"
    fi
  done
  ln -svi "${git_dir}/rc/common/.vim/colors/" "${HOME}/.vim/"

  echo "Now run: ln -s ${git_dir}/rc/<appropriate_directory> $(hostname)"
  echo "  where appropriate_directory matches your machine most closely"
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
