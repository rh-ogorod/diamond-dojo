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
      u32string empty(lastIndex, fill);
      top.push_back(empty += firstCap + empty);
      continue;
    }

    if (i == lastIndex) {
      top.push_back(lastCap + u32string(lastIndex * 2 - 1, fill) + lastCap);
      continue;
    }

    auto left = u32string(lastIndex - i, fill) + u32string{firstCap + i} +
                u32string(i - 1, fill);
    const auto right = views::reverse(left) | to<u32string>();

    top.push_back(left += fill + right);
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
