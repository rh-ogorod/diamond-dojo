#!/bin/bash

# TODO: install sshpass

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

cd "${SDPATH}/.rh-project"; echo cd "${PWD}"

CMD=(./bootstrap.sh)
echo + "${CMD[@]}" && "${CMD[@]}"
