// Hey Emacs, this is -*- coding: utf-8 -*-

#include <range/v3/view/concat.hpp>
#include <range/v3/view/reverse.hpp>
#include <range/v3/view/slice.hpp>
#include <string>
#include <vector>

#include "unicode_utils_codecvt.hpp"

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

  const std::size_t lastIndex = last - first;
  const std::size_t length = lastIndex + 1;

  U32strings top;
  top.reserve(length);

  for (auto i = 0; i < length; ++i) {
    if (i == 0) {
      const auto empty = u32string(lastIndex, fill);
      const auto mid = u32string{firstCap};
      top.push_back(views::concat(empty, mid, empty) | to<u32string>());
      continue;
    }

    if (i == lastIndex) {
      const u32string edge{lastCap};
      const u32string mid(lastIndex * 2 - 1, fill);
      top.push_back(views::concat(edge, mid, edge) | to<u32string>());
      continue;
    }

    const auto left = u32string(lastIndex - i, fill) + u32string{firstCap + i} +
                      u32string(i - 1, fill);
    const auto right = views::reverse(left);
    const u32string mid{fill};

    top.push_back(views::concat(left, mid, right) | to<u32string>());
  }

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
