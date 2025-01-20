# frozen_string_literal: true

require 'sai'
require 'sai/ansi'
require 'sai/ansi/sequenced_string'
require 'sai/conversion/color_sequence'

module Sai
  # A decorator for applying ANSI styles and colors to text
  #
  # @author {https://aaronmallen.me Aaron Allen}
  # @since 0.1.0
  #
  # @api public
  class Decorator
    # Initialize a new instance of Decorator
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api private
    #
    # @param mode [Integer] the color mode to use
    #
    # @return [Decorator] the new instance of Decorator
    # @rbs (?mode: Integer) -> void
    def initialize(mode: Sai.mode.auto)
      @background = nil
      @mode = mode
      @foreground = nil
      @styles = [] #: Array[Symbol]
    end

    # @!method black
    #   Apply the named ANSI color "black" to the foreground
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.black.decorate('Hello, world!').to_s #=> "\e[30mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method blue
    #   Apply the named ANSI color "blue" to the foreground
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.blue.decorate('Hello, world!').to_s #=> "\e[34mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method bright_black
    #   Apply the named ANSI color "bright_black" to the foreground
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_black.decorate('Hello, world!').to_s #=> "\e[90mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method bright_blue
    #   Apply the named ANSI color "bright_blue" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_blue.decorate('Hello, world!').to_s #=> "\e[94mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method bright_cyan
    #   Apply the named ANSI color "bright_cyan" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_cyan.decorate('Hello, world!').to_s #=> "\e[96mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method bright_green
    #   Apply the named ANSI color "bright_green" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_green.decorate('Hello, world!').to_s #=> "\e[92mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method bright_magenta
    #   Apply the named ANSI color "bright_magenta" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_magenta.decorate('Hello, world!').to_s #=> "\e[95mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method bright_red
    #   Apply the named ANSI color "bright_red" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_red.decorate('Hello, world!').to_s #=> "\e[91mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method bright_white
    #   Apply the named ANSI color "bright_white" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_white.decorate('Hello, world!').to_s #=> "\e[97mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method bright_yellow
    #   Apply the named ANSI color "bright_yellow" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.bright_yellow.decorate('Hello, world!').to_s #=> "\e[93mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method cyan
    #   Apply the named ANSI color "cyan" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.cyan.decorate('Hello, world!').to_s #=> "\e[36mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method green
    #   Apply the named ANSI color "green" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.green.decorate('Hello, world!').to_s #=> "\e[32mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method magenta
    #   Apply the named ANSI color "magenta" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.magenta.decorate('Hello, world!').to_s #=> "\e[35mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_black
    #   Apply the named ANSI color "black" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_black.decorate('Hello, world!').to_s #=> "\e[40mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_blue
    #   Apply the named ANSI color "blue" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_blue.decorate('Hello, world!').to_s #=> "\e[44mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_bright_black
    #   Apply the named ANSI color "bright_black" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_black.decorate('Hello, world!').to_s #=> "\e[100mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_bright_blue
    #   Apply the named ANSI color "bright_blue" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_blue.decorate('Hello, world!').to_s #=> "\e[104mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_bright_cyan
    #   Apply the named ANSI color "bright_cyan" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_cyan.decorate('Hello, world!').to_s #=> "\e[106mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_bright_green
    #   Apply the named ANSI color "bright_green" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_green.decorate('Hello, world!').to_s #=> "\e[102mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_bright_magenta
    #   Apply the named ANSI color "bright_magenta" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_magenta.decorate('Hello, world!').to_s #=> "\e[105mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_bright_red
    #   Apply the named ANSI color "bright_red" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_red.decorate('Hello, world!').to_s #=> "\e[101mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_bright_white
    #   Apply the named ANSI color "bright_white" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_white.decorate('Hello, world!').to_s #=> "\e[107mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_bright_yellow
    #   Apply the named ANSI color "bright_yellow" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_bright_yellow.decorate('Hello, world!').to_s #=> "\e[103mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_cyan
    #   Apply the named ANSI color "cyan" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_cyan.decorate('Hello, world!').to_s #=> "\e[46mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_green
    #   Apply the named ANSI color "green" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_green.decorate('Hello, world!').to_s #=> "\e[42mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_magenta
    #   Apply the named ANSI color "magenta" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_magenta.decorate('Hello, world!').to_s #=> "\e[45mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_red
    #   Apply the named ANSI color "red" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_red.decorate('Hello, world!').to_s #=> "\e[41mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_white
    #   Apply the named ANSI color "white" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_white.decorate('Hello, world!').to_s #=> "\e[47mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method on_yellow
    #   Apply the named ANSI color "yellow" to the background
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.on_yellow.decorate('Hello, world!').to_s #=> "\e[43mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method red
    #   Apply the named ANSI color "red" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.red.decorate('Hello, world!').to_s #=> "\e[31mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method white
    #   Apply the named ANSI color "white" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.white.decorate('Hello, world!').to_s #=> "\e[37mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    #
    # @!method yellow
    #   Apply the named ANSI color "yellow" to the foreground
    #
    #   @api public
    #
    #   @example
    #     decorator.yellow.decorate('Hello, world!').to_s #=> "\e[33mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the color applied
    ANSI::COLOR_NAMES.each_key do |color|
      define_method(color) do
        apply_named_color(:foreground, color)
      end
      define_method(:"on_#{color}") do
        apply_named_color(:background, color)
      end
    end
    # @rbs!
    #   def black: () -> Decorator
    #   def blue: () -> Decorator
    #   def bright_black: () -> Decorator
    #   def bright_blue: () -> Decorator
    #   def bright_cyan: () -> Decorator
    #   def bright_green: () -> Decorator
    #   def bright_magenta: () -> Decorator
    #   def bright_red: () -> Decorator
    #   def bright_white: () -> Decorator
    #   def bright_yellow: () -> Decorator
    #   def cyan: () -> Decorator
    #   def green: () -> Decorator
    #   def magenta: () -> Decorator
    #   def on_black: () -> Decorator
    #   def on_blue: () -> Decorator
    #   def on_bright_black: () -> Decorator
    #   def on_bright_blue: () -> Decorator
    #   def on_bright_cyan: () -> Decorator
    #   def on_bright_green: () -> Decorator
    #   def on_bright_magenta: () -> Decorator
    #   def on_bright_red: () -> Decorator
    #   def on_bright_white: () -> Decorator
    #   def on_bright_yellow: () -> Decorator
    #   def on_cyan: () -> Decorator
    #   def on_green: () -> Decorator
    #   def on_magenta: () -> Decorator
    #   def on_red: () -> Decorator
    #   def on_white: () -> Decorator
    #   def on_yellow: () -> Decorator
    #   def red: () -> Decorator
    #   def white: () -> Decorator
    #   def yellow: () -> Decorator

    # @!method blink
    #   Apply the ANSI style "blink" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.blink.decorate('Hello, world!').to_s #=> "\e[5mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    #
    # @!method bold
    #   Apply the ANSI style "bold" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.bold.decorate('Hello, world!').to_s #=> "\e[1mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    #
    # @!method conceal
    #   Apply the ANSI style "conceal" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.conceal.decorate('Hello, world!').to_s #=> "\e[8mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    #
    # @!method dim
    #   Apply the ANSI style "dim" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.dim.decorate('Hello, world!').to_s #=> "\e[2mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    #
    # @!method italic
    #   Apply the ANSI style "italic" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.italic.decorate('Hello, world!').to_s #=> "\e[3mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    #
    # @!method no_blink
    #   Remove the ANSI style "blink" from the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.no_blink.decorate('Hello, world!').to_s #=> "\e[25mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    #
    # @!method no_conceal
    #   Remove the ANSI style "conceal" from the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.no_conceal.decorate('Hello, world!').to_s #=> "\e[28mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    #
    # @!method no_italic
    #   Remove the ANSI style "italic" from the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.no_italic.decorate('Hello, world!').to_s #=> "\e[23mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    #
    # @!method no_reverse
    #   Remove the ANSI style "reverse" from the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.no_reverse.decorate('Hello, world!').to_s #=> "\e[27mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    #
    # @!method no_strike
    #   Remove the ANSI style "strike" from the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.no_strike.decorate('Hello, world!').to_s #=> "\e[29mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    #
    # @!method no_underline
    #   Remove the ANSI style "underline" from the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.no_underline.decorate('Hello, world!').to_s #=> "\e[24mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    #
    # @!method normal_intensity
    #   Remove any intensity styles (bold or dim) from the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.normal_intensity.decorate('Hello, world!').to_s #=> "\e[22mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    #
    # @!method rapid_blink
    #   Apply the ANSI style "rapid_blink" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.rapid_blink.decorate('Hello, world!').to_s #=> "\e[6mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    #
    # @!method reverse
    #   Apply the ANSI style "reverse" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.reverse.decorate('Hello, world!').to_s #=> "\e[7mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    #
    # @!method strike
    #   Apply the ANSI style "strike" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.strike.decorate('Hello, world!').to_s #=> "\e[9mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    #
    # @!method underline
    #   Apply the ANSI style "underline" to the text
    #
    #   @author {https://aaronmallen.me Aaron Allen}
    #   @since 0.1.0
    #
    #   @api public
    #
    #   @example
    #     decorator.underline.decorate('Hello, world!').to_s #=> "\e[4mHello, world!\e[0m"
    #
    #   @return [Decorator] a new instance of Decorator with the style applied
    ANSI::STYLES.each_key do |style|
      define_method(style) do
        apply_style(style)
      end
    end

    # @rbs!
    #   def blink: () -> Decorator
    #   def bold: () -> Decorator
    #   def conceal: () -> Decorator
    #   def dim: () -> Decorator
    #   def italic: () -> Decorator
    #   def no_blink: () -> Decorator
    #   def no_conceal: () -> Decorator
    #   def no_italic: () -> Decorator
    #   def no_reverse: () -> Decorator
    #   def no_strike: () -> Decorator
    #   def no_underline: () -> Decorator
    #   def normal_intensity: () -> Decorator
    #   def rapid_blink: () -> Decorator
    #   def reverse: () -> Decorator
    #   def strike: () -> Decorator
    #   def underline: () -> Decorator

    # Apply the styles and colors to the text
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api public
    #
    # @example
    #   decorator.red.on_blue.bold.decorate('Hello, world!').to_s #=> "\e[38;5;160;48;5;21;1mHello, world!\e[0m"
    #
    # @param text [String] the text to decorate
    #
    # @return [ANSI::SequencedString] the decorated text
    # @rbs (String text) -> ANSI::SequencedString
    def decorate(text)
      return ANSI::SequencedString.new(text) unless should_decorate?

      sequences = [
        @foreground && Conversion::ColorSequence.resolve(@foreground, @mode),
        @background && Conversion::ColorSequence.resolve(@background, @mode, :background),
        @styles.map { |style| "\e[#{ANSI::STYLES[style]}m" }.join
      ].compact.join

      ANSI::SequencedString.new("#{sequences}#{text}#{ANSI::RESET}")
    end
    alias apply decorate
    alias call decorate
    alias encode decorate

    # Apply a hexadecimal color to the foreground
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api public
    #
    # @example
    #   decorator.hex("#EB4133").decorate('Hello, world!').to_s #=> "\e[38;2;235;65;51mHello, world!\e[0m"
    #
    # @param code [String] the hex color code
    #
    # @raise [ArgumentError] if the hex code is invalid
    # @return [Decorator] a new instance of Decorator with the hex color applied
    # @rbs (String code) -> Decorator
    def hex(code)
      raise ArgumentError, "Invalid hex color code: #{code}" unless /^#?([A-Fa-f0-9]{6})$/.match?(code)

      dup.tap { |duped| duped.instance_variable_set(:@foreground, code) }
    end

    # Apply a hexadecimal color to the background
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api public
    #
    # @example
    #   decorator.on_hex("#EB4133").decorate('Hello, world!').to_s #=> "\e[48;2;235;65;51mHello, world!\e[0m"
    #
    # @param code [String] the hex color code
    #
    # @raise [ArgumentError] if the hex code is invalid
    # @return [Decorator] a new instance of Decorator with the hex color applied
    # @rbs (String code) -> Decorator
    def on_hex(code)
      raise ArgumentError, "Invalid hex color code: #{code}" unless /^#?([A-Fa-f0-9]{6})$/.match?(code)

      dup.tap { |duped| duped.instance_variable_set(:@background, code) }
    end

    # Apply an RGB color to the background
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api public
    #
    # @example
    #   decorator.on_rgb(235, 65, 51).decorate('Hello, world!').to_s #=> "\e[48;2;235;65;51mHello, world!\e[0m"
    #
    # @param red [Integer] the red component
    # @param green [Integer] the green component
    # @param blue [Integer] the blue component
    #
    # @raise [ArgumentError] if the RGB values are out of range
    # @return [Decorator] a new instance of Decorator with the RGB color applied
    # @rbs (Integer red, Integer green, Integer blue) -> Decorator
    def on_rgb(red, green, blue)
      [red, green, blue].each do |value|
        raise ArgumentError, "Invalid RGB value: #{red}, #{green}, #{blue}" unless value >= 0 && value <= 255
      end

      dup.tap { |duped| duped.instance_variable_set(:@background, [red, green, blue]) }
    end

    # Apply an RGB color to the foreground
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api public
    #
    # @example
    #   decorator.rgb(235, 65, 51).decorate('Hello, world!').to_s #=> "\e[38;2;235;65;51mHello, world!\e[0m"
    #
    # @param red [Integer] the red component
    # @param green [Integer] the green component
    # @param blue [Integer] the blue component
    #
    # @raise [ArgumentError] if the RGB values are out of range
    # @return [Decorator] a new instance of Decorator with the RGB color applied
    # @rbs (Integer red, Integer green, Integer blue) -> Decorator
    def rgb(red, green, blue)
      [red, green, blue].each do |value|
        raise ArgumentError, "Invalid RGB value: #{red}, #{green}, #{blue}" unless value >= 0 && value <= 255
      end

      dup.tap { |duped| duped.instance_variable_set(:@foreground, [red, green, blue]) }
    end

    # Apply a specific color mode to the decorator
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.2.0
    #
    # @api public
    #
    # @example
    #   decorator.with_mode(Sai.mode.basic_auto) #=> => #<Sai::Decorator:0x123 @mode=1>
    #
    # @param mode [Integer] the color mode to use
    #
    # @return [Decorator] a new instance of Decorator with the applied color mode
    # @rbs (Integer mode) -> Decorator
    def with_mode(mode)
      dup.tap { |duped| duped.instance_variable_set(:@mode, mode) }
    end

    private

    # Apply a named color to the specified style type
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api private
    #
    # @param style_type [Symbol] the style type to apply the color to
    # @param color [Symbol] the color to apply
    #
    # @return [Decorator] a new instance of Decorator with the color applied
    # @rbs (Conversion::ColorSequence::style_type style_type, Symbol color) -> Decorator
    def apply_named_color(style_type, color)
      dup.tap { |duped| duped.instance_variable_set(:"@#{style_type}", color) }
    end

    # Apply a style to the text
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api private
    #
    # @param style [String, Symbol] the style to apply
    #
    # @return [Decorator] a new instance of Decorator with the style applied
    # @rbs (String | Symbol style) -> self
    def apply_style(style)
      style = style.to_s.downcase.to_sym
      dup.tap { |duped| duped.instance_variable_set(:@styles, (@styles + [style]).uniq) }
    end

    # Check if text should be decorated
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.2.0
    #
    # @api private
    #
    # @return [Boolean] `true` if text should be decorated, `false` otherwise
    # @rbs () -> bool
    def should_decorate?
      return false if @mode == Terminal::ColorMode::NO_COLOR
      return false if @foreground.nil? && @background.nil? && @styles.empty?

      true
    end
  end
end
