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

  const auto length = last - first + 1;

  const auto indices = views::iota(0) | views::take(length);
  const auto lines = views::transform(indices, [&](char32_t idx) {
    const std::array slices{
        u32string(length - idx - 1, fill),
        u32string{first + idx},
        u32string(idx, fill)};

    const auto left = slices | views::join;
    auto right = left | views::reverse | views::drop(1);

    return views::concat(left, right) | to<u32string>();
  });

  const auto top = lines | views::take(length);
  const auto bottom = top | views::slice(0, end - 1) | views::reverse;
  return views::concat(top, bottom) | to<U32strings>();
}

} // namespace rh_ogorod::diamond_dojo

#endif // __diamond_build_diamond_transform_hpp__
