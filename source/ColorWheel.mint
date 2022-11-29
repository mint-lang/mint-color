module ColorWheel {
  fun adjustHue (value : Number) : Number {
    newValue:
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
      Color.setHue(adjustHue(Color.getHue(color) + 180), color)
    ]
  }

  fun splitComplementary (color : Color) : Array(Color) {
    hue:
      Color.getHue(color)

    [
      color,
      Color.setHue(adjustHue(hue + 150), color),
      Color.setHue(adjustHue(hue + 210), color),
      Color.setHue(adjustHue(hue + 15), color)
    ]
  }

  fun analogous (color : Color) : Array(Color) {
    hue:
      Color.getHue(color)

    [
      color,
      Color.setHue(adjustHue(hue + 5), color),
      Color.setHue(adjustHue(hue + 10), color),
      Color.setHue(adjustHue(hue + 15), color),
      Color.setHue(adjustHue(hue + 20), color),
      Color.setHue(adjustHue(hue + 25), color),
      Color.setHue(adjustHue(hue + 30), color)
    ]
  }

  fun triadic (color : Color) : Array(Color) {
    hue:
      Color.getHue(color)

    [
      color,
      Color.setHue(adjustHue(hue + 120), color),
      Color.setHue(adjustHue(hue + 240), color)
    ]
  }

  fun tetradic (color : Color) : Array(Color) {
    hue:
      Color.getHue(color)

    [
      color,
      Color.setHue(adjustHue(hue + 90), color),
      Color.setHue(adjustHue(hue + 180), color),
      Color.setHue(adjustHue(hue + 270), color)
    ]
  }

  fun monochromatic (color : Color) : Array(Color) {
    [
      Color.setValue(100, color),
      Color.setValue(80, color),
      Color.setValue(60, color),
      Color.setValue(40, color),
      Color.setValue(20, color),
      Color.setValue(10, color),
      Color.setValue(0, color)
    ]
  }
}
