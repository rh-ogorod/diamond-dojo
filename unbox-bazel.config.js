// Hey Emacs, this is -*- coding: utf-8 -*-

/** @type {import("./external/bazelbuild-rules-compdb").UnboxConfig} */

/** @type {UnboxConfig} */
const config = {
  ignorePaths: [RegExp('external/bazel_tools$'), RegExp('external/system$')],
  pathReplacements: [
    {
      predicate: RegExp('^bazel-out/.+?/bin/external/range-v3(/?.*)'),
      replacement: 'external/range-v3$1',
    },
    {
      predicate: RegExp('^bazel-out/.+?/bin/external/boost$'),
      replacement: 'external/boost/package',
    },
  ],
};

module.exports = config;
