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
    let tests =
      [
        {Color::RGBA(255, 255, 255, 100), Color::HSIA(0, 0, 100, 100)},
        {Color::RGBA(128, 128, 128, 100), Color::HSIA(0, 0, 50, 100)},
        {Color::RGBA(0, 0, 0, 100), Color::HSIA(0, 0, 0, 100)},
        {Color::RGBA(252, 0, 0, 100), Color::HSIA(0, 100, 33, 100)},
        {Color::RGBA(191, 191, 0, 100), Color::HSIA(60, 100, 50, 100)},
        {Color::RGBA(0, 122, 0, 100), Color::HSIA(120, 100, 16, 100)},
        {Color::RGBA(127, 254, 254, 100), Color::HSIA(180, 40, 83, 100)},
        {Color::RGBA(126, 126, 252, 100), Color::HSIA(240, 25, 66, 100)},
        {Color::RGBA(190, 64, 190, 100), Color::HSIA(300, 57, 58, 100)},
        {Color::RGBA(161, 163, 36, 100), Color::HSIA(61, 70, 47, 100)}
      ]

    let expected =
      for item of tests {
        item[1]
      }

    let expected1 =
      for item of tests {
        item[0]
      }

    let actual =
      for item of tests {
        Color.toHSIA(item[0])
      }

    let actual1 =
      for item of tests {
        Color.toRGBA(item[1])
      }

    actual == expected &&
      actual1 == expected1
  }
}
