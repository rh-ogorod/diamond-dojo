#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

# cd "${PRJ_PATH}"; echo + cd "${PWD}"

# echo
# CMD=(./prepare.sh)
# echo "${CMD[@]}" && "${CMD[@]}"

echo
cd "${SRC_PATH}"; echo + cd "${PWD}"

mkdir -p "${BLD_PATH}"

echo
CMD=(./bootstrap.sh)
# CMD+=(--with-toolset=gcc-11)
CMD+=('2>&1' '|' tee -a "${BLD_PATH}/b2.log")
echo "${CMD[@]}" && eval "${CMD[@]}"
