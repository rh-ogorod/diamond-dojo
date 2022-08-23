// Hey Emacs, this is -*- coding: utf-8 -*-

#include <range/v3/range/access.hpp>
#include <range/v3/range/conversion.hpp>
#include <range/v3/view/concat.hpp>
#include <range/v3/view/generate.hpp>
#include <range/v3/view/join.hpp>
#include <range/v3/view/reverse.hpp>
#include <range/v3/view/slice.hpp>
#include <range/v3/view/take.hpp>
#include <string>
#include <vector>

// #include "unicode_utils_codecvt.hpp"
#include "unicode_utils_icu.hpp"

// NOLINTNEXTLINE(misc-unused-using-decls)
using std::operator""sv;
using std::u32string;
using std::vector;

using ranges::end;
using ranges::to;
namespace views = ranges::views;

[[nodiscard]] auto buildDiamond(char32_t first, char32_t last, char32_t fill)
    -> vector<u32string> {
  using U32strings = decltype(buildDiamond(first, last, fill));

  if (first > last) {
    std::swap(first, last);
  }

  const auto firstCap = toUpper(first);
  const auto lastCap = toUpper(last);

  const auto lastIndex = last - first;
  const auto length = lastIndex + 1;

  auto gen = views::generate([&, idx = 0]() mutable {
    if (idx == 0) {
      const auto edge = u32string(lastIndex, fill);
      const auto mid = u32string{firstCap};
      return views::concat(edge, mid, edge) | to<u32string>();
    }

    if (idx == lastIndex) {
      const u32string edge{lastCap};
      const u32string mid(lastIndex * 2 - 1, fill);
      return views::concat(edge, mid, edge) | to<u32string>();
    }

    const std::array slices{
        u32string(lastIndex - idx, fill),
        u32string{firstCap + idx},
        u32string(idx - 1, fill)};

    const auto left = slices | views::join;
    const auto right = left | views::reverse;
    const u32string mid{fill};

    return views::concat(left, mid, right) | to<u32string>();
  });

  const auto top = gen | views::take(length) | to<U32strings>();
  const auto bottom = top | views::slice(0, end - 1) | views::reverse;
  return views::concat(top, bottom) | to<U32strings>();
}

auto main(int /*argc*/, char* /*argv*/[]) -> int {
  auto diamond = buildDiamond(U'а', U'ж', U'.');

  for (const auto& line : diamond) {
    std::cout << line << "\n";
  }

  return 0;
}
