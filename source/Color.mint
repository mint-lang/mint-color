/* Represents a Color. */
enum Color {
  /* [RGBA Color Representation](https://en.wikipedia.org/wiki/RGBA_color_model) */
  RGBA(Number, Number, Number, Number)

  /* [HSV Color Representation](https://en.wikipedia.org/wiki/HSL_and_HSV) */
  HSVA(Number, Number, Number, Number)

  /* [HSL Color Representation](https://en.wikipedia.org/wiki/HSL_and_HSV) */
  HSLA(Number, Number, Number, Number)

  /* [HEX Color Representation](https://en.wikipedia.org/wiki/Web_colors) */
  HEX(String)
}

/* Functions to create and manipulate colors. */
module Color {
  const HEX_REGEXP = Regexp.create("^[0-9A-Fa-f]+$")

  /*
  Creates a color from a HEX string.

    Color.fromHEX("#FFF")
    Color.fromHEX("#FFFFFF")
    Color.fromHEX("#FFFFFFFF")
  */
  fun fromHEX (value : String) : Maybe(Color) {
    try {
      normalized =
        value
        |> String.replace("#", "")
        |> String.toUpperCase()

      if (Regexp.match(normalized, HEX_REGEXP)) {
        case (String.size(normalized)) {
          3 =>
            try {
              splitted =
                String.split("", normalized)

              red =
                Maybe.withDefault("", splitted[0])

              green =
                Maybe.withDefault("", splitted[1])

              blue =
                Maybe.withDefault("", splitted[2])

              Maybe::Just(Color::HEX("#{red}#{red}#{green}#{green}#{blue}#{blue}FF"))
            }

          6 => Maybe::Just(Color::HEX(normalized + "FF"))
          8 => Maybe::Just(Color::HEX(normalized))
          => Maybe::Nothing
        }
      } else {
        Maybe::Nothing
      }
    }
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
    Color::RGBA(
      Math.clamp(0, 255, red),
      Math.clamp(0, 255, green),
      Math.clamp(0, 255, blue),
      Math.clamp(0, 100, alpha))
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
    Color::HSVA(
      Math.clamp(0, 360, hue),
      Math.clamp(0, 100, saturation),
      Math.clamp(0, 100, value),
      Math.clamp(0, 100, alpha))
  }

  /*
  Sets the saturation to the given value of the given color.

    color =
      Color.fromHSVA(0, 100, 100, 100)

    Color.setSaturation(50, color) == Color.fromHSVA(0, 50, 100, 100)
  */
  fun setSaturation (saturation : Number, color : Color) : Color {
    case (color) {
      Color::HSVA(hue, oldSaturation, value, alpha) =>
        Color::HSVA(hue, Math.clamp(0, 100, saturation), value, alpha)

      =>
        color
        |> toHSVA
        |> setSaturation(saturation)
    }
  }

  /*
  Sets the hue to the given value of the given color.

    color =
      Color.fromHSVA(0, 100, 100, 100)

    Color.setHue(50, color) == Color.fromHSVA(50, 100, 100, 100)
  */
  fun setHue (hue : Number, color : Color) : Color {
    case (color) {
      Color::HSVA(oldHue, saturation, value, alpha) =>
        Color::HSVA(Math.clamp(0, hue, 360), saturation, value, alpha)

      =>
        color
        |> toHSVA
        |> setHue(hue)
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
      Color::HSVA(hue, saturation, oldValue, alpha) =>
        Color::HSVA(hue, saturation, Math.clamp(0, 100, value), alpha)

      =>
        color
        |> toHSVA
        |> setValue(value)
    }
  }

  /*
  Sets the alpha to the given value of the given color.

    color =
      Color.fromHSVA(0, 100, 100, 100)

    Color.setAlpha(50, color) == Color.fromHSVA(0, 100, 100, 50)
  */
  fun setAlpha (alpha : Number, color : Color) : Color {
    case (color) {
      Color::HSVA(hue, staturation, value, oldAlpha) =>
        Color::HSVA(hue, staturation, value, Math.clamp(0, 100, alpha))

      =>
        color
        |> toHSVA
        |> setAlpha(alpha)
    }
  }

