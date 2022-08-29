#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd "${SDPATH}" && pwd)"

cd "${SDPATH}"; echo + cd "${PWD}"

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
