#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

if [[ -z "${RULEDIR:-}" ]]; then
  echo RULEDIR env var should be set by Bazel
  exit 1
fi

echo
CMD=(mkdir -p "${RULEDIR}/lib_copy")
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(cp -Lf "${RULEDIR}"/dist/lib/*.a "${RULEDIR}/lib_copy")
echo + "${CMD[@]}" && "${CMD[@]}"
