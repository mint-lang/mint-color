module ColorWheel {
  fun adjustHue (value : Number) : Number {
    let newValue =
      if (value < 0) {
        value + Math.ceil(-value / 360) * 360
      } else {
        value
      }

    newValue % 360
  }

  fun complementary (color : Color) : Array(Color) {
    [
      color,
      Color.setHue(color, adjustHue(Color.getHue(color) + 180))
    ]
  }

  fun splitComplementary (color : Color) : Array(Color) {
    let hue =
      Color.getHue(color)

    [
      color,
      Color.setHue(color, adjustHue(hue + 150)),
      Color.setHue(color, adjustHue(hue + 210)),
      Color.setHue(color, adjustHue(hue + 15))
    ]
  }

  fun analogous (color : Color) : Array(Color) {
    let hue =
      Color.getHue(color)

    [
      color,
      Color.setHue(color, adjustHue(hue + 5)),
      Color.setHue(color, adjustHue(hue + 10)),
      Color.setHue(color, adjustHue(hue + 15)),
      Color.setHue(color, adjustHue(hue + 20)),
      Color.setHue(color, adjustHue(hue + 25)),
      Color.setHue(color, adjustHue(hue + 30))
    ]
  }

  fun triadic (color : Color) : Array(Color) {
    let hue =
      Color.getHue(color)

    [
      color,
      Color.setHue(color, adjustHue(hue + 120)),
      Color.setHue(color, adjustHue(hue + 240))
    ]
  }

  fun tetradic (color : Color) : Array(Color) {
    let hue =
      Color.getHue(color)

    [
      color,
      Color.setHue(color, adjustHue(hue + 90)),
      Color.setHue(color, adjustHue(hue + 180)),
      Color.setHue(color, adjustHue(hue + 270))
    ]
  }

  fun monochromatic (color : Color) : Array(Color) {
    [
      Color.setValue(color, 100),
      Color.setValue(color, 80),
      Color.setValue(color, 60),
      Color.setValue(color, 40),
      Color.setValue(color, 20),
      Color.setValue(color, 10),
      Color.setValue(color, 0)
    ]
  }
}
