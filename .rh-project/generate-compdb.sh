#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [ ! -d "${SDPATH}" ]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

readonly BAZEL_WORKSPACE_PATH="${PRJ_ROOT_PATH}"

# https://stackoverflow.com/questions/40260242/how-to-set-c-standard-version-when-build-with-bazel
export CC=gcc-11
export CXX=g++-11

cd "${SDPATH}"; echo + cd "${PWD}"

echo
CMD=(yarn)
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(./build-all.sh)
echo + "${CMD[@]}" && "${CMD[@]}"


cd "${BAZEL_WORKSPACE_PATH}"; echo + cd "${PWD}"

readonly MERGE=$(realpath external/bazelbuild-rules-compdb/merge.js)
readonly UNBOX=$(realpath external/bazelbuild-rules-compdb/unbox.js)
readonly C2CDB=$(realpath external/commands_to_compilation_database/`
  `commands_to_compilation_database_py)

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

readonly BOOST_COMPDB_PATH="${COMPDB_TMPD_PATH}/boost-compile_commands.json"

(echo
 readonly BOOST_SRC_PATH="$(cd "external/boost/package" && pwd)"
 readonly BOOST_BUILD_LOG_0="$(realpath "external/boost/build/boost-b2.log")"
 readonly BOOST_BUILD_LOG_1="${COMPDB_TMPD_PATH}/boost-b2.log"
 readonly BOOST_COMPDB_PATH_1="${COMPDB_TMPD_PATH}/`
   `boost-compile_commands_1.json"
 readonly BOOST_COMPDB_CONFIG_PATH="$(realpath unbox-bazel.config.js)"

 CMD=(cp "${BOOST_BUILD_LOG_0}" "${BOOST_BUILD_LOG_1}")
 echo + "${CMD[@]}" && "${CMD[@]}"

 CMD=(chmod "a-x,a+r" "${BOOST_BUILD_LOG_1}")
 echo + "${CMD[@]}" && "${CMD[@]}"

 echo
 CMD=(cat "${BOOST_BUILD_LOG_1}")
 CMD+=('|')
 CMD+=("${C2CDB}")
 CMD+=("--compilers=${CC},${CXX},gcc,g++")
 CMD+=('--build-tool=Boost.Build')
 CMD+=("--root-directory=${BOOST_SRC_PATH}")
 CMD+=("--output-filename=${BOOST_COMPDB_PATH_1}")
 echo + "${CMD[@]}" && eval "${CMD[@]}"

 echo
 CMD=("${UNBOX}")
 CMD+=("${BOOST_COMPDB_PATH}")
 CMD+=("${BOOST_COMPDB_PATH_1}")
 CMD+=("${BAZEL_WORKSPACE_PATH}")
 CMD+=("${BOOST_COMPDB_CONFIG_PATH}")
 echo + "${CMD[@]}" && "${CMD[@]}")

echo
CMD=("${MERGE}")
CMD+=(-o "${COMPDB_TMPD_PATH}/compile_commands.json")
CMD+=("${BOOST_COMPDB_PATH}")
CMD+=("${BAZ_COMPDB_PATH}")
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(cp -vf "${COMPDB_TMPD_PATH}/compile_commands.json" "${PRJ_ROOT_PATH}")
echo + "${CMD[@]}" && "${CMD[@]}"
