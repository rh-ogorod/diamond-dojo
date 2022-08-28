#!/bin/bash
# shellcheck disable=SC2219,SC2034

NPROC=$(nproc)

# # Get available RAM in MiB
# MEM=$(($(getconf _PHYS_PAGES) * $(getconf PAGE_SIZE) / (1024 * 1024)))

NPROC_EXT=$(let n=${NPROC}-1; ((n > 0)) && echo $n || echo 1)
export NPROC_EXT

NPROC_BAZ=$(let m=${NPROC}-1; ((m > 0)) && echo $m || echo 1)
# NPROC_BAZ=$(let m=${NPROC}-3; ((m > 0)) && echo $m || echo 1)

# # Cap number of procs used by bazel if mem is less than 32 Gb
# NPROC_BAZ=$(
#   ((MEM > 32100 && NPROC_BAZ > 2)) && echo "${NPROC_BAZ}" || echo 1
# )

export CC=gcc-11
export CXX=g++-11

PRJ_ROOT_PATH="${SDPATH}/.."
readonly PRJ_ROOT_PATH="$(cd "${PRJ_ROOT_PATH}" && pwd)"

readonly NRAM_BAZ='HOST_RAM*.9'

# for Bazel memory usage
# see https://docs.bazel.build/versions/master/memory-saving-mode.html#:~:text=Running%20Bazel%20with%20limited%20RAM&text=You%20can%20set%20the%20maximum,doesn't%20have%20enough%20memory.

# BAZEL_BUILD_CMD=('--host_jvm_args=-Xmx120g')
BAZEL_BUILD_CMD=(build)
# see https://github.com/bazelbuild/bazel/issues/4008 for --host_action_env
# BAZEL_BUILD_CMD+=("--host_action_env=NPROC_EXT=${NPROC_EXT}")
BAZEL_BUILD_CMD+=("--action_env=NPROC_EXT=${NPROC_EXT}")
BAZEL_BUILD_CMD+=("--action_env=CC=${CC}")
BAZEL_BUILD_CMD+=("--action_env=CXX=${CXX}")
# BAZEL_BUILD_CMD+=("--local_cpu_resources=${NPROC_BAZ}")
# BAZEL_BUILD_CMD+=("--local_ram_resources=${NRAM_BAZ}")
BAZEL_BUILD_CMD+=(--experimental_local_memory_estimate)
BAZEL_BUILD_CMD+=(--subcommands)

# BAZEL_RUN_CMD=('--host_jvm_args=-Xmx120g')
BAZEL_RUN_CMD=(run)
BAZEL_RUN_CMD+=("--action_env=NPROC_EXT=${NPROC_EXT}")
BAZEL_RUN_CMD+=("--action_env=CC=${CC}")
BAZEL_RUN_CMD+=("--action_env=CXX=${CXX}")
# BAZEL_RUN_CMD+=("--local_cpu_resources=${NPROC_BAZ}")
# BAZEL_RUN_CMD+=("--local_ram_resources=${NRAM_BAZ}")
BAZEL_RUN_CMD+=(--experimental_local_memory_estimate)
BAZEL_RUN_CMD+=(--subcommands)

BAZEL_DEBUG_CMD=()
# BAZEL_DEBUG_CMD+=('--verbose_failures')
# BAZEL_DEBUG_CMD+=('--sandbox_debug')

BAZEL_TERM_CMD=('--color=yes')
BAZEL_TERM_CMD+=('--curses=yes')
