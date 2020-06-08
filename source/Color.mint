/* Represents a Color. */
enum Color {
  /* [RGBA Color Representation](https://en.wikipedia.org/wiki/RGBA_color_model) */
  RGBA(Number, Number, Number, Number)

  /* [HSV Color Representation](https://en.wikipedia.org/wiki/HSL_and_HSV) */
  HSVA(Number, Number, Number, Number)

  /* [HEX Color Representation](https://en.wikipedia.org/wiki/Web_colors) */
  HEX(String)
}

/* Functions to create and manipulate colors. */
module Color {
  /*
  Creates a color from a HEY part.

    Color.fromHEX("#FFF")
    Color.fromHEX("#FFFFFF")
    Color.fromHEX("#FFFFFFFF")
  */
  fun fromHEX (value : String) : Maybe(Color) {
    `
    (() => {

      if (/(^#)?[0-9A-F]{3}$/i.test(#{value}) ||
          /(^#)?[0-9A-F]{6}$/i.test(#{value}) ||
          /(^#)?[0-9A-F]{8}$/i.test(#{value})) {
        const normalized = #{value}.replace(/^#/, '');
        let parsed = 'FFFFFFFF';

        if (normalized.length == 3) {
          const [r, g, b] = normalized.split('')

          parsed = r + r + g + g + b + b + 'FF'
        } else if (normalized.length == 6) {
          parsed = normalized + 'FF'
        } else if (normalized.length == 8) {
          parsed = normalized
        }

        return #{Maybe::Just(Color::HEX(`parsed`))}
      } else {
        #{Maybe::Nothing}
      }

    })()
    `
  }

  /*
  Creates a color from red, green, blue and alpha parts.

    Color.fromRGBA(255, 255, 255, 100)
  */
  fun fromRGBA (
    red : Number,
    green : Number,
    blue : Number,
    alpha : Number
  ) : Color {
    Color::RGBA(Math.clamp(0, 255, red), Math.clamp(0, 255, green), Math.clamp(0, 255, blue), Math.clamp(0, 100, alpha))
  }

  /*
  Creates a color from hue, saturation, value and alpha parts.

    Color.fromHSVA(0, 100, 100, 100)
  */
  fun fromHSVA (
    hue : Number,
    saturation : Number,
    value : Number,
    alpha : Number
  ) : Color {
    Color::HSVA(Math.clamp(0, 360, hue), Math.clamp(0, 100, saturation), Math.clamp(0, 100, value), Math.clamp(0, 100, alpha))
  }

  /*
  Sets the saturation to the given value of the given color.

    color =
      Color.fromHSVA(0, 100, 100, 100)

    Color.setSaturation(50, color) == Color.fromHSVA(0, 50, 100, 100)
  */
  fun setSaturation (saturation : Number, color : Color) : Color {
    case (color) {
      Color::HSVA hue oldSaturation value alpha => Color::HSVA(hue, Math.clamp(0, 100, saturation), value, alpha)

      =>
        color
        |> toHSVA
        |> setSaturation(saturation)
    }
  }

  /*
  Sets the value to the given value of the given color.

    color =
      Color.fromHSVA(0, 100, 100, 100)

    Color.setValue(50, color) == Color.fromHSVA(0, 100, 50, 100)
  */
  fun setValue (value : Number, color : Color) : Color {
    case (color) {
      Color::HSVA hue saturation oldValue alpha => Color::HSVA(hue, saturation, Math.clamp(0, 100, value), alpha)

      =>
        color
        |> toHSVA
        |> setValue(value)
    }
  }

  /*
  Converts the given color to the CSS RGBA represenation.

    color =
      Color.fromRGBA(255, 255, 255, 100)

    Color.toCSSRGBA(color) == "rgba(255,255,255,1)"
  */
  fun toCSSRGBA (color : Color) : String {
    case (color) {
      Color::RGBA red green blue alpha => "rgba(#{red}, #{green}, #{blue}, #{alpha / 100})"

      =>
        color
        |> toRGBA
        |> toCSSRGBA
    }
  }

  /*
  Returns the brightness of the given color base on the
  [W3C formula](https://www.w3.org/TR/AERT/#color-contrast)

    Color.getBrightness(Color.fromRGBA(255,255,255,100)) == 1000
    Color.getBrightness(Color.fromRGBA(0,0,0,100)) == 0
  */
  fun getBrightness (color : Color) : Number {
    case (color) {
      Color::RGBA red green blue alpha => Math.round((red * 299 + green * 587 + blue * 114) / 1000)

      =>
        color
        |> toRGBA
        |> getBrightness
    }
  }

