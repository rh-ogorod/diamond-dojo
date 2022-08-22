// Hey Emacs, this is -*- coding: utf-8 -*-

#include <unicode/uchar.h>
#include <unicode/unistr.h>
#include <unicode/ustream.h>

#include <cassert>
#include <iostream>
#include <limits>
#include <locale>
#include <range/v3/to_container.hpp>
#include <range/v3/view/transform.hpp>
#include <string_view>

using icu_66::UnicodeString;

// NOLINTNEXTLINE(misc-unused-using-decls)
using std::operator""sv;

inline auto toUpper(char32_t value) -> char32_t {
  return u_toupper(static_cast<UChar32>(value));
}

auto toUpper(const std::u32string& value) -> std::u32string {
  return value | ranges::views::transform([](auto letter) {
           return toUpper(letter);
         }) |
         ranges::to<std::u32string>();
};

inline auto operator<<(std::ostream& stream, const std::u32string_view& value)
    -> std::ostream& {
  using FromUTF32Arg2 = int32_t;
  const auto valueSize = value.size();

  // NOLINTNEXTLINE(cppcoreguidelines-pro-bounds-array-to-pointer-decay)
  assert(valueSize <= std::numeric_limits<FromUTF32Arg2>::max());

  stream << UnicodeString::fromUTF32(
      // NOLINTNEXTLINE(cppcoreguidelines-pro-type-reinterpret-cast)
      reinterpret_cast<const UChar32*>(value.data()),
      static_cast<FromUTF32Arg2>(valueSize));

  return stream;
}

inline auto operator<<(std::ostream& stream, const char32_t value)
    -> std::ostream& {
  stream << UnicodeString{static_cast<UChar32>(value)};
  return stream;
}

auto main(int /*argc*/, char* /*argv*/[]) -> int {
  const char32_t firstIn{U'а'};
  const char32_t lastIn{U'д'};

  std::cout << "First letter: " << toUpper(firstIn) << "\n"
            << "Last letter: " << toUpper(lastIn) << "\n"
            << std::endl;

  return 0;
}
