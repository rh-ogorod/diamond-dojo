// Hey Emacs, this is -*- coding: utf-8 -*-

/** @type {import("./external/bazelbuild-rules-compdb").UnboxConfig} */

/** @type {UnboxConfig} */
const config = {
  ignorePaths: [RegExp('external/bazel_tools$'), RegExp('external/system$')],
  pathReplacements: [
    {
      predicate: RegExp('^external/hello-another-world(/?.*)'),
      replacement: 'packages/hello-another-world$1',
    },
  ],
};

module.exports = config;
