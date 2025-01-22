# Sai

[![Sai Version](https://img.shields.io/gem/v/sai?style=for-the-badge&logo=rubygems&logoColor=white&logoSize=auto&label=Gem%20Version)](https://rubygems.org/gems/sai)
[![Sai Codacy grade](https://img.shields.io/codacy/grade/0f9a91b573ed4768a773867b95ed4894/main?style=for-the-badge&logo=codacy&logoColor=white&logoSize=auto)](https://app.codacy.com/gh/aaronmallen/sai)
[![Sai Codacy coverage](https://img.shields.io/codacy/coverage/0f9a91b573ed4768a773867b95ed4894/main?style=for-the-badge&logo=codacy&logoColor=white&logoSize=auto)](https://app.codacy.com/gh/aaronmallen/sai/coverage)
[![Sai License](https://img.shields.io/github/license/aaronmallen/sai?style=for-the-badge&logo=opensourceinitiative&logoColor=white&logoSize=auto)](./LICENSE)
[![Sai Docs](https://img.shields.io/badge/rubydoc-blue?style=for-the-badge&logo=readthedocs&logoColor=white&logoSize=auto&label=docs)](https://rubydoc.info/gems/sai/0.3.1)
[![Sai Open Issues](https://img.shields.io/github/issues-search/aaronmallen/sai?query=state%3Aopen&style=for-the-badge&logo=github&logoColor=white&logoSize=auto&label=issues&color=red)](https://github.com/aaronmallen/sai/issues?q=state%3Aopen%20)

An elegant color management system for crafting sophisticated CLI applications

```ruby
# Create beautiful CLI applications with intuitive color management
puts Sai.rgb(255, 128, 0).bold.decorate('Warning: Battery Low')
puts Sai.hex('#4834d4').italic.decorate('Processing request...')
puts Sai.bright_cyan.on_blue.underline.decorate('Download Complete!')

# Adjust color brightness
puts Sai.red.darken_text(0.3).decorate('Subtle Error Message')
puts Sai.blue.lighten_text(0.5).decorate('Highlighted Info')

# Analyze and manipulate ANSI-encoded text
text = Sai.sequence("\e[31mError:\e[0m Connection failed")
puts text.without_color  # Keep formatting, remove colors
puts text.stripped      # Get plain text without any formatting
```

Sai (彩) - meaning 'coloring' or 'paint' in Japanese - is a powerful and intuitive system for managing color output in
command-line applications. Drawing inspiration from traditional Japanese artistic techniques, Sai brings vibrancy and
harmony to terminal interfaces through its sophisticated color management.

## Features

* Rich color support (True Color, 256 colors, ANSI, and basic modes)
* Automatic terminal capability detection and color mode adaptation
* RGB, Hex, and named color (**over 360 named colors**) support with bright variants
* Comprehensive text styling (bold, italic, underline, etc.)
* Advanced ANSI sequence parsing and manipulation
* Intelligent color downgrading for compatibility
* Respects NO_COLOR environment variable

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sai'
```

Or install it yourself as:

```ruby
gem install sai
```

> [!IMPORTANT]  
> If you're upgrading from version 0.2.0, please see our [Migration Guide](docs/migrations/0.2.0-0.3.0.md) for
> important changes.

## Quick Start

```ruby
require 'sai'

# Basic usage
puts Sai.red.decorate('Error!')
puts Sai.bright_blue.on_white.decorate('Info')

# Using RGB colors
puts Sai.rgb(255, 128, 0).decorate('Custom color')
puts Sai.on_rgb(0, 255, 128).decorate('Custom background')

# Color manipulation
puts Sai.blue.lighten_text(0.5).decorate('Lightened blue')
puts Sai.red.darken_text(0.3).decorate('Darkened red')

# Applying styles
puts Sai.bold.underline.decorate('Important')
puts Sai.red.bold.italic.decorate('Error!')

# Working with ANSI sequences
text = Sai.sequence("\e[31mError:\e[0m Details here")
puts text.without_color    # Remove colors but keep formatting
puts text.without_style    # Remove formatting but keep colors
puts text.stripped        # Get plain text
```

## Documentation

* [Complete Usage Guide](docs/USAGE.md) - Comprehensive documentation of all features
* [API Documentation](https://rubydoc.info/gems/sai/0.3.1) - Detailed API reference

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](docs/CONTRIBUTING.md) for:

* Development setup and workflow
* Code style and documentation standards
* Testing requirements
* Pull request process

Before contributing, please review our [Code of Conduct](docs/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](LICENSE).
