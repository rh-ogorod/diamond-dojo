#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

echo xxxxxxxxxxxxxxxxxx $1

RULEDIR="${PWD}"

CMD=("${SDPATH}/build.sh")
echo + "${CMD[@]}" && "${CMD[@]}"
