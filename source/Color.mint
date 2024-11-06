// Represents a Color.
type Color {
  // [RGBA Color Representation](https://en.wikipedia.org/wiki/RGBA_color_model)
  RGBA(Number, Number, Number, Number)

  // [HSV Color Representation](https://en.wikipedia.org/wiki/HSL_and_HSV)
  HSVA(Number, Number, Number, Number)

  // [HSL Color Representation](https://en.wikipedia.org/wiki/HSL_and_HSV)
  HSLA(Number, Number, Number, Number)

  // [HSI Color Representation](https://en.wikipedia.org/wiki/HSL_and_HSV)
  HSIA(Number, Number, Number, Number)

  // [HEX Color Representation](https://en.wikipedia.org/wiki/Web_colors)
  HEX(String)
}

// Functions to create and manipulate colors.
module Color {
  // A regexp to detect HEX color values.
  const HEX_REGEXP = Regexp.create("^[0-9A-Fa-f]+$")

  // Generates a color from a string.
  fun colorOfString (value : String) : String {
    `
    (() => {
      let h, s, l;

      const opts = {
        sat: [50, 100],
        hue: [0, 360],
        lit: [40, 75]
      };

      const range = function(hash, min, max) {
        const diff = max - min;
        const x = ((hash % diff) + diff) % diff;
        return x + min;
      }

      let hash = 0;

      if (#{value}.length === 0) return hash;

      for (var i = 0; i < #{value}.length; i++) {
        hash = #{value}.charCodeAt(i) + ((hash << 5) - hash);
        hash = hash & hash;
      }

      h = range(hash, opts.hue[0], opts.hue[1]);
      s = range(hash, opts.sat[0], opts.sat[1]);
      l = range(hash, opts.lit[0], opts.lit[1]);

      return \`hsl(${h}, ${s}%, ${l}%)\`;
    })()
    ` as String
  }

  // Calculates the color contrast ratio between two colors (1 to 21).
  // https://www.w3.org/TR/2008/REC-WCAG20-20081211/#visual-audio-contrast-contrast
  fun contrastRatio (background : Color, text : Color) : Number {
    let color1 =
      Color.relativeLuminance(text)

    let color2 =
      Color.relativeLuminance(background)

    let ratio =
      if color1 > color2 {
        (color1 + 0.05) / (color2 + 0.05)
      } else {
        (color2 + 0.05) / (color1 + 0.05)
      }

    Math.round(ratio * 100) / 100
  }

  // Creates a color from a HEX string.
  //
  //   Color.fromHEX("#FFF")
  //   Color.fromHEX("#FFFFFF")
  //   Color.fromHEX("#FFFFFFFF")
  fun fromHEX (value : String) : Maybe(Color) {
    let normalized =
      value
      |> String.replace("#", "")
      |> String.toUpperCase()

    if Regexp.match(HEX_REGEXP, normalized) {
      case String.size(normalized) {
        3 =>
          {
            let splitted =
              String.split(normalized, "")

            let red =
              splitted[0] or ""

            let green =
              splitted[1] or ""

            let blue =
              splitted[2] or ""

            Maybe.Just(
              Color.HEX("#{red}#{red}#{green}#{green}#{blue}#{blue}FF"))
          }

        6 => Maybe.Just(Color.HEX(normalized + "FF"))
        8 => Maybe.Just(Color.HEX(normalized))
        => Maybe.Nothing
      }
    }
  }

  // Creates a color from hue, saturation, value and alpha parts.
  //
  //   Color.fromHSVA(0, 100, 100, 100)
  fun fromHSVA (
    hue : Number,
    saturation : Number,
    value : Number,
    alpha : Number
  ) : Color {
    Color.HSVA(Math.clamp(hue, 0, 360), Math.clamp(saturation, 0, 100),
      Math.clamp(value, 0, 100), Math.clamp(alpha, 0, 100))
  }

  // Creates a color from red, green, blue and alpha parts.
  //
  //   Color.fromRGBA(255, 255, 255, 100)
  fun fromRGBA (
    red : Number,
    green : Number,
    blue : Number,
    alpha : Number
  ) : Color {
    Color.RGBA(Math.clamp(red, 0, 255), Math.clamp(green, 0, 255),
      Math.clamp(blue, 0, 255), Math.clamp(alpha, 0, 100))
  }

