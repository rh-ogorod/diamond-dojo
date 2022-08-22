// Hey Emacs, this is -*- coding: utf-8 -*-

#include <codecvt>
#include <iostream>
#include <locale>
#include <range/v3/to_container.hpp>
#include <range/v3/view/transform.hpp>

auto main(int /*argc*/, char* /*argv*/[]) -> int {
  // std::vector<int> numbers{1, 2, 3};

  // auto halved = numbers
  //               // Divide each integer by 2, converting it into a double
  //               | ranges::views::transform(
  //                   [](const int& num) { return num / 2.0; });

  // std::cout << halved << '\n';

  // std::cout << "Hello World!" << std::endl;

  const std::u32string firstIn{U"а"};
  const std::u32string lastIn{U"д"};

  const auto first = lastIn | ranges::views::transform([](auto letter) {
                       return std::toupper(letter);
                     }) |
                     ranges::to<std::u32string>();

  // const auto first{std::toupper(firstIn)};
  // const auto last{std::toupper(lastIn)};

  // std::locale loc(std::locale(), new std::codecvt_utf8<char32_t>);
  // std::cout.imbue(loc);

  std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> conv;

  std::cout << "First letter: " << conv.to_bytes(first)
            << "\n"
            // << "Last letter: " << conv.to_bytes(lastIn) << "\n"
            << std::endl;

  return 0;
}
