#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

cd "${SRC_PATH}"; echo + cd "${PWD}"

CMD=(git reset --hard)
echo + "${CMD[@]}" && "${CMD[@]}"

CMD=(git submodule foreach --recursive git reset --hard)
echo + "${CMD[@]}" && "${CMD[@]}"

CMD=(git checkout ${SRC_BRANCH})
echo + "${CMD[@]}" && "${CMD[@]}"

CMD=(git clean -xdf)
echo + "${CMD[@]}" && "${CMD[@]}"

CMD=(git submodule foreach --recursive git clean -xfd)
echo + "${CMD[@]}" && "${CMD[@]}"

CMD=(rm -rf "${BLD_PATH}")
echo + "${CMD[@]}" && "${CMD[@]}"

CMD=(rm -rf "${DST_PATH}")
echo + "${CMD[@]}" && "${CMD[@]}"
