suite "Color.toHSVA" {
  test "converts black correctly" {
    (Color.fromRGBA(0, 0, 0, 0)
    |> Color.toHSVA()) == Color::HSVA(0, 0, 0, 0)
  }

  test "converts white correctly" {
    (Color.fromRGBA(255, 255, 255, 0)
    |> Color.toHSVA()) == Color::HSVA(0, 0, 100, 0)
  }

  test "converts red correctly" {
    (Color.fromRGBA(255, 0, 0, 0)
    |> Color.toHSVA()) == Color::HSVA(0, 100, 100, 0)
  }

  test "converts green correctly" {
    (Color.fromRGBA(0, 255, 0, 0)
    |> Color.toHSVA()) == Color::HSVA(120, 100, 100, 0)
  }

  test "converts blue correctly" {
    (Color.fromRGBA(0, 0, 255, 0)
    |> Color.toHSVA()) == Color::HSVA(240, 100, 100, 0)
  }

  test "converts cyan correctly" {
    (Color.fromRGBA(0, 255, 255, 0)
    |> Color.toHSVA()) == Color::HSVA(180, 100, 100, 0)
  }

  test "converts silver correctly" {
    (Color.fromRGBA(192, 192, 192, 0)
    |> Color.toHSVA()) == Color::HSVA(0, 0, 75, 0)
  }

  test "converts gray correctly" {
    (Color.fromRGBA(128, 128, 128, 0)
    |> Color.toHSVA()) == Color::HSVA(0, 0, 50, 0)
  }

  test "converts maroon correctly" {
    (Color.fromRGBA(128, 0, 0, 0)
    |> Color.toHSVA()) == Color::HSVA(0, 100, 50, 0)
  }

  test "converts olive correctly" {
    (Color.fromRGBA(128, 128, 0, 0)
    |> Color.toHSVA()) == Color::HSVA(60, 100, 50, 0)
  }

  test "converts dark green correctly" {
    (Color.fromRGBA(0, 128, 0, 0)
    |> Color.toHSVA()) == Color::HSVA(120, 100, 50, 0)
  }

  test "converts purple correctly" {
    (Color.fromRGBA(128, 0, 128, 0)
    |> Color.toHSVA()) == Color::HSVA(300, 100, 50, 0)
  }

  test "converts teal correctly" {
    (Color.fromRGBA(0, 128, 128, 0)
    |> Color.toHSVA()) == Color::HSVA(180, 100, 50, 0)
  }

  test "converts navy correctly" {
    (Color.fromRGBA(0, 0, 128, 0)
    |> Color.toHSVA()) == Color::HSVA(240, 100, 50, 0)
  }
}

