// Hey Emacs, this is -*- coding: utf-8 -*-
#ifndef __diamond_unicode_utils_codecvt_hpp__
#define __diamond_unicode_utils_codecvt_hpp__

#include <unicode/uchar.h>

#include <codecvt>
#include <iostream>
#include <locale>
#include <range/v3/to_container.hpp>
#include <range/v3/view/transform.hpp>

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
  std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> conv;
  stream << conv.to_bytes(value.data());
  return stream;
}

inline auto operator<<(std::ostream& stream, const char32_t value)
    -> std::ostream& {
  std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> conv;
  stream << conv.to_bytes(value);
  return stream;
}

#endif // __diamond_unicode_utils_codecvt_hpp__