  /*
  Sets the lightness to the given value of the given color.

    color =
      Color.fromHSLA(0, 100, 100, 100)

    Color.setLightness(50, color) == Color.fromHSLA(0, 100, 50, 100)
  */
  fun setLightness (lightness : Number, color : Color) : Color {
    case (color) {
      Color::HSLA(hue, saturation, oldLightness, alpha) =>
        Color::HSLA(hue, saturation, Math.clamp(0, 100, lightness), alpha)

      =>
        color
        |> toHSLA
        |> setValue(lightness)
    }
  }

  /*
  Makes the color lighter using the given ratio.

    color =
      Color.fromHSLA(0, 100, 10, 100)

    Color.lighten(10, color) == Color.fromHSLA(0, 100, 100, 100)
  */
  fun lighten (ratio : Number, color : Color) : Color {
    case (color) {
      Color::HSLA(hue, saturation, lightness, alpha) =>
        try {
          newLightness =
            Math.clamp(0, 100, lightness + lightness * ratio)

          Color::HSLA(hue, saturation, newLightness, alpha)
        }

      =>
        color
        |> toHSLA
        |> lighten(ratio)
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
      Color::RGBA(red, green, blue, alpha) =>
        "rgba(#{red}, #{green}, #{blue}, #{alpha / 100})"

      =>
        color
        |> toRGBA
        |> toCSSRGBA
    }
  }

  /*
  Converts the given color to the CSS HEX represenation.

    color =
      Color.fromHex("#FFF")

    Color.toCSSHex(color) == "#FFFFFFFF"
  */
  fun toCSSHex (color : Color) : String {
    case (color) {
      Color::HEX(value) => "##{value}"

      =>
        color
        |> toHEX
        |> toCSSHex
    }
  }

  /*
  Returns the alpha value of the color.

    Color.getAlpha(Color.fromHSVA(0,100,100,50)) == 50
  */
  fun getAlpha (color : Color) : Number {
    case (color) {
      Color::HSVA(red, green, blue, alpha) =>
        alpha

      =>
        color
        |> toHSVA
        |> getAlpha
    }
  }

  /*
  Returns the hue of the color.

    Color.getHue(Color.fromHSVA(0,100,100,50)) == 0
  */
  fun getHue (color : Color) : Number {
    case (color) {
      Color::HSVA(hue) =>
        hue

      =>
        color
        |> toHSVA
        |> getHue
    }
  }

  /*
  Returns the saturation of the color.

    Color.getSaturation(Color.fromHSVA(0,100,100,50)) == 100
  */
  fun getSaturation (color : Color) : Number {
    case (color) {
      Color::HSVA(hue, saturation) =>
        saturation

      =>
        color
        |> toHSVA
        |> getSaturation
    }
  }

  /*
  Returns the value of the color.

    Color.getValue(Color.fromHSVA(0,100,100,50)) == 100
  */
  fun getValue (color : Color) : Number {
    case (color) {
      Color::HSVA(hue, saturation, value) =>
        value

      =>
        color
        |> toHSVA
        |> getValue
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
      Color::RGBA(red, green, blue, alpha) =>
        Math.round((red * 299 + green * 587 + blue * 114) / 1000)

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
        mix(0.1, color, Color::RGBA(0, 0, 0, 100))
      } else {
        mix(0.05, color, Color::RGBA(255, 255, 255, 100))
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
      Color::RGBA(red, green, blue, alpha) =>
        try {
          redPart =
            `#{red}.toString(16).padStart(2,'0')`

          greenPart =
            `#{green}.toString(16).padStart(2,'0')`

          bluePart =
            `#{blue}.toString(16).padStart(2,'0')`

          alphaPart =
            `#{Math.round(alpha * 2.55)}.toString(16).padStart(2,'0')`

          Color::HEX(String.toUpperCase("#{redPart}#{greenPart}#{bluePart}#{alphaPart}"))
        }

      Color::HEX => color

      =>
        color
        |> toRGBA
        |> toHEX
    }
  }

  /*
  Returns the given color as an RGBA tuple.

    color =
      Color.fromRGBA(255, 255, 255, 100)

    Color.toRGBATuple(color) == {255,255,255,100}
  */
  fun toRGBATuple (color : Color) : Tuple(Number, Number, Number, Number) {
    case (color) {
      Color::RGBA(red, green, blue, alpha) =>
        {red, green, blue, alpha}

      =>
        color
        |> toRGBA
        |> toRGBATuple
    }
  }

