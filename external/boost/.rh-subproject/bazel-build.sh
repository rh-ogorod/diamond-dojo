#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

readonly EXECPATH="$(cd "${SDPATH}/.." && pwd)"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

if [[ -z "${RULEDIR:-}" ]]; then
  echo RULEDIR env var should be set by Bazel
  exit 1
fi

CMD=("${SDPATH}/build.sh")
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(cp -r "$EXECPATH/package" "${RULEDIR}")
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(cp -r "$EXECPATH/dist" "${RULEDIR}")
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(cp -r "$EXECPATH/build" "${RULEDIR}")
echo + "${CMD[@]}" && "${CMD[@]}"
