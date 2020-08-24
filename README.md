# mint-color
![CI](https://github.com/mint-lang/mint-color/workflows/CI/badge.svg?branch=master)

Create and manipulate colors in Mint.

## Installation

Add this to your application's `mint.json`:

```json
"dependencies": {
  "mint-color": {
    "repository": "https://github.com/mint-lang/mint-color",
    "constraint": "1.0.0 <= v < 0.0.0"
  }
}
```

## Usage

This package adds the `Color` enum and module with functions to manipulate it.

```mint
white = 
  Color.fromHEX("FFFFFFFF")

black =
  Color.fromHEX("000000FF")

gray = 
  Color.mix(0.5, white, black)
```

## Contributing

1. Fork it ( https://github.com/mint-lang/mint-color/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