  // Returns the alpha value of the color.
  //
  //   Color.getAlpha(Color.fromHSVA(0,100,100,50)) == 50
  fun getAlpha (color : Color) : Number {
    if let HSVA(red, green, blue, alpha) = color {
      alpha
    } else {
      getAlpha(toHSVA(color))
    }
  }

  // Returns the brightness of the given color base on the
  // [W3C formula](https://www.w3.org/TR/AERT/#color-contrast).
  //
  //   Color.getBrightness(Color.fromRGBA(255,255,255,100)) == 1000
  //   Color.getBrightness(Color.fromRGBA(0,0,0,100)) == 0
  fun getBrightness (color : Color) : Number {
    if let RGBA(red, green, blue, alpha) = color {
      Math.round((red * 299 + green * 587 + blue * 114) / 1000)
    } else {
      getBrightness(toRGBA(color))
    }
  }

  // Returns the hue of the color.
  //
  //   Color.getHue(Color.fromHSVA(0,100,100,50)) == 0
  fun getHue (color : Color) : Number {
    if let HSVA(hue) = color {
      hue
    } else {
      getHue(toHSVA(color))
    }
  }

  // Returns the saturation of the color.
  //
  //   Color.getSaturation(Color.fromHSVA(0,100,100,50)) == 100
  fun getSaturation (color : Color) : Number {
    case color {
      HSVA(hue, saturation) => saturation

      =>
        color
        |> toHSVA
        |> getSaturation
    }
  }

  // Returns the value of the color.
  //
  //    Color.getValue(Color.fromHSVA(0,100,100,50)) == 100
  fun getValue (color : Color) : Number {
    if let HSVA(hue, saturation, value) = color {
      value
    } else {
      getValue(toHSVA(color))
    }
  }

  // Makes the color lighter using the given ratio.
  //
  //   color =
  //     Color.fromHSLA(0, 100, 10, 100)
  //
  //   Color.lighten(color, 10) == Color.fromHSLA(0, 100, 100, 100)
  fun lighten (color : Color, ratio : Number) : Color {
    if let Color.HSLA(hue, saturation, lightness, alpha) = color {
      let newLightness =
        Math.clamp(lightness + lightness * ratio, 0, 100)

      Color.HSLA(hue, saturation, newLightness, alpha)
    } else {
      lighten(toHSLA(color), ratio)
    }
  }

  // Mixes two given colors using the given weight (0..1).
  //
  //   color1 =
  //     Color.fromRGBA(255, 255, 255, 100)
  //
  //   color2 =
  //     Color.fromRGBA(0, 0, 0, 100)
  //
  //   Color.mix(color1, color2, 0.5) == Color.fromRGBA(128, 128, 128, 100)
  fun mix (color1 : Color, color2 : Color, weight : Number) : Color {
    {
      let {red1, green1, blue1, alpha1} =
        Color.toRGBATuple(color2)

      let {red2, green2, blue2, alpha2} =
        Color.toRGBATuple(color1)

      let a =
        alpha1 - alpha2

      let w =
        2 * weight - 1

      let wt =
        if w * a == -1 {
          w
        } else {
          (w + a) / (1 + w * a)
        }

      let w1 =
        (wt + 1) / 2.0

      let w2 =
        1 - w1

      let green =
        w1 * green1 + w2 * green2

      let blue =
        w1 * blue1 + w2 * blue2

      let red =
        w1 * red1 + w2 * red2

      let alpha =
        alpha1 * weight + alpha2 * (1 - weight)

      Color.RGBA(red, green, blue, alpha)
    }
  }

  // Generates a random color.
  fun random : Color {
    `
    (() => {
      const letters = '0123456789ABCDEF';
      let color = '#';

      for (let i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
      }

      return #{Color.fromHEX(`color`) or Color::HEX("000000")};
    })()
    `
  }

  // Returns the readable text color (white or black) based on
  // the brightness of the color.
  //
  //   color =
  //     Color.fromRGBA(255, 255, 255, 100)
  //
  //   Color.readableTextColor(color) == Color.fromRGBA(0, 0, 0, 100)
  fun readableTextColor (color : Color) : Color {
    let brightness =
      getBrightness(color)

    if brightness > 125 {
      mix(Color.RGBA(0, 0, 0, 100), color, 0.1)
    } else {
      mix(Color.RGBA(255, 255, 255, 100), color, 0.05)
    }
  }

