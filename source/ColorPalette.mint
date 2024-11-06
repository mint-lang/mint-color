// A shade for an item in a color palette. This consist of a color and a
// readable text color of the color.
type ColorPalette.Shade {
  color : String,
  text : String
}

// A color palette for a color.
type ColorPalette {
  s900 : ColorPalette.Shade,
  s800 : ColorPalette.Shade,
  s700 : ColorPalette.Shade,
  s600 : ColorPalette.Shade,
  s500 : ColorPalette.Shade,
  s400 : ColorPalette.Shade,
  s300 : ColorPalette.Shade,
  s200 : ColorPalette.Shade,
  s100 : ColorPalette.Shade,
  s50 : ColorPalette.Shade,
  saturation : Number,
  lightness : Number,
  hue : Number
}

// Functions for creating a color palette.
module ColorPalette {
  // Returns a `ColorPalette.Shade` from a color, by calulating the
  // readable text color for that color.
  fun shadeFromColor (color : Color) : ColorPalette.Shade {
    {
      text: Color.toCSSRGBA(Color.readableTextColor(color)),
      color: Color.toCSSRGBA(color)
    }
  }

  // Creates a color palette from the given color.
  fun fromColor (
    color : Color,
    background : Color,
    backgroundInverse : Color
  ) : ColorPalette {
    let {hue, saturation, lightness} =
      Color.toHSLATuple(color)

    let s50 =
      Color.mix(background, color, 0.15)

    let s100 =
      Color.mix(background, color, 0.3)

    let s200 =
      Color.mix(background, color, 0.5)

    let s300 =
      Color.mix(background, color, 0.7)

    let s400 =
      Color.mix(background, color, 0.85)

    let s600 =
      Color.mix(backgroundInverse, color, 0.85)

    let s700 =
      Color.mix(backgroundInverse, color, 0.7)

    let s800 =
      Color.mix(backgroundInverse, color, 0.5)

    let s900 =
      Color.mix(backgroundInverse, color, 0.35)

    {
      s900: shadeFromColor(s900),
      s800: shadeFromColor(s800),
      s700: shadeFromColor(s700),
      s600: shadeFromColor(s600),
      s500: shadeFromColor(color),
      s400: shadeFromColor(s400),
      s300: shadeFromColor(s300),
      s200: shadeFromColor(s200),
      s100: shadeFromColor(s100),
      s50: shadeFromColor(s50),
      saturation: saturation,
      lightness: lightness,
      hue: hue
    }
  }
}
