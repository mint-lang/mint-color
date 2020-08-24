/*
A shade for an item in a color palette. This consist of a color and a
readable text color of the color.
*/
record ColorPalette.Shade {
  color : String,
  text : String
}

/* A color palette for a color. */
record ColorPalette {
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

/* Functions for creating a color palette. */
module ColorPalette {
  /*
  Returns a `ColorPalette.Shade` from a color, by calulating the
  readable text color for that color.
  */
  fun shadeFromColor (color : Color) : ColorPalette.Shade {
    {
      text = Color.toCSSRGBA(Color.readableTextColor(color)),
      color = Color.toCSSRGBA(color)
    }
  }

  /* Creates a color palette from the given color. */
  fun fromColor (
    color : Color,
    background : Color,
    backgroundInverse : Color
  ) : ColorPalette {
    try {
      {hue, saturation, lightness} =
        Color.toHSLATuple(color)

      s50 =
        Color.mix(0.15, color, background)

      s100 =
        Color.mix(0.3, color, background)

      s200 =
        Color.mix(0.5, color, background)

      s300 =
        Color.mix(0.7, color, background)

      s400 =
        Color.mix(0.85, color, background)

      s600 =
        Color.mix(0.85, color, backgroundInverse)

      s700 =
        Color.mix(0.7, color, backgroundInverse)

      s800 =
        Color.mix(0.5, color, backgroundInverse)

      s900 =
        Color.mix(0.35, color, backgroundInverse)

      {
        s900 = shadeFromColor(s900),
        s800 = shadeFromColor(s800),
        s700 = shadeFromColor(s700),
        s600 = shadeFromColor(s600),
        s500 = shadeFromColor(color),
        s400 = shadeFromColor(s400),
        s300 = shadeFromColor(s300),
        s200 = shadeFromColor(s200),
        s100 = shadeFromColor(s100),
        s50 = shadeFromColor(s50),
        saturation = saturation,
        lightness = lightness,
        hue = hue
      }
    }
  }
}
