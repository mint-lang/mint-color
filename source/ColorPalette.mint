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
  shadow : String
}

/* Functions for creating a color palette. */
module ColorPalette {
  /* Creates a color palette from the given color. */
  fun fromColor (color : Color) : ColorPalette {
    try {
      s50 =
        Color.mix(0.15, color, Color::HEX("FFFFFFFF"))

      s100 =
        Color.mix(0.3, color, Color::HEX("FFFFFFFF"))

      s200 =
        Color.mix(0.5, color, Color::HEX("FFFFFFFF"))

      s300 =
        Color.mix(0.7, color, Color::HEX("FFFFFFFF"))

      s400 =
        Color.mix(0.85, color, Color::HEX("FFFFFFFF"))

      s600 =
        Color.mix(0.85, color, Color::HEX("000000FF"))

      s700 =
        Color.mix(0.7, color, Color::HEX("000000FF"))

      s800 =
        Color.mix(0.5, color, Color::HEX("000000FF"))

      s900 =
        Color.mix(0.35, color, Color::HEX("000000FF"))

      {
        s900 =
          {
            text = Color.toCSSRGBA(Color.readableTextColor(s900)),
            color = Color.toCSSRGBA(s900)
          },
        s800 =
          {
            text = Color.toCSSRGBA(Color.readableTextColor(s800)),
            color = Color.toCSSRGBA(s800)
          },
        s700 =
          {
            text = Color.toCSSRGBA(Color.readableTextColor(s700)),
            color = Color.toCSSRGBA(s700)
          },
        s600 =
          {
            text = Color.toCSSRGBA(Color.readableTextColor(s600)),
            color = Color.toCSSRGBA(s600)
          },
        s500 =
          {
            text = Color.toCSSRGBA(Color.readableTextColor(color)),
            color = Color.toCSSRGBA(color)
          },
        s400 =
          {
            text = Color.toCSSRGBA(Color.readableTextColor(s400)),
            color = Color.toCSSRGBA(s400)
          },
        s300 =
          {
            text = Color.toCSSRGBA(Color.readableTextColor(s300)),
            color = Color.toCSSRGBA(s300)
          },
        s200 =
          {
            text = Color.toCSSRGBA(Color.readableTextColor(s200)),
            color = Color.toCSSRGBA(s200)
          },
        s100 =
          {
            text = Color.toCSSRGBA(Color.readableTextColor(s100)),
            color = Color.toCSSRGBA(s100)
          },
        s50 =
          {
            text = Color.toCSSRGBA(Color.readableTextColor(s50)),
            color = Color.toCSSRGBA(s50)
          },
        shadow = Color.toCSSRGBA(Color.setAlpha(25, color))
      }
    }
  }
}
