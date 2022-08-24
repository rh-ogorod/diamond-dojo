#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

cd "${SRC_PATH}"; echo + cd "${PWD}"

CMD=(git submodule update --init --recursive "--jobs=${NPROC}")
echo + "${CMD[@]}" && "${CMD[@]}"