suite "Color.toRGBA" {
  test "converts black correctly" {
    (Color.fromHSVA(0, 0, 0, 0)
    |> Color.toRGBA()) == Color::RGBA(0, 0, 0, 0)
  }

  test "converts white correctly" {
    (Color.fromHSVA(0, 0, 100, 0)
    |> Color.toRGBA()) == Color::RGBA(255, 255, 255, 0)
  }

  test "converts red correctly" {
    (Color.fromHSVA(0, 100, 100, 0)
    |> Color.toRGBA()) == Color::RGBA(255, 0, 0, 0)
  }

  test "converts green correctly" {
    (Color.fromHSVA(120, 100, 100, 0)
    |> Color.toRGBA()) == Color::RGBA(0, 255, 0, 0)
  }

  test "converts blue correctly" {
    (Color.fromHSVA(240, 100, 100, 0)
    |> Color.toRGBA()) == Color::RGBA(0, 0, 255, 0)
  }

  test "converts yelllow correctly" {
    (Color.fromHSVA(60, 100, 100, 0)
    |> Color.toRGBA()) == Color::RGBA(255, 255, 0, 0)
  }

  test "converts cyan correctly" {
    (Color.fromHSVA(180, 100, 100, 0)
    |> Color.toRGBA()) == Color::RGBA(0, 255, 255, 0)
  }

  test "converts magenta correctly" {
    (Color.fromHSVA(300, 100, 100, 0)
    |> Color.toRGBA()) == Color::RGBA(255, 0, 255, 0)
  }

  test "converts silver correctly" {
    (Color.fromHSVA(0, 0, 75, 0)
    |> Color.toRGBA()) == Color::RGBA(192, 192, 192, 0)
  }

  test "converts gray correctly" {
    (Color.fromHSVA(0, 0, 50, 0)
    |> Color.toRGBA()) == Color::RGBA(128, 128, 128, 0)
  }

  test "converts maroon correctly" {
    (Color.fromHSVA(0, 100, 50, 0)
    |> Color.toRGBA()) == Color::RGBA(128, 0, 0, 0)
  }

  test "converts olive correctly" {
    (Color.fromHSVA(60, 100, 50, 0)
    |> Color.toRGBA()) == Color::RGBA(128, 128, 0, 0)
  }

  test "converts dark green correctly" {
    (Color.fromHSVA(120, 100, 50, 0)
    |> Color.toRGBA()) == Color::RGBA(0, 128, 0, 0)
  }

  test "converts purple correctly" {
    (Color.fromHSVA(300, 100, 50, 0)
    |> Color.toRGBA()) == Color::RGBA(128, 0, 128, 0)
  }

  test "converts teal correctly" {
    (Color.fromHSVA(180, 100, 50, 0)
    |> Color.toRGBA()) == Color::RGBA(0, 128, 128, 0)
  }

  test "converts navy correctly" {
    (Color.fromHSVA(240, 100, 50, 0)
    |> Color.toRGBA()) == Color::RGBA(0, 0, 128, 0)
  }
}

suite "Color.fromHSVA" {
  test "returns a new color" {
    Color.fromHSVA(0, 0, 0, 0) == Color::HSVA(0, 0, 0, 0)
  }

  test "clamps colors to lower value" {
    Color.fromHSVA(-10, -10, -10, -10) == Color::HSVA(0, 0, 0, 0)
  }

  test "clamps colors to upper value" {
    Color.fromHSVA(1000, 1000, 1000, 1000) == Color::HSVA(360, 100, 100, 100)
  }
}

suite "Color.fromRGBA" {
  test "returns a new color" {
    Color.fromRGBA(0, 0, 0, 0) == Color::RGBA(0, 0, 0, 0)
  }

  test "clamps colors to lower value" {
    Color.fromRGBA(-10, -10, -10, -10) == Color::RGBA(0, 0, 0, 0)
  }

  test "clamps colors to upper value" {
    Color.fromRGBA(1000, 1000, 1000, 1000) == Color::RGBA(255, 255, 255, 100)
  }
}

suite "Color.fromHEX" {
  test "handles 3 character colors (all same)" {
    Color.fromHEX("#000") == Maybe::Just(Color::HEX("000000FF"))
  }

  test "handles 3 character colors (all different)" {
    Color.fromHEX("#FCD") == Maybe::Just(Color::HEX("FFCCDDFF"))
  }

  test "handles 6 character colors" {
    Color.fromHEX("#00FFCC") == Maybe::Just(Color::HEX("00FFCCFF"))
  }

  test "handles 8 character colors" {
    Color.fromHEX("#00FFCCDD") == Maybe::Just(Color::HEX("00FFCCDD"))
  }

  test "handles 3 character colors without hashtag" {
    Color.fromHEX("000") == Maybe::Just(Color::HEX("000000FF"))
  }

  test "handles 6 character colors without hashtag" {
    Color.fromHEX("00FFCC") == Maybe::Just(Color::HEX("00FFCCFF"))
  }

  test "handles 8 character colors without hashtag" {
    Color.fromHEX("00FFCCDD") == Maybe::Just(Color::HEX("00FFCCDD"))
  }

  test "handles 8 character colors lowercase" {
    Color.fromHEX("#00ffccdd") == Maybe::Just(Color::HEX("00FFCCDD"))
  }

  test "returns nothing for invalid input" {
    Color.fromHEX("#00f!ccdd") == Maybe::Nothing
  }
}

