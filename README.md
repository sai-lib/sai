# Sai

[![Sai Version](https://img.shields.io/gem/v/sai?style=for-the-badge&logo=rubygems&logoColor=white&logoSize=auto&label=Gem%20Version)](https://rubygems.org/gems/sai)
[![Sai License](https://img.shields.io/github/license/aaronmallen/sai?style=for-the-badge&logo=opensourceinitiative&logoColor=white&logoSize=auto)](./LICENSE)
[![Sai Docs](https://img.shields.io/badge/rubydoc-blue?style=for-the-badge&logo=readthedocs&logoColor=white&logoSize=auto&label=docs)](https://rubydoc.info/gems/sai/0.1.0)
[![Sai Open Issues](https://img.shields.io/github/issues-search/aaronmallen/sai?query=state%3Aopen&style=for-the-badge&logo=github&logoColor=white&logoSize=auto&label=issues&color=red)](https://github.com/aaronmallen/sai/issues?q=state%3Aopen%20)

An elegant color management system for crafting sophisticated CLI applications

```ruby
puts Sai.rgb(255, 128, 0).bold.decorate('Create beautiful CLI applications')
puts Sai.hex('#4834d4').italic.decorate('with intuitive color management')
puts Sai.bright_cyan.on_blue.underline.decorate('that adapts to any terminal')
```

Sai (彩) - meaning 'coloring' or 'paint' in Japanese - is a powerful and intuitive system for managing color output in
command-line applications. Drawing inspiration from traditional Japanese artistic techniques, Sai brings vibrancy and
harmony to terminal interfaces through its sophisticated color management.

Sai empowers developers to create beautiful, colorful CLI applications that maintain visual consistency across different
terminal capabilities. Like its artistic namesake, it combines simplicity and sophistication to bring rich, adaptive
color to your terminal interfaces.

## Features

* Automatic color mode detection and downgrading
* Support for True Color (24-bit), 256 colors (8-bit), ANSI colors (4-bit), and basic colors (3-bit)
* Rich set of ANSI text styles
* Named color support with bright variants
* RGB and Hex color support
* Foreground and background colors
* Respects NO_COLOR environment variable
* Can be used directly or included in classes/modules

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sai'
```

Or install it yourself as:

```bash
gem install sai
```

## Usage

Sai can be used directly or included in your own classes and modules.

### Direct Usage

```ruby
require 'sai'

# Using named colors
puts Sai.red.decorate('Error!')
puts Sai.bright_blue.on_white.decorate('Info')

# Using RGB colors
puts Sai.rgb(255, 128, 0).decorate('Custom color')
puts Sai.on_rgb(0, 255, 128).decorate('Custom background')

# Using hex colors
puts Sai.hex('#FF8000').decorate('Hex color')
puts Sai.on_hex('#00FF80').decorate('Hex background')

# Applying styles
puts Sai.bold.underline.decorate('Important')
puts Sai.red.bold.italic.decorate('Error!')

# Complex combinations
puts Sai.bright_cyan
        .on_blue
        .bold
        .italic
        .decorate('Styled text')
```

### Module Inclusion

```ruby
class CLI
  include Sai

  def error(message)
    puts decorator.red.bold.decorate(message)
  end

  def info(message)
    puts decorator.bright_blue.decorate(message)
  end

  def success(message)
    puts decorator.with_mode(color_mode.ansi_auto).green.decorate(message)
  end
end

cli = CLI.new
cli.error('Something went wrong!')
cli.info('Processing...')
cli.success('Done!')
```

### Defining Reusable Styles

Sai decorators can be assigned to constants to create reusable styles throughout your application:

```ruby
module Style
  ERROR = Sai.bold.bright_white.on_red
  WARNING = Sai.black.on_yellow
  SUCCESS = Sai.bright_green
  INFO = Sai.bright_blue
  HEADER = Sai.bold.bright_cyan.underline
end

# Use your defined styles
puts Style::ERROR.decorate('Something went wrong!')
puts Style::SUCCESS.decorate('Operation completed successfully')

# Styles can be further customized when needed
puts Style::ERROR.italic.decorate('Critical error!')
```

> [!TIP]
> This pattern is particularly useful for maintaining consistent styling across your application and creating theme
> systems. You can even build on existing styles:
>
> ```ruby
> module Theme
>   PRIMARY = Sai.rgb(63, 81, 181)
>   SECONDARY = Sai.rgb(255, 87, 34)
>
>   BUTTON = PRIMARY.bold
>   LINK = SECONDARY.underline
>   HEADER = PRIMARY.bold.underline
> end
> ```

## Features

### Color Support

Sai supports up to 16.7 million colors (true color/24-bit) depending on your terminal's capabilities. Colors can be
specified in several ways:

#### RGB Colors

```ruby
# Specify any RGB color (0-255 per channel)
Sai.rgb(255, 128, 0).decorate('Orange text')
Sai.on_rgb(0, 255, 128).decorate('Custom green background')
```

#### Hex Colors

```ruby
# Use any hex color code
Sai.hex('#FF8000').decorate('Orange text')
Sai.on_hex('#00FF80').decorate('Custom green background')
```

#### Named Color Shortcuts

For convenience, Sai provides shortcuts for common ANSI colors:

Standard colors:

```ruby
Sai.red.decorate('Red text')
Sai.blue.decorate('Blue text')
Sai.on_green.decorate('Green background')
```

Bright variants:

```ruby
Sai.bright_red.decorate('Bright red text')
Sai.bright_blue.decorate('Bright blue text')
Sai.on_bright_green.decorate('Bright green background')
```

Available named colors:

* black/bright_black
* red/bright_red
* green/bright_green
* yellow/bright_yellow
* blue/bright_blue
* magenta/bright_magenta
* cyan/bright_cyan
* white/bright_white

> [!TIP]
> While named colors provide convenient shortcuts, remember that Sai supports the full RGB color space. Don't feel
> limited to just these predefined colors!

### Text Styles

Available styles:

* bold
* dim
* italic
* underline
* blink
* rapid_blink
* reverse
* conceal
* strike

Style removal:

* no_blink
* no_italic
* no_underline
* no_reverse
* no_conceal
* no_strike
* normal_intensity

### Color Mode Detection & Downgrading

Sai automatically detects your terminal's color capabilities and adapts the output appropriately:

* True Color terminals (24-bit): Full access to all 16.7 million colors
* 256-color terminals (8-bit): Colors are mapped to the closest available color in the 256-color palette
* ANSI terminals (4-bit): Colors are mapped to the 16 standard ANSI colors
* Basic terminals (3-bit): Colors are mapped to the 8 basic ANSI colors
* NO_COLOR: All color sequences are stripped when the NO_COLOR environment variable is set

> [!NOTE]
> This automatic downgrading ensures your application looks great across all terminal types without any extra code!

### Color Mode Selection

Sai provides flexible color mode selection through its `mode` interface:

```ruby
# Use automatic mode detection (default)
Sai.with_mode(Sai.mode.auto)

# Force specific color modes
puts Sai.with_mode(Sai.mode.true_color).red.decorate('24-bit color')
puts Sai.with_mode(Sai.mode.advanced).red.decorate('256 colors')
puts Sai.with_mode(Sai.mode.ansi).red.decorate('16 colors')
puts Sai.with_mode(Sai.mode.basic).red.decorate('8 colors')
puts Sai.with_mode(Sai.mode.no_color).red.decorate('No color')

# Use automatic downgrading
puts Sai.with_mode(Sai.mode.advanced_auto).red.decorate('256 colors or less')
puts Sai.with_mode(Sai.mode.ansi_auto).red.decorate('16 colors or less')
puts Sai.with_mode(Sai.mode.basic_auto).red.decorate('8 colors or less')
```

> [!WARNING]
> When using fixed color modes (like `true_color` or `advanced`), Sai will not automatically downgrade colors for
> terminals with lower color support. For automatic color mode adjustment, use modes ending in `_auto`
> (like `advanced_auto` or `ansi_auto`).

This allows you to:

* Explicitly set specific color modes
* Use automatic mode detection (default)
* Set maximum color modes with automatic downgrading
* Disable colors entirely

### Terminal Support Detection

You can check the terminal's capabilities:

```ruby
# Using directly
Sai.support.true_color? # => true/false
Sai.support.advanced?   # => true/false
Sai.support.ansi?      # => true/false
Sai.support.basic?     # => true/false
Sai.support.color?     # => true/false

# Using included module
class CLI
  include Sai

  def check_support
    if terminal_color_support.true_color?
      puts "Terminal supports true color!"
    end
  end
end
```

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](docs/CONTRIBUTING.md) for:

* Development setup and workflow
* Code style and documentation standards
* Testing requirements
* Pull request process

Before contributing, please review our [Code of Conduct](docs/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](LICENSE).
