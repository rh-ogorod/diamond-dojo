// Hey Emacs, this is -*- coding: utf-8 -*-
#ifndef __diamond_unicode_utils_icu_hpp__
#define __diamond_unicode_utils_icu_hpp__

#include <unicode/uchar.h>
#include <unicode/unistr.h>
#include <unicode/ustream.h>

#include <boost/type_traits.hpp>
#include <cassert>
#include <iostream>
#include <limits>
#include <locale>
#include <range/v3/to_container.hpp>
#include <range/v3/view/transform.hpp>
#include <string_view>

inline auto toUpper(char32_t value) -> char32_t {
  return u_toupper(static_cast<UChar32>(value));
}

inline auto toUpper(const std::u32string& value) -> std::u32string {
  return value | ranges::views::transform([](auto letter) {
           return toUpper(letter);
         }) |
         ranges::to<std::u32string>();
};

inline auto operator<<(std::ostream& stream, const std::u32string_view& value)
    -> std::ostream& {
  // using FromUTF32Arg2 = int32_t;
  using FromUTF32Arg2 = boost::function_traits<
      decltype(icu_66::UnicodeString::fromUTF32)>::arg2_type;
  const auto valueSize = value.size();

  // NOLINTNEXTLINE(cppcoreguidelines-pro-bounds-array-to-pointer-decay)
  assert(valueSize <= std::numeric_limits<FromUTF32Arg2>::max());

  stream << icu_66::UnicodeString::fromUTF32(
      // NOLINTNEXTLINE(cppcoreguidelines-pro-type-reinterpret-cast)
      reinterpret_cast<const UChar32*>(value.data()),
      static_cast<FromUTF32Arg2>(valueSize));

  return stream;
}

inline auto operator<<(std::ostream& stream, const char32_t value)
    -> std::ostream& {
  stream << icu_66::UnicodeString{static_cast<UChar32>(value)};
  return stream;
}

#endif // __diamond_unicode_utils_icu_hpp__