  // Calculates the relative luminance of a color.
  // https://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef
  fun relativeLuminance (color : Color) : Number {
    let item =
      Color.toRGBATuple(color)

    let normalize =
      (value : Number) {
        if value <= 0.03928 {
          value / 12.92
        } else {
          `Math.pow((#{value} + 0.055) / 1.055, 2.4)`
        }
      }

    let r =
      normalize(item[0] / 255)

    let g =
      normalize(item[1] / 255)

    let b =
      normalize(item[2] / 255)

    0.2126 * r + 0.7152 * g + 0.0722 * b
  }

  // Sets the alpha to the given value of the given color.
  //
  //   color =
  //     Color.fromHSVA(0, 100, 100, 100)
  //
  //   Color.setAlpha(color, 50) == Color.fromHSVA(0, 100, 100, 50)
  fun setAlpha (color : Color, alpha : Number) : Color {
    if let HSVA(hue, staturation, value, oldAlpha) = color {
      Color.HSVA(hue, staturation, value, Math.round(Math.clamp(alpha, 0, 100)))
    } else {
      setAlpha(toHSVA(color), alpha)
    }
  }

  // Sets the hue to the given value of the given color.
  //
  //   color =
  //     Color.fromHSVA(0, 100, 100, 100)
  //
  //   Color.setHue(color, 50) == Color.fromHSVA(50, 100, 100, 100)
  fun setHue (color : Color, hue : Number) : Color {
    if let HSVA(oldHue, saturation, value, alpha) = color {
      Color.HSVA(Math.round(Math.clamp(hue, 0, 360)), saturation, value, alpha)
    } else {
      setHue(toHSVA(color), hue)
    }
  }

  // Sets the lightness to the given value of the given color.
  //
  //   color =
  //     Color.fromHSLA(0, 100, 100, 100)
  //
  //   Color.setLightness(50, color) == Color.fromHSLA(0, 100, 50, 100)
  fun setLightness (color : Color, lightness : Number) : Color {
    if let HSLA(hue, saturation, oldLightness, alpha) = color {
      Color.HSLA(hue, saturation, Math.round(Math.clamp(lightness, 0, 100)),
        alpha)
    } else {
      setValue(toHSLA(color), lightness)
    }
  }

  // Sets the saturation to the given value of the given color.
  //
  //   color =
  //     Color.fromHSVA(0, 100, 100, 100)
  //
  //   Color.setSaturation(50, color) == Color.fromHSVA(0, 50, 100, 100)
  fun setSaturation (color : Color, saturation : Number) : Color {
    if let HSVA(hue, oldSaturation, value, alpha) = color {
      Color.HSVA(hue, Math.round(Math.clamp(saturation, 0, 100)), value, alpha)
    } else {
      setSaturation(toHSVA(color), saturation)
    }
  }

  // Sets the value to the given value of the given color.
  //
  //  color =
  //    Color.fromHSVA(0, 100, 100, 100)
  //
  //  Color.setValue(50, color) == Color.fromHSVA(0, 100, 50, 100)
  fun setValue (color : Color, value : Number) : Color {
    if let HSVA(hue, saturation, oldValue, alpha) = color {
      Color.HSVA(hue, saturation, Math.round(Math.clamp(value, 0, 100)), alpha)
    } else {
      setValue(toHSVA(color), value)
    }
  }

  // Returns the CSS HSLA representation of the color.
  fun toCSSHSLA (color : Color) : String {
    if let HSLA(hue, saturation, lightness, alpha) = color {
      "hsla(#{hue}, #{saturation}%, #{lightness}%, #{Math.round(alpha / 100)})"
    } else {
      toCSSHSLA(toHSLA(color))
    }
  }

  // Converts the given color to the CSS HEX representation.
  //
  //   color =
  //     Color.fromHex("#FFF")
  //
  //   Color.toCSSHex(color) == "#FFFFFFFF"
  fun toCSSHex (color : Color) : String {
    if let HEX(value) = color {
      "##{value}"
    } else {
      toCSSHex(toHEX(color))
    }
  }

