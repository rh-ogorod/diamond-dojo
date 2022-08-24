#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

cd "${SRC_PATH}"; echo + cd "${PWD}"

echo
CMD=(echo)
# CMD+=('"using mpi : : <find-shared-library>impi ;"')
CMD+=('"using mpi ;"')
CMD+=("> tools/build/src/user-config.jam")
echo + "${CMD[@]}" && eval "${CMD[@]}"

CMD=(echo)
CMD+=('"using gcc : 11~c++17 : g++-11 : <cxxflags>\"-std=c++17 -fpermissive\" ;"')
CMD+=(">> tools/build/src/user-config.jam")
echo + "${CMD[@]}" && eval "${CMD[@]}"

CMD=(echo)
CMD+=('"using gcc : 11~c++20 : g++-11 : <cxxflags>-std=c++20 ;"')
CMD+=(">> tools/build/src/user-config.jam")
echo + "${CMD[@]}" && eval "${CMD[@]}"

echo
CMD=(mkdir -vp "${BLD_PATH}")
echo + "${CMD[@]}" && "${CMD[@]}"
