module Math {
  /*
  Represents the ratio of the circumference of a circle to its diameter,
  approximately 3.14159.
  */
  const PI = `Math.PI`

  /* Returns the cosine of a number in radians. */
  fun cos (angle : Number) : Number {
    `Math.cos(#{angle})`
  }

  /* Returns the inverse cosine (in radians) of a number. */
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