  // Converts the given color to the CSS RGBA representation.
  //
  //   color =
  //     Color.fromRGBA(255, 255, 255, 100)
  //
  //   Color.toCSSRGBA(color) == "rgba(255,255,255,1)"
  fun toCSSRGBA (color : Color) : String {
    if let RGBA(red, green, blue, alpha) = color {
      "rgba(#{red}, #{green}, #{blue}, #{alpha / 100})"
    } else {
      toCSSRGBA(toRGBA(color))
    }
  }

  // Returns the CSS Percent RGBA representation of the color.
  fun toCSSRGBAPercent (color : Color) : String {
    let {red, green, blue, alpha} =
      toRGBAPercentTuple(color)

    "rgba(#{red}%, #{green}%, #{blue}%, #{alpha}%)"
  }

  // Converts the internal representation of the color to HEX.
  //
  //  color =
  //    Color.fromHSVA(0, 100, 100, 100)
  //
  //  Color.toHEX(color) == Color.fromHEX("#FFFFFFFF")
  fun toHEX (color : Color) : Color {
    case color {
      RGBA(red, green, blue, alpha) =>
        {
          let redPart =
            `#{Math.round(red)}.toString(16).padStart(2,'0')`

          let greenPart =
            `#{Math.round(green)}.toString(16).padStart(2,'0')`

          let bluePart =
            `#{Math.round(blue)}.toString(16).padStart(2,'0')`

          let alphaPart =
            `#{Math.round(alpha * 2.55)}.toString(16).padStart(2,'0')`

          Color.HEX(
            String.toUpperCase("#{redPart}#{greenPart}#{bluePart}#{alphaPart}"))
        }

      HEX => color
      => toHEX(toRGBA(color))
    }
  }

  // Converts the internal representation of the color to HSIA.
  //
  //   color =
  //     Color.fromRGBA(255, 255, 255, 100)
  //
  //   Color.toHSIA(color) == Color.fromHSVA(0, 100, 100, 100)
  fun toHSIA (color : Color) : Color {
    case color {
      RGBA(red, green, blue, alpha) =>
        {
          let normalizedRed =
            Math.clamp(red, 0, 255) / 255

          let normalizedBlue =
            Math.clamp(blue, 0, 255) / 255

          let normalizedGreen =
            Math.clamp(green, 0, 255) / 255

          let intensity =
            (normalizedRed + normalizedGreen + normalizedBlue) / 3

          if normalizedRed == normalizedGreen && normalizedGreen == normalizedBlue {
            Color.HSIA(Math.round(0), Math.round(0),
              Math.round(intensity * 100), Math.round(alpha))
          } else {
            let w =
              (normalizedRed - normalizedGreen + normalizedRed - normalizedBlue) / Math.sqrt(
                (normalizedRed - normalizedGreen) * (normalizedRed - normalizedGreen) + (normalizedRed - normalizedBlue) * (normalizedGreen - normalizedBlue)) / 2

            let hueBase =
              Math.acos(w) * 180 / Math.PI

            let hue =
              if normalizedBlue > normalizedGreen {
                360 - hueBase
              } else {
                hueBase
              }

            let saturation =
              if intensity == 0 {
                0
              } else {
                1 - ((Array.min(
                  [normalizedRed, normalizedGreen, normalizedBlue]) or 0) / intensity)
              }

            Color.HSIA(Math.round(hue), Math.round(saturation * 100),
              Math.round(intensity * 100), Math.round(alpha))
          }
        }

      HSIA => color
      => toHSIA(toRGBA(color))
    }
  }

  // Converts the internal representation of the color to HSLA.
  //
  //   color =
  //     Color.fromRGBA(255, 255, 255, 100)
  //
  //   Color.toHSLA(color) == Color.fromHSLA(0, 100, 100, 100)
  fun toHSLA (color : Color) : Color {
    case color {
      RGBA(red, green, blue, alpha) =>
        {
          let normalizedRed =
            Math.clamp(red, 0, 255) / 255

          let normalizedBlue =
            Math.clamp(blue, 0, 255) / 255

          let normalizedGreen =
            Math.clamp(green, 0, 255) / 255

          let cMax =
            normalizedRed
            |> Math.max(normalizedBlue)
            |> Math.max(normalizedGreen)

          let cMin =
            normalizedRed
            |> Math.min(normalizedBlue)
            |> Math.min(normalizedGreen)

          let delta =
            cMax - cMin

          let lightness =
            (cMax + cMin) / 2

          let saturation =
            if delta == 0 {
              0
            } else {
              1 - Math.abs(2 * lightness - 1)
            }

          let hue =
            if delta == 0 {
              0
            } else if cMax == normalizedRed {
              60 * Math.fmod(6, (normalizedGreen - normalizedBlue) / delta)
            } else if cMax == normalizedBlue {
              60 * ((normalizedRed - normalizedGreen / delta) + 4)
            } else {
              60 * ((normalizedBlue - normalizedRed / delta) + 2)
            }

          Color.HSLA(Math.round(hue), Math.round(saturation * 100),
            Math.round(lightness * 100), Math.round(alpha))
        }

      HSLA => color
      => toHSLA(toRGBA(color))
    }
  }