  /*
  Returns the given color as a HSLA tuple.

    color =
      Color.fromRGBA(255, 255, 255, 100)

    Color.toHSLATuple(color) == {255,255,255,100}
  */
  fun toHSLATuple (color : Color) : Tuple(Number, Number, Number, Number) {
    case (color) {
      Color::HSLA(hue, saturation, lightness, alpha) =>
        {hue, saturation, lightness, alpha}

      =>
        color
        |> toHSLA
        |> toHSLATuple
    }
  }

  /*
  Mixes two given colors using the given weight (0-1).

    color1 =
      Color.fromRGBA(255, 255, 255, 100)

    color2 =
      Color.fromRGBA(0, 0, 0, 100)

    Color.mix(0.5, color1, color2) == Color.fromRGBA(128, 128, 128, 100)
  */
  fun mix (weight : Number, color1 : Color, color2 : Color) : Color {
    try {
      {red1, green1, blue1, alpha1} =
        Color.toRGBATuple(color1)

      {red2, green2, blue2, alpha2} =
        Color.toRGBATuple(color2)

      a =
        alpha1 - alpha2

      w =
        2 * weight - 1

      wt =
        if (w * a == -1) {
          w
        } else {
          (w + a) / (1 + w * a)
        }

      w1 =
        (wt + 1) / 2.0

      w2 =
        1 - w1

      red =
        w1 * red1 + w2 * red2

      green =
        w1 * green1 + w2 * green2

      blue =
        w1 * blue1 + w2 * blue2

      alpha =
        alpha1 * weight + alpha2 * (1 - weight)

      Color::RGBA(red, green, blue, alpha)
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

      Color::HEX(value) =>
        `
        (() => {
          const alpha = parseInt(#{value}.slice(6,8), 16) || 255
          const green = parseInt(#{value}.slice(2,4), 16) || 0
          const blue = parseInt(#{value}.slice(4,6), 16) || 0
          const red = parseInt(#{value}.slice(0,2), 16) || 0
          return #{Color::RGBA(`red`, `green`, `blue`, `alpha / 255 * 100`)}
        })()
        `

      Color::HSLA(hue, saturation, lightness, alpha) =>
        try {
          normalizedSaturation =
            Math.clamp(0, 100, saturation) / 100

          normalizedLightness =
            Math.clamp(0, 100, lightness) / 100

          normalizedAlpha =
            Math.clamp(0, 100, alpha)

          normalizedHue =
            Math.clamp(0, 360, hue)

          c =
            (1 - Math.abs(2 * normalizedLightness - 1)) * normalizedSaturation

          x =
            c * (1 - Math.abs(Math.fmod(normalizedHue / 60, 2) - 1))

          m =
            normalizedLightness - c / 2

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

          Color::RGBA(
            Math.ceil((red + m) * 255),
            Math.ceil((green + m) * 255),
            Math.ceil((blue + m) * 255),
            normalizedAlpha)
        }

      Color::HSVA(hue, saturation, value, alpha) =>
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

          Color::RGBA(
            Math.ceil((red + m) * 255),
            Math.ceil((green + m) * 255),
            Math.ceil((blue + m) * 255),
            normalizedAlpha)
        }
    }
  }

  /*
  Converts the internal represenation of the color to HSLA.

    color =
      Color.fromRGBA(255, 255, 255, 100)

    Color.toHSLA(color) == Color.fromHSLA(0, 100, 100, 100)
  */
  fun toHSLA (color : Color) : Color {
    case (color) {
      Color::RGBA(red, green, blue, alpha) =>
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

          lightness =
            (cMax + cMin) / 2

          saturation =
            if (delta == 0) {
              0
            } else {
              1 - Math.abs(2 * lightness - 1)
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

          Color::HSLA(
            Math.round(hue),
            Math.round(saturation * 100),
            Math.round(lightness * 100),
            Math.round(alpha))
        }

      Color::HSLA => color

      =>
        color
        |> toRGBA
        |> toHSLA
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
      Color::RGBA(red, green, blue, alpha) =>
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

          Color::HSVA(
            Math.round(hue),
            Math.round(saturation * 100),
            Math.round(value * 100),
            Math.round(alpha))
        }

      Color::HSVA => color

      =>
        color
        |> toRGBA
        |> toHSVA
    }
  }
}
