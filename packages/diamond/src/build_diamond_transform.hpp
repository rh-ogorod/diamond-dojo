// Hey Emacs, this is -*- coding: utf-8 -*-
#ifndef __diamond_build_diamond_transform_hpp__
#define __diamond_build_diamond_transform_hpp__

#include <range/v3/view.hpp>
#include <string>
#include <vector>

namespace rh_ogorod::diamond_dojo {

using std::u32string;
using std::vector;

using ranges::end;
using ranges::to;

namespace views = ranges::views;

[[nodiscard]] inline auto
buildDiamond(char32_t first, char32_t last, char32_t fill)
    -> vector<u32string> {
  using U32strings = decltype(buildDiamond(first, last, fill));

  if (first > last) {
    std::swap(first, last);
  }

  const auto lastIndex = last - first;
  const auto length = lastIndex + 1;

  auto indices = views::iota(0) | views::take(length);
  auto lines = views::transform(indices, [&](char32_t idx) {
    if (idx == 0) {
      const auto side = u32string(lastIndex, fill);
      const std::array slices{side, u32string{first}, side};
      return slices | views::join | to<u32string>();
    }

    if (idx == lastIndex) {
      const u32string side{last};
      const std::array slices{side, u32string(lastIndex * 2 - 1, fill), side};
      return slices | views::join | to<u32string>();
    }

    const std::array slices{
        u32string(lastIndex - idx, fill),
        u32string{first + idx},
        u32string(idx - 1, fill)};

    auto left = slices | views::join;
    auto right = left | views::reverse;
    const u32string mid{fill};

    return views::concat(left, mid, right) | to<u32string>();
  });

  auto top = lines | views::take(length) | to<U32strings>();
  auto bottom = top | views::slice(0, end - 1) | views::reverse;
  return views::concat(top, bottom) | to<U32strings>();
}

} // namespace rh_ogorod::diamond_dojo

#endif // __diamond_build_diamond_transform_hpp__