  // Returns the given color as a HSLA tuple.
  //
  //  color =
  //    Color.fromRGBA(255, 255, 255, 100)
  //
  //  Color.toHSLATuple(color) == {255,255,255,100}
  fun toHSLATuple (color : Color) : Tuple(Number, Number, Number, Number) {
    if let HSLA(hue, saturation, lightness, alpha) = color {
      {hue, saturation, lightness, alpha}
    } else {
      toHSLATuple(toHSLA(color))
    }
  }

  // Converts the internal representation of the color to HSVA.
  //
  //   color =
  //     Color.fromRGBA(255, 255, 255, 100)
  //
  //   Color.toHSVA(color) == Color.fromHSVA(0, 100, 100, 100)
  fun toHSVA (color : Color) : Color {
    case color {
      RGBA(red, green, blue, alpha) =>
        {
          let normalizedRed =
            Math.clamp(red, 0, 255) / 255

          let normalizedBlue =
            Math.clamp(blue, 0, 255) / 255

          let normalizedGreen =
            Math.clamp(green, 0, 255) / 255

          let cMax =
            normalizedRed
            |> Math.max(normalizedBlue)
            |> Math.max(normalizedGreen)

          let cMin =
            normalizedRed
            |> Math.min(normalizedBlue)
            |> Math.min(normalizedGreen)

          let delta =
            cMax - cMin

          let value =
            cMax

          let saturation =
            if cMax == 0 {
              0
            } else {
              delta / cMax
            }

          let hue =
            if delta == 0 {
              0
            } else if cMax == normalizedRed {
              60 * Math.fmod(6, (normalizedGreen - normalizedBlue) / delta)
            } else if cMax == normalizedBlue {
              60 * ((normalizedRed - normalizedGreen / delta) + 4)
            } else {
              60 * ((normalizedBlue - normalizedRed / delta) + 2)
            }

          Color.HSVA(Math.round(hue), Math.round(saturation * 100),
            Math.round(value * 100), Math.round(alpha))
        }

      HSVA => color
      => toHSVA(toRGBA(color))
    }
  }

