// Hey Emacs, this is -*- coding: utf-8 -*-
#ifndef __diamond_build_diamond_transform_hpp__
#define __diamond_build_diamond_transform_hpp__

#include <range/v3/view.hpp>
#include <range/v3/view/join.hpp>
#include <string>
#include <vector>

namespace rh_ogorod::diamond_dojo {

[[nodiscard]] inline auto
buildDiamond(char32_t first, char32_t last, char32_t fill)
    -> std::vector<std::u32string> {
  using U32strings = decltype(buildDiamond(first, last, fill));
  namespace views = ranges::views;

  if (first > last) {
    std::swap(first, last);
  }

  const auto length = last - first + 1;

  auto lines = views::transform(views::iota(0), [&](char32_t idx) {
    const std::array slices{
        std::u32string(length - idx - 1, fill),
        std::u32string{first + idx},
        std::u32string(idx, fill)};

    auto left = slices | views::join;

    auto right = left | views::reverse | views::drop(1);

    return views::concat(left, right) | ranges::to<std::u32string>();
  });

  auto top = lines | views::take(length);
  auto bottom = top | views::reverse | views::drop(1);
  return views::concat(top, bottom) | ranges::to<U32strings>();
}

} // namespace rh_ogorod::diamond_dojo

#endif // __diamond_build_diamond_transform_hpp__
