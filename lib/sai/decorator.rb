# frozen_string_literal: true

require 'sai/ansi'
require 'sai/conversion/color_sequence'

module Sai
  # A decorator for applying ANSI styles and colors to text
  #
  # @author {https://aaronmallen.me Aaron Allen}
  # @since unreleased
  #
  # @api public
  class Decorator
    # Initialize a new instance of Decorator
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param color_mode [Integer] the color mode to use
    #
    # @return [Decorator] the new instance of Decorator
    # @rbs (Integer color_mode) -> void
    def initialize(color_mode)
      @background = nil
      @color_mode = color_mode
      @foreground = nil
      @styles = [] #: Array[Symbol]
    end

    # @!method black
    #   Apply the named ANSI color "black" to the foreground
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.black.decorate('Hello, world!') #=> "\e[30mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method blue
    #   Apply the named ANSI color "blue" to the foreground
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.blue.decorate('Hello, world!') #=> "\e[34mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method bright_black
    #   Apply the named ANSI color "bright_black" to the foreground
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_black.decorate('Hello, world!') #=> "\e[90mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method bright_blue
    #   Apply the named ANSI color "bright_blue" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_blue.decorate('Hello, world!') #=> "\e[94mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method bright_cyan
    #   Apply the named ANSI color "bright_cyan" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_cyan.decorate('Hello, world!') #=> "\e[96mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method bright_green
    #   Apply the named ANSI color "bright_green" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_green.decorate('Hello, world!') #=> "\e[92mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method bright_magenta
    #   Apply the named ANSI color "bright_magenta" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_magenta.decorate('Hello, world!') #=> "\e[95mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method bright_red
    #   Apply the named ANSI color "bright_red" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_red.decorate('Hello, world!') #=> "\e[91mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method bright_white
    #   Apply the named ANSI color "bright_white" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_white.decorate('Hello, world!') #=> "\e[97mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method bright_yellow
    #   Apply the named ANSI color "bright_yellow" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_yellow.decorate('Hello, world!') #=> "\e[93mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method cyan
    #   Apply the named ANSI color "cyan" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.cyan.decorate('Hello, world!') #=> "\e[36mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method green
    #   Apply the named ANSI color "green" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.green.decorate('Hello, world!') #=> "\e[32mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method magenta
    #   Apply the named ANSI color "magenta" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.magenta.decorate('Hello, world!') #=> "\e[35mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_black
    #   Apply the named ANSI color "black" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_black.decorate('Hello, world!') #=> "\e[40mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_blue
    #   Apply the named ANSI color "blue" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_blue.decorate('Hello, world!') #=> "\e[44mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_bright_black
    #   Apply the named ANSI color "bright_black" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_black.decorate('Hello, world!') #=> "\e[100mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_bright_blue
    #   Apply the named ANSI color "bright_blue" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_blue.decorate('Hello, world!') #=> "\e[104mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_bright_cyan
    #   Apply the named ANSI color "bright_cyan" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_cyan.decorate('Hello, world!') #=> "\e[106mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_bright_green
    #   Apply the named ANSI color "bright_green" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_green.decorate('Hello, world!') #=> "\e[102mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_bright_magenta
    #   Apply the named ANSI color "bright_magenta" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_magenta.decorate('Hello, world!') #=> "\e[105mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_bright_red
    #   Apply the named ANSI color "bright_red" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_red.decorate('Hello, world!') #=> "\e[101mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_bright_white
    #   Apply the named ANSI color "bright_white" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_white.decorate('Hello, world!') #=> "\e[107mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_bright_yellow
    #   Apply the named ANSI color "bright_yellow" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_yellow.decorate('Hello, world!') #=> "\e[103mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_cyan
    #   Apply the named ANSI color "cyan" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_cyan.decorate('Hello, world!') #=> "\e[46mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_green
    #   Apply the named ANSI color "green" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_green.decorate('Hello, world!') #=> "\e[42mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_magenta
    #   Apply the named ANSI color "magenta" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_magenta.decorate('Hello, world!') #=> "\e[45mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_red
    #   Apply the named ANSI color "red" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_red.decorate('Hello, world!') #=> "\e[41mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_white
    #   Apply the named ANSI color "white" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_white.decorate('Hello, world!') #=> "\e[47mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method on_yellow
    #   Apply the named ANSI color "yellow" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.on_yellow.decorate('Hello, world!') #=> "\e[43mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method red
    #   Apply the named ANSI color "red" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.red.decorate('Hello, world!') #=> "\e[31mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method white
    #   Apply the named ANSI color "white" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.white.decorate('Hello, world!') #=> "\e[37mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method yellow
    #   Apply the named ANSI color "yellow" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.yellow.decorate('Hello, world!') #=> "\e[33mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    ANSI::COLOR_NAMES.each_key do |color|
      define_method(color) do
        apply_named_color(:foreground, color)
      end
      define_method(:"on_#{color}") do
        apply_named_color(:background, color)
      end
    end
    # @rbs!
    #   def black: () -> self
    #   def blue: () -> self
    #   def bright_black: () -> self
    #   def bright_blue: () -> self
    #   def bright_cyan: () -> self
    #   def bright_green: () -> self
    #   def bright_magenta: () -> self
    #   def bright_red: () -> self
    #   def bright_white: () -> self
    #   def bright_yellow: () -> self
    #   def cyan: () -> self
    #   def green: () -> self
    #   def magenta: () -> self
    #   def on_black: () -> self
    #   def on_blue: () -> self
    #   def on_bright_black: () -> self
    #   def on_bright_blue: () -> self
    #   def on_bright_cyan: () -> self
    #   def on_bright_green: () -> self
    #   def on_bright_magenta: () -> self
    #   def on_bright_red: () -> self
    #   def on_bright_white: () -> self
    #   def on_bright_yellow: () -> self
    #   def on_cyan: () -> self
    #   def on_green: () -> self
    #   def on_magenta: () -> self
    #   def on_red: () -> self
    #   def on_white: () -> self
    #   def on_yellow: () -> self
    #   def red: () -> self
    #   def white: () -> self
    #   def yellow: () -> self

    # @!method blink
    #   Apply the ANSI style "blink" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.blink.decorate('Hello, world!') #=> "\e[5mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method bold
    #   Apply the ANSI style "bold" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.bold.decorate('Hello, world!') #=> "\e[1mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method conceal
    #   Apply the ANSI style "conceal" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.conceal.decorate('Hello, world!') #=> "\e[8mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method dim
    #   Apply the ANSI style "dim" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.dim.decorate('Hello, world!') #=> "\e[2mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method italic
    #   Apply the ANSI style "italic" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.italic.decorate('Hello, world!') #=> "\e[3mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method no_blink
    #   Remove the ANSI style "blink" from the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.no_blink.decorate('Hello, world!') #=> "\e[25mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method no_conceal
    #   Remove the ANSI style "conceal" from the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.no_conceal.decorate('Hello, world!') #=> "\e[28mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method no_italic
    #   Remove the ANSI style "italic" from the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.no_italic.decorate('Hello, world!') #=> "\e[23mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method no_reverse
    #   Remove the ANSI style "reverse" from the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.no_reverse.decorate('Hello, world!') #=> "\e[27mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method no_strike
    #   Remove the ANSI style "strike" from the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.no_strike.decorate('Hello, world!') #=> "\e[29mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method no_underline
    #   Remove the ANSI style "underline" from the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.no_underline.decorate('Hello, world!') #=> "\e[24mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method normal_intensity
    #   Remove any intensity styles (bold or dim) from the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.normal_intensity.decorate('Hello, world!') #=> "\e[22mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method rapid_blink
    #   Apply the ANSI style "rapid_blink" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.rapid_blink.decorate('Hello, world!') #=> "\e[6mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method reverse
    #   Apply the ANSI style "reverse" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.reverse.decorate('Hello, world!') #=> "\e[7mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method strike
    #   Apply the ANSI style "strike" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.strike.decorate('Hello, world!') #=> "\e[9mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    #
    # @!method underline
    #   Apply the ANSI style "underline" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since unreleased
    #
    #   @api public
    #
    #   @example
    #     decorator.underline.decorate('Hello, world!') #=> "\e[4mHello, world!\e[0m"
    #
    #   @return [self] the instance of Decorator for chaining
    ANSI::STYLES.each_key do |style|
      define_method(style) do
        apply_style(style)
      end
    end

    # @rbs!
    #   def blink: () -> self
    #   def bold: () -> self
    #   def conceal: () -> self
    #   def dim: () -> self
    #   def italic: () -> self
    #   def no_blink: () -> self
    #   def no_conceal: () -> self
    #   def no_italic: () -> self
    #   def no_reverse: () -> self
    #   def no_strike: () -> self
    #   def no_underline: () -> self
    #   def normal_intensity: () -> self
    #   def rapid_blink: () -> self
    #   def reverse: () -> self
    #   def strike: () -> self
    #   def underline: () -> self

    # Apply the styles and colors to the text
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api public
    #
    # @example
    #   decorator.red.on_blue.bold.decorate('Hello, world!')
    #   #=> "\e[38;2;205;0;0m\e[48;2;0;0;238m\e[1mHello, world!\e[0m"
    #
    # @param text [String] the text to decorate
    #
    # @return [String] the decorated text
    # @rbs (String text) -> String
    def decorate(text)
      return text if @foreground.nil? && @background.nil? && @styles.empty?

      sequences = [
        @foreground && Conversion::ColorSequence.resolve(@foreground, @color_mode),
        @background && Conversion::ColorSequence.resolve(@background, @color_mode, :background),
        @styles.map { |style| "\e[#{ANSI::STYLES[style]}m" }.join
      ].compact.join

      "#{sequences}#{text}#{ANSI::RESET}"
    end
    alias apply decorate
    alias call decorate
    alias encode decorate

    # Apply a hexadecimal color to the foreground
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api public
    #
    # @example
    #   decorator.hex("#EB4133").decorate('Hello, world!') #=> "\e[38;2;235;65;51mHello, world!\e[0m"
    #
    # @param code [String] the hex color code
    #
    # @raise [ArgumentError] if the hex code is invalid
    # @return [self] the instance of Decorator for chaining
    # @rbs (String code) -> self
    def hex(code)
      raise ArgumentError, "Invalid hex color code: #{code}" unless /^#?([A-Fa-f0-9]{6})$/.match?(code)

      @foreground = code
      self
    end

    # Apply a hexadecimal color to the background
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api public
    #
    # @example
    #   decorator.on_hex("#EB4133").decorate('Hello, world!') #=> "\e[48;2;235;65;51mHello, world!\e[0m"
    #
    # @param code [String] the hex color code
    #
    # @raise [ArgumentError] if the hex code is invalid
    # @return [self] the instance of Decorator for chaining
    # @rbs (String code) -> self
    def on_hex(code)
      raise ArgumentError, "Invalid hex color code: #{code}" unless /^#?([A-Fa-f0-9]{6})$/.match?(code)

      @background = code
      self
    end

    # Apply an RGB color to the background
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api public
    #
    # @example
    #   decorator.on_rgb(235, 65, 51).decorate('Hello, world!') #=> "\e[48;2;235;65;51mHello, world!\e[0m"
    #
    # @param red [Integer] the red component
    # @param green [Integer] the green component
    # @param blue [Integer] the blue component
    #
    # @raise [ArgumentError] if the RGB values are out of range
    # @return [self] the instance of Decorator for chaining
    # @rbs (Integer red, Integer green, Integer blue) -> self
    def on_rgb(red, green, blue)
      [red, green, blue].each do |value|
        raise ArgumentError, "Invalid RGB value: #{red}, #{green}, #{blue}" unless value >= 0 && value <= 255
      end

      @background = [red, green, blue]
      self
    end

    # Apply an RGB color to the foreground
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api public
    #
    # @example
    #   decorator.rgb(235, 65, 51).decorate('Hello, world!') #=> "\e[38;2;235;65;51mHello, world!\e[0m"
    #
    # @param red [Integer] the red component
    # @param green [Integer] the green component
    # @param blue [Integer] the blue component
    #
    # @raise [ArgumentError] if the RGB values are out of range
    # @return [self] the instance of Decorator for chaining
    # @rbs (Integer red, Integer green, Integer blue) -> self
    def rgb(red, green, blue)
      [red, green, blue].each do |value|
        raise ArgumentError, "Invalid RGB value: #{red}, #{green}, #{blue}" unless value >= 0 && value <= 255
      end

      @foreground = [red, green, blue]
      self
    end

    private

    # Apply a named color to the specified style type
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param style_type [Symbol] the style type to apply the color to
    # @param color [Symbol] the color to apply
    #
    # @raise [ArgumentError] if the color is invalid
    # @return [self] the instance of Decorator for chaining
    # @rbs (Conversion::ColorSequence::style_type style_type, Symbol color) -> self
    def apply_named_color(style_type, color)
      unless ANSI::COLOR_NAMES.key?(color.to_s.downcase.to_sym)
        e = ArgumentError.new("Invalid color: #{color}")
        e.set_backtrace(caller_locations(1, 1)&.map(&:to_s)) # steep:ignore UnresolvedOverloading
        raise e
      end

      instance_variable_set(:"@#{style_type}", color)
      self
    end

    # Apply a style to the text
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param style [String, Symbol] the style to apply
    #
    # @raise [ArgumentError] if the style is invalid
    # @return [self] the instance of Decorator for chaining
    # @rbs (String | Symbol style) -> self
    def apply_style(style)
      unless ANSI::STYLES.key?(style.to_s.downcase.to_sym)
        e = ArgumentError.new("Invalid style: #{style}")
        e.set_backtrace(caller_locations(1, 1)&.map(&:to_s)) # steep:ignore UnresolvedOverloading
        raise e
      end

      @styles = @styles.push(style.to_s.downcase.to_sym).uniq
      self
    end
  end
end
