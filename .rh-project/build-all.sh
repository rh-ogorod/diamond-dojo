#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [ ! -d "${SDPATH}" ]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

cd "${SDPATH}"; echo cd "${PWD}"

echo
CMD=(./build-hello-world.sh)
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(./build-hello-another-world.sh)
echo + "${CMD[@]}" && "${CMD[@]}"
