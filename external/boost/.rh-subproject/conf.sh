#!/bin/bash
# shellcheck disable=SC2219,SC2034

readonly SRC_BRANCH=@rh-ogorod/boost-1.80.0

readonly NPROC=$(let m=$(nproc)-1; ((m > 0)) && echo $m || echo 1)

PRJ_PATH="${SDPATH}"
readonly PRJ_PATH="$(cd "${PRJ_PATH}" && pwd)"

PRJ_ROOT_PATH="${SDPATH}/.."
readonly PRJ_ROOT_PATH="$(cd "${PRJ_ROOT_PATH}" && pwd)"

readonly BLD_PATH="${PRJ_ROOT_PATH}/build"
readonly SRC_PATH="${PRJ_ROOT_PATH}/package"
readonly DST_PATH="${PRJ_ROOT_PATH}/dist"

# BOOST_BUILD_CMD=(headers)
# BOOST_BUILD_CMD+=(stage)
BOOST_BUILD_CMD+=(install)
BOOST_BUILD_CMD+=(-d+2 -q)
BOOST_BUILD_CMD+=("-j${NPROC}")
BOOST_BUILD_CMD+=("--prefix=${DST_PATH}")
# BOOST_BUILD_CMD+=("--prefix=/usr/local/stow/${STOW_NAME}")
# BOOST_BUILD_CMD+=("--build-type=complete")
BOOST_BUILD_CMD+=("--build-dir=${BLD_PATH}")
BOOST_BUILD_CMD+=("--layout=versioned")
# BOOST_BUILD_CMD+=(toolset=gcc-11~c++17)
BOOST_BUILD_CMD+=("toolset=gcc-11~c++20")
BOOST_BUILD_CMD+=("variant=release")
BOOST_BUILD_CMD+=("threading=multi")
BOOST_BUILD_CMD+=("link=static,shared")
# BOOST_BUILD_CMD+=("link=shared")
# BOOST_BUILD_CMD+=("link=static")
# BOOST_BUILD_CMD+=("runtime-link=static")
BOOST_BUILD_CMD+=("--with-headers")
