#!/bin/bash

# TODO: install sshpass

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

cd "${SDPATH}"; echo cd "${PWD}"

CMD=(./git-populate-submodules.sh)
echo + "${CMD[@]}" && "${CMD[@]}"

# echo
# CMD=(./build-all.sh)
# echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(./generate-compdb.sh)
echo + "${CMD[@]}" && "${CMD[@]}"
