#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [ ! -d "${SDPATH}" ]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

cd "${SDPATH}"; echo + cd "${PWD}"

echo
CMD=(./build-all.sh); echo + "${CMD[@]}" && "${CMD[@]}"

PRJ_ROOT_PATH="${SDPATH}/.."
readonly PRJ_ROOT_PATH="$(cd "${PRJ_ROOT_PATH}" && pwd)"

readonly BAZEL_WORKSPACE_PATH="${PRJ_ROOT_PATH}"

# https://stackoverflow.com/questions/40260242/how-to-set-c-standard-version-when-build-with-bazel
export CC=gcc-11
export CXX=g++-11

cd "${BAZEL_WORKSPACE_PATH}"; echo + cd "${PWD}"

readonly MERGE=$(realpath external/bazelbuild-rules-compdb/merge.js)
readonly UNBOX=$(realpath external/bazelbuild-rules-compdb/unbox.js)

readonly COMPDB_TMPD_PATH="${PWD}/.cache/compdb"

echo
CMD=(bazel build --subcommands //:compdb '--color=yes' '--curses=yes')
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(rm -frv)
CMD+=("${COMPDB_TMPD_PATH}")
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(mkdir -vp "${COMPDB_TMPD_PATH}")
echo + "${CMD[@]}" && "${CMD[@]}"

readonly BAZ_COMPDB_PATH="${COMPDB_TMPD_PATH}/bazel-compile_commands.json"

(echo
 readonly BAZ_COMPDB_PATH_0="$(realpath "bazel-bin/compile_commands.json")"
 readonly BAZ_COMPDB_PATH_1="${COMPDB_TMPD_PATH}/`
   `bazel-compile_commands-1.json"
 readonly BAZ_COMPDB_CONFIG_PATH="$(realpath unbox-bazel.config.js)"

 CMD=(cp "${BAZ_COMPDB_PATH_0}" "${BAZ_COMPDB_PATH_1}")
 echo + "${CMD[@]}" && "${CMD[@]}"

 CMD=(chmod "a-x,a+r" "${BAZ_COMPDB_PATH_1}")
 echo + "${CMD[@]}" && "${CMD[@]}"

 CMD=("${UNBOX}")
 CMD+=("${BAZ_COMPDB_PATH}")
 CMD+=("${BAZ_COMPDB_PATH_1}")
 CMD+=("${BAZEL_WORKSPACE_PATH}")
 CMD+=("${BAZ_COMPDB_CONFIG_PATH}")
 echo + "${CMD[@]}" && "${CMD[@]}")

echo
CMD=("${MERGE}")
CMD+=(-o "${COMPDB_TMPD_PATH}/compile_commands.json")
CMD+=("${BAZ_COMPDB_PATH}")
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(cp -vf "${COMPDB_TMPD_PATH}/compile_commands.json" "${PRJ_ROOT_PATH}")
echo + "${CMD[@]}" && "${CMD[@]}"
