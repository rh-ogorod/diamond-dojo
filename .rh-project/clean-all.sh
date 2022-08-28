#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [ ! -d "${SDPATH}" ]; then SDPATH="${PWD}"; fi
SDPATH="$(cd -P "${SDPATH}" && pwd)"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

cd "${PRJ_ROOT_PATH}" && echo cd "${PWD}"

echo
CMD=(./external/boost/.rh-subproject/clean.sh)
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(bazel clean --expunge)
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(yarn app:clean)
echo + "${CMD[@]}" && "${CMD[@]}" ||:

echo
CMD=(rm -rf .cache)
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(rm -rf node_modules)
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(rm -rf packages/*/node_modules)
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(find . -name '*.~undo-tree~' -delete -print)
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(find . -name '#*#' -delete -print)
echo + "${CMD[@]}" && "${CMD[@]}"
