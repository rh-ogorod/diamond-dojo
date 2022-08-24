#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

if [[ ! -f "${SRC_PATH}/b2" ]]; then
  CMD=("${SDPATH}/bootstrap.sh")
  echo + "${CMD[@]}" && "${CMD[@]}"
fi

cd "${SRC_PATH}"; echo + cd "${PWD}"

CMD=(rm -f "$BLD_PATH/b2.log")
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(./b2)
CMD+=("${BOOST_BUILD_CMD[@]}")
CMD+=('2>&1' '|' tee -a "$BLD_PATH/b2.log")
echo + "${CMD[@]}" && eval "${CMD[@]}"

echo
CMD=("${SDPATH}/build-log.sh")
echo + "${CMD[@]}" && "${CMD[@]}"