suite "Color.readableTextColor" {
  test "returns white for black" {
    (Color.fromRGBA(0, 0, 0, 100)
    |> Color.readableTextColor()) == Color::RGBA(242.25, 242.25, 242.25, 100)
  }
}

suite "Color.toHSIA" {
  test "it converts correctly" {
    try {
      tests =
        [
          {Color::RGBA(255, 255, 255, 100), Color::HSIA(0, 0, 100, 100)},
          {Color::RGBA(127.5, 127.5, 127.5, 100), Color::HSIA(0, 0, 50, 100)},
          {Color::RGBA(0, 0, 0, 100), Color::HSIA(0, 0, 0, 100)},
          {Color::RGBA(255, 0, 0, 100), Color::HSIA(0, 100, 33, 100)},
          {Color::RGBA(191.25, 191.25, 0, 100), Color::HSIA(60, 100, 50, 100)},
          {Color::RGBA(0, 127.5, 0, 100), Color::HSIA(120, 100, 17, 100)},
          {Color::RGBA(127.5, 255, 255, 100), Color::HSIA(180, 40, 83, 100)},
          {Color::RGBA(127.5, 127.5, 255, 100), Color::HSIA(240, 25, 67, 100)},
          {Color::RGBA(191.25, 63.75, 191.25, 100), Color::HSIA(300, 57, 58, 100)}
        ]

      expected =
        for (item of tests) {
          item[0]
        }

      actual =
        for (item of tests) {
          Color.toRGBA(Color.toHSIA(item[0]))
        }

      `console.log(#{actual}, #{expected})`
      actual == expected
    }
  }
}

/*
Color::RGBA(62.8%, 64.3%,  14.2%, 100)   61.8°   61.5°   50.1%   49.4%   64.3%   39.3%   47.1%   58.1%   77.9%   63.8%   69.9%
          Color::RGBA(25.5%, 10.4%,  91.8%, 100)   251.1°  250°  81.4%   75%   91.8%   51.1%   42.6%   24.2%   88.7%   83.2%   75.6%
          Color::RGBA(11.6%, 67.5%,  25.5%, 100)   134.9°  133.8°  55.9%   50.4%   67.5%   39.6%   34.9%   46%   82.8%   70.7%   66.7%
          Color::RGBA(94.1%, 78.5%,  5.3%, 100)  49.5°   50.5°   88.8%   82.1%   94.1%   49.8%   59.3%   74.8%   94.4%   89.3%   91.1%
          Color::RGBA(70.4%, 18.7%,  89.7%, 100)   283.7°  284.8°  71%   63.6%   89.7%   54.3%   59.6%   42.3%   79.2%   77.5%   68.6%
          Color::RGBA(93.1%, 46.3%,  31.6%, 100)   14.3°   13.2°   61.5%   55.6%   93.1%   62.4%   57%   58.6%   66.1%   81.7%   44.6%
          Color::RGBA(99.8%, 97.4%,  53.2%, 100)   56.9°   57.4°   46.6%   45.4%   99.8%   76.5%   83.5%   93.1%   46.7%   99.1%   36.3%
          Color::RGBA(9.9%, 79.5%,  59.1%, 100)   162.4°  163.4°  69.6%   62%   79.5%   44.7%   49.5%   56.4%   87.5%   77.9%   80%
          Color::RGBA(21.1%, 14.9%,  59.7%, 100)   248.3°  247.3°  44.8%   42%   59.7%   37.3%   31.9%   21.9%   75%   60.1%   53.3%
          Color::RGBA(49.5%, 49.3%,  72.1%, 100)   240.5°  240.4°  22.8%   22.7%   72.1%   60.8%   57%   52%   31.6%   29%   13.5%
*/
