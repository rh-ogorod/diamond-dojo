#!/bin/bash

set -eu
set -o pipefail

SPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SPATH}" ]]; then SPATH="${PWD}"; fi
readonly SPATH="$(cd "${SPATH}" && pwd)"

PRJ_ROOT_PATH="${SPATH}/.."
readonly PRJ_ROOT_PATH="$(cd "${PRJ_ROOT_PATH}" && pwd)"

# Stollen from here:
# https://stackoverflow.com/questions/1777854/how-can-i-specify-a-branch-tag-when-adding-a-git-submodule
git submodule foreach --recursive \
  'branch="$(git config -f $toplevel/.gitmodules submodule.$name.branch)"; \
   if [ ! -z "${branch}" ]; then \
     echo No branch specified in .gitmodules for this subsodule
   else
     git checkout $branch; \
     git fetch --all; \
   fi'