  /*
  Returns the readable text color (white or black) based on
  the brightness of the color.

    color =
      Color.fromRGBA(255, 255, 255, 100)

    Color.readableTextColor(color) == Color.fromRGBA(0, 0, 0, 100)
  */
  fun readableTextColor (color : Color) : Color {
    try {
      brightness =
        getBrightness(color)

      if (brightness > 125) {
        Color::RGBA(0, 0, 0, 100)
      } else {
        Color::RGBA(255, 255, 255, 100)
      }
    }
  }

  /*
  Converts the internal represenation of the color to HEX.

    color =
      Color.fromHSVA(0, 100, 100, 100)

    Color.toHEX(color) == Color.fromHEX("#FFFFFFFF")
  */
  fun toHEX (color : Color) : Color {
    case (color) {
      Color::HEX => color
      Color::RGBA red green blue alpha => Color::HEX(`##{red}.toString(16) + #{green}.toString(16) + #{blue}.toString(16) + #{alpha}.toString(16)`)

      Color::HSVA =>
        color
        |> toRGBA
        |> toHEX
    }
  }

  /*
  Converts the internal represenation of the color to RGBA.

    color =
      Color.fromHSVA(0, 100, 100, 100)

    Color.toRGBA(color) == Color.fromRGBA(255, 255, 255, 100)
  */
  fun toRGBA (color : Color) : Color {
    case (color) {
      Color::RGBA => color

      Color::HEX value =>
        `
        (() => {
          const alpha = parseInt(#{value}.slice(6,8), 16) || 100
          const green = parseInt(#{value}.slice(2,4), 16) || 0
          const blue = parseInt(#{value}.slice(4,6), 16) || 0
          const red = parseInt(#{value}.slice(0,2), 16) || 0

          return #{Color::RGBA(`red`, `green`, `blue`, `alpha`)}
        })()
        `

      Color::HSVA hue saturation value alpha =>
        try {
          normalizedSaturation =
            Math.clamp(0, 100, saturation) / 100

          noramlizedValue =
            Math.clamp(0, 100, value) / 100

          normalizedAlpha =
            Math.clamp(0, 100, alpha)

          normalizedHue =
            Math.clamp(0, 360, hue)

          c =
            noramlizedValue * normalizedSaturation

          x =
            c * (1 - Math.abs(Math.fmod(normalizedHue / 60, 2) - 1))

          m =
            noramlizedValue - c

          {red, green, blue} =
            if (0 <= normalizedHue && normalizedHue < 60) {
              {c, x, 0}
            } else if (60 <= normalizedHue && normalizedHue < 120) {
              {x, c, 0}
            } else if (120 <= normalizedHue && normalizedHue < 180) {
              {0, c, x}
            } else if (180 <= normalizedHue && normalizedHue < 240) {
              {0, x, c}
            } else if (240 <= normalizedHue && normalizedHue < 300) {
              {x, 0, c}
            } else {
              {c, 0, x}
            }

          Color::RGBA(Math.ceil((red + m) * 255), Math.ceil((green + m) * 255), Math.ceil((blue + m) * 255), normalizedAlpha)
        }
    }
  }

  /*
  Converts the internal represenation of the color to HSVA.

    color =
      Color.fromRGBA(255, 255, 255, 100)

    Color.toHSVA(color) == Color.fromHSVA(0, 100, 100, 100)
  */
  fun toHSVA (color : Color) : Color {
    case (color) {
      Color::HSVA => color

      Color::HEX =>
        color
        |> toRGBA
        |> toHSVA

      Color::RGBA red green blue alpha =>
        try {
          normalizedRed =
            Math.clamp(0, 255, red) / 255

          normalizedBlue =
            Math.clamp(0, 255, blue) / 255

          normalizedGreen =
            Math.clamp(0, 255, green) / 255

          cMax =
            normalizedRed
            |> Math.max(normalizedBlue)
            |> Math.max(normalizedGreen)

          cMin =
            normalizedRed
            |> Math.min(normalizedBlue)
            |> Math.min(normalizedGreen)

          delta =
            cMax - cMin

          value =
            cMax

          saturation =
            if (cMax == 0) {
              0
            } else {
              delta / cMax
            }

          hue =
            if (delta == 0) {
              0
            } else if (cMax == normalizedRed) {
              60 * Math.fmod((normalizedGreen - normalizedBlue) / delta, 6)
            } else if (cMax == normalizedBlue) {
              60 * ((normalizedRed - normalizedGreen / delta) + 4)
            } else {
              60 * ((normalizedBlue - normalizedRed / delta) + 2)
            }

          Color::HSVA(Math.round(hue), Math.round(saturation * 100), Math.round(value * 100), Math.round(alpha))
        }
    }
  }
}
