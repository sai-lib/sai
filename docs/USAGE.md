# Sai Usage Guide

This guide provides comprehensive documentation for using Sai in your applications.

## Table of Contents

* [Basic Usage](#basic-usage)
* [Color Support](#color-support)
  * [RGB Colors](#rgb-colors)
  * [Hex Colors](#hex-colors)
  * [Named Colors](#named-colors)
  * [Color Manipulation](#color-manipulation)
  * [Gradient and Rainbow Effects](#gradient-and-rainbow-effects)
* [Text Styles](#text-styles)
* [ANSI Sequence Manipulation](#ansi-sequence-manipulation)
* [Color Mode Management](#color-mode-management)
* [Terminal Capabilities](#terminal-capabilities)
* [Integration Patterns](#integration-patterns)
* [Best Practices](#best-practices)

## Basic Usage

Sai can be used directly or included in your own classes and modules:

```ruby
# Direct usage
puts Sai.red.decorate('Error!')
puts Sai.bright_blue.on_white.decorate('Info')

# Include in your own classes
class CLI
  include Sai

  def error(message)
    puts decorator.red.bold.decorate(message)
  end

  def info(message)
    puts decorator.bright_blue.decorate(message)
  end
end
```

## Color Support

### RGB Colors

Use any RGB color (0-255 per channel):

```ruby
# Foreground colors
Sai.rgb(255, 128, 0).decorate('Orange text')
Sai.rgb(100, 149, 237).decorate('Cornflower blue')

# Background colors
Sai.on_rgb(0, 255, 128).decorate('Custom green background')
```

### Hex Colors

Use any hex color code:

```ruby
# Foreground colors
Sai.hex('#FF8000').decorate('Orange text')
Sai.hex('#6495ED').decorate('Cornflower blue')

# Background colors
Sai.on_hex('#00FF80').decorate('Custom green background')
```

### Named Colors

Common ANSI colors have convenient shortcuts:

```ruby
# Standard colors
Sai.red.decorate('Red text')
Sai.blue.decorate('Blue text')
Sai.on_green.decorate('Green background')

# Bright variants
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

#### Registering Custom Named Colors

Sai allows you to register custom named colors for easy reuse with `Sai.register`:

```ruby
# Register custom colors
Sai.register(:my_color, '#CF4C5F')

# or alternatively 
Sai.register(:my_color, [207, 76, 95])

Sai.my_color.decorate('Hello, world!')
```

### Color Manipulation

Adjust the brightness of colors:

```ruby
# Darken colors
Sai.red.darken_text(0.5).decorate('Darkened red text')
Sai.on_blue.darken_background(0.3).decorate('Darkened blue background')

# Lighten colors
Sai.blue.lighten_text(0.5).decorate('Lightened blue text')
Sai.on_red.lighten_background(0.3).decorate('Lightened red background')
```

### Gradient and Rainbow Effects

Create dynamic color transitions across text:

```ruby
# Text gradients (foreground)
Sai.gradient('#000000', '#FFFFFF', 5).decorate('Black to white gradient')
Sai.gradient(:red, :blue, 10).decorate('Red to blue gradient')
Sai.rainbow(6).decorate('Rainbow text')

# Background gradients
Sai.on_gradient('#FF0000', '#0000FF', 8).decorate('Red to blue background')
Sai.on_gradient(:yellow, :green, 5).decorate('Yellow to green background')
Sai.on_rainbow(6).decorate('Rainbow background')
```

Gradients can use any combination of color formats (hex, RGB, or named colors) and will automatically adjust to fit your
text length. Spaces in text are preserved without color effects.

> [!TIP]
> The number of gradient steps affects the smoothness of the transition. More steps create smoother gradients, but
> consider terminal performance for very long text.

## Text Styles

Sai supports a variety of text styles:

```ruby
Sai.bold.decorate('Bold text')
Sai.italic.decorate('Italic text')
Sai.underline.decorate('Underlined text')
Sai.strike.decorate('Strikethrough text')
```

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

## ANSI Sequence Manipulation

Sai provides powerful tools for working with ANSI-encoded strings:

```ruby
# Create a SequencedString from decorated text
text = Sai.red.bold.decorate("Warning!")

# Or parse existing ANSI text
text = Sai.sequence("\e[31mred\e[0m and \e[32mgreen\e[0m")

# Get plain text without formatting
plain = text.stripped  # => "red and green"

# Remove specific attributes
text.without_color    # Remove all colors but keep styles
text.without_style    # Remove all styles but keep colors
text.without_style(:bold, :italic)  # Remove specific styles

# Access individual segments
text.each do |segment|
  puts "Text: #{segment.text}"
  puts "Foreground: #{segment.foreground}"
  puts "Background: #{segment.background}"
  puts "Styles: #{segment.styles}"
  puts "Position: #{segment.encoded_location.start_position}..#{segment.encoded_location.end_position}"
end
```

## Color Mode Management

Sai by default automatically detects your terminal's capabilities and automatically downgrades colors based on those
capabilities but also allows manual control:

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

Color Mode Hierarchy:

1. True Color (24-bit): 16.7 million colors
2. Advanced (8-bit): 256 colors
3. ANSI (4-bit): 16 colors
4. Basic (3-bit): 8 colors
5. No Color: All formatting stripped

## Terminal Capabilities

Check terminal color support:

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

## Integration Patterns

### Defining Reusable Styles

Create consistent styling across your application:

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

# Styles can be further customized
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

### Class Integration

Integrate Sai into your classes:

```ruby
class Logger
  include Sai

  def error(message)
    puts decorator.red.bold.decorate(message)
  end

  def warn(message)
    puts decorator.yellow.decorate(message)
  end

  def info(message)
    puts decorator.with_mode(color_mode.true_color).bright_blue.decorate(message)
  end
end
```

## Best Practices

1. **Automatic Mode Detection**
  * Use `Sai.mode.auto` by default to respect terminal capabilities
  * Only force specific color modes when necessary

2. **Color Usage**
  * Use named colors for standard indicators (red for errors, etc.)
  * Use RGB/Hex for brand colors or specific design requirements
  * Consider color blindness when choosing colors
  * Use `darken_text`/`lighten_text` to create visual hierarchy or emphasis

3. **Style Organization**
  * Create reusable styles for consistency
  * Group related styles in modules
  * Consider creating a theme system for larger applications

4. **Performance**
  * Cache decorator instances when using repeatedly
  * Use `SequencedString` parsing for complex manipulations
  * Consider terminal capabilities when designing output

5. **Accessibility**
  * Don't rely solely on color for important information
  * Use styles (bold, underline) to enhance meaning
  * Respect NO_COLOR environment variable
