// Hey Emacs, this is -*- coding: utf-8 -*-

/** @type {import("./external/bazelbuild-rules-compdb").UnboxConfig} */

/** @type {UnboxConfig} */
const config = {
  ignorePaths: [RegExp('external/bazel_tools$'), RegExp('external/system$')],
};

module.exports = config;