  // Converts the internal representation of the color to RGBA.
  //
  //   color =
  //     Color.fromHSVA(0, 100, 100, 100)
  //
  //   Color.toRGBA(color) == Color.fromRGBA(255, 255, 255, 100)
  fun toRGBA (color : Color) : Color {
    case color {
      RGBA => color

      HEX(value) =>
        `
        (() => {
          const alpha = parseInt(#{value}.slice(6,8), 16) || 255
          const green = parseInt(#{value}.slice(2,4), 16) || 0
          const blue = parseInt(#{value}.slice(4,6), 16) || 0
          const red = parseInt(#{value}.slice(0,2), 16) || 0
          return #{Color::RGBA(`red`, `green`, `blue`, `alpha / 255 * 100`)}
        })()
        `

      HSIA(hue, saturation, intensity, alpha) =>
        {
          let normalizedSaturation =
            Math.clamp(saturation, 0, 100) / 100

          let normalizedIntensity =
            Math.clamp(intensity, 0, 100) / 100

          let normalizedAlpha =
            Math.clamp(alpha, 0, 100)

          let normalizedHue =
            Math.clamp(hue, 0, 360)

          let hTag =
            normalizedHue / 60

          let z =
            1 - Math.abs(Math.fmod(2, hTag) - 1)

          let c =
            (3 * normalizedIntensity * normalizedSaturation) / (1 + z)

          let x =
            c * z

          let m =
            normalizedIntensity * (1 - normalizedSaturation)

          let {red, green, blue} =
            if 0 <= hTag && hTag <= 1 {
              ({c, x, 0})
            } else if 1 < hTag && hTag <= 2 {
              ({x, c, 0})
            } else if 2 < hTag && hTag <= 3 {
              ({0, c, x})
            } else if 3 < hTag && hTag <= 4 {
              ({0, x, c})
            } else if 4 < hTag && hTag <= 5 {
              ({x, 0, c})
            } else if 5 < hTag && hTag <= 6 {
              ({c, 0, x})
            } else {
              ({0, 0, 0})
            }

          Color.RGBA(Math.round((red + m) * 255),
            Math.round((green + m) * 255), Math.round((blue + m) * 255),
              normalizedAlpha)
        }

      HSLA(hue, saturation, lightness, alpha) =>
        {
          let normalizedSaturation =
            Math.clamp(saturation, 0, 100) / 100

          let normalizedLightness =
            Math.clamp(lightness, 0, 100) / 100

          let normalizedAlpha =
            Math.clamp(alpha, 0, 100)

          let normalizedHue =
            Math.clamp(hue, 0, 360)

          let c =
            (1 - Math.abs(2 * normalizedLightness - 1)) * normalizedSaturation

          let x =
            c * (1 - Math.abs(Math.fmod(2, normalizedHue / 60) - 1))

          let m =
            normalizedLightness - c / 2

          let {red, green, blue} =
            if 0 <= normalizedHue && normalizedHue < 60 {
              ({c, x, 0})
            } else if 60 <= normalizedHue && normalizedHue < 120 {
              ({x, c, 0})
            } else if 120 <= normalizedHue && normalizedHue < 180 {
              ({0, c, x})
            } else if 180 <= normalizedHue && normalizedHue < 240 {
              ({0, x, c})
            } else if 240 <= normalizedHue && normalizedHue < 300 {
              ({x, 0, c})
            } else {
              ({c, 0, x})
            }

          Color.RGBA(Math.ceil((red + m) * 255), Math.ceil((green + m) * 255),
            Math.ceil((blue + m) * 255), normalizedAlpha)
        }

      HSVA(hue, saturation, value, alpha) =>
        {
          let normalizedSaturation =
            Math.clamp(saturation, 0, 100) / 100

          let noramlizedValue =
            Math.clamp(value, 0, 100) / 100

          let normalizedAlpha =
            Math.clamp(alpha, 0, 100)

          let normalizedHue =
            Math.clamp(hue, 0, 360)

          let c =
            noramlizedValue * normalizedSaturation

          let x =
            c * (1 - Math.abs(Math.fmod(2, normalizedHue / 60) - 1))

          let m =
            noramlizedValue - c

          let {red, green, blue} =
            if 0 <= normalizedHue && normalizedHue < 60 {
              ({c, x, 0})
            } else if 60 <= normalizedHue && normalizedHue < 120 {
              ({x, c, 0})
            } else if 120 <= normalizedHue && normalizedHue < 180 {
              ({0, c, x})
            } else if 180 <= normalizedHue && normalizedHue < 240 {
              ({0, x, c})
            } else if 240 <= normalizedHue && normalizedHue < 300 {
              ({x, 0, c})
            } else {
              ({c, 0, x})
            }

          Color.RGBA(Math.ceil((red + m) * 255), Math.ceil((green + m) * 255),
            Math.ceil((blue + m) * 255), normalizedAlpha)
        }
    }
  }

  // Returns the the color as an Percent RGBA tuple (0..1).
  fun toRGBAPercentTuple (color : Color) : Tuple(Number, Number, Number, Number) {
    if let RGBA(red, green, blue, alpha) = color {
      {
        Math.round((red / 255) * 100),
        Math.round((green / 255) * 100),
        Math.round((blue / 255) * 100),
        alpha
      }
    } else {
      toRGBAPercentTuple(toRGBA(color))
    }
  }

  // Returns the given color as an RGBA tuple.
  //
  //  color =
  //    Color.fromRGBA(255, 255, 255, 100)
  //
  //  Color.toRGBATuple(color) == {255,255,255,100}
  fun toRGBATuple (color : Color) : Tuple(Number, Number, Number, Number) {
    if let Color.RGBA(red, green, blue, alpha) = color {
      {red, green, blue, alpha}
    } else {
      toRGBATuple(toRGBA(color))
    }
  }
}
