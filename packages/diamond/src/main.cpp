// Hey Emacs, this is -*- coding: utf-8 -*-

// https://github.com/ericniebler/range-v3/blob/master/test/action/transform.cpp

// #include "build_diamond_generate.hpp"
// using rh_ogorod::diamond_dojo::buildDiamond;

// #include "build_diamond_transform.hpp"
// using rh_ogorod::diamond_dojo::buildDiamond;

#include "build_diamond_transform_no_if.hpp"
using rh_ogorod::diamond_dojo::buildDiamond;

// #include "unicode_utils_codecvt.hpp"
#include "unicode_utils_icu.hpp"

auto main(int /*argc*/, char* /*argv*/[]) -> int {
  auto diamond = buildDiamond(U'А', U'Ж', U'.');

  for (const auto& line : diamond) {
    std::cout << line << "\n";
  }

  return 0;
}
