// Hey Emacs, this is -*- coding: utf-8 -*-

#include <unicode/uchar.h>
#include <unicode/unistr.h>

#include <codecvt>
#include <iostream>
#include <locale>
#include <range/v3/to_container.hpp>
#include <range/v3/view/transform.hpp>

inline auto toUpper(char32_t value) -> char32_t {
  return u_toupper(static_cast<UChar32>(value));
}

auto toUpper(const std::u32string& value) -> std::u32string {
  return value | ranges::views::transform([](auto letter) {
           return u_toupper(letter);
         }) |
         ranges::to<std::u32string>();
};

inline auto operator<<(std::ostream& stream, const std::u32string& value)
  -> std::ostream& {
  std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> conv;
  stream << conv.to_bytes(value);
  return stream;
}

inline auto operator<<(std::ostream& stream, const char32_t value)
  -> std::ostream& {
  std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> conv;
  stream << conv.to_bytes(value);
  return stream;
}

auto main(int /*argc*/, char* /*argv*/[]) -> int {
  const char32_t firstIn{U'а'};
  const char32_t lastIn{U'д'};

  std::cout << "First letter: " << toUpper(firstIn)
            << "\n"
            // << "Last letter: " << conv.to_bytes(lastIn) << "\n"
            << std::endl;

  return 0;
}
