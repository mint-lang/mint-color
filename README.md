# mint-color
![CI](https://github.com/mint-lang/mint-color/workflows/CI/badge.svg?branch=master)

Create and manipulate colors in Mint.

## Installation

Add this to your application's `mint.json`:

```json
"dependencies": {
  "mint-color": {
    "repository": "https://github.com/mint-lang/mint-color",
    "constraint": "1.0.0 <= v < 2.0.0"
  }
}
```

## Example Usage

This package adds the `Color` enum and module with functions to manipulate it.

```mint
white =
  Color.fromHEX("FFFFFFFF")

black =
  Color.fromHEX("000000FF")

gray =
  Color.mix(0.5, white, black)
```

## Implementation Details

The implementation is using an `enum` to represent a color. Current there are four color spaces that are supported as internal representation:

- HSVA
- HSLA
- RGBA
- HEXA

A color is created with one of the `fromXXX` functions, which will set their implementation accordingly:

```
Color.fromHEX("FFFFFFFF") == Color::HEX("FFFFFFFF")
```

Different functions will convert (when needed) the internal representation into a different color space, for example getting the `hue` of a `HEX` or `RGBA` color will convert it to `HSVA` first and return it's `hue`:

```
Color.getHue(Color.fromHEX("#FF0000")) == 0
```

This allows seamless manipulation of any color without more complexity (such as multiple types for each color space).

## Contributing

1. Fork it ( https://github.com/mint-lang/mint-color/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
