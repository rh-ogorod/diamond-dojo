#!/bin/bash

set -eu
set -o pipefail

ulimit -c unlimited

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [ ! -d "${SDPATH}" ]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

cd "${INDEX_PATH}"; echo cd "${PWD}"

echo
CMD=(bazel)
CMD+=("${BAZEL_RUN_CMD[@]}")
CMD+=("${BAZEL_DEBUG_CMD[@]}")
CMD+=("${BAZEL_TERM_CMD[@]}")
CMD+=(//packages/diamond)
CMD+=('2>&1')
echo + "${CMD[@]}" && eval "${CMD[@]}"
