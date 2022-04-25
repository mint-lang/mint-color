module Math {
  const PI = `Math.PI`

  fun cos (angle : Number) : Number {
    `Math.cos(#{angle})`
  }

  fun acos (angle : Number) : Number {
    `Math.acos(#{angle})`
  }

  /*
  Returns the value of a number rounded to the nearest integer.

    Math.roundTo(0.7523, 2) == 0.75
  */
  fun roundTo (number : Number, decimals : Number) : Number {
    `Math.round(#{number} * (10 * #{decimals})) / (10 * #{decimals})`
  }
}
