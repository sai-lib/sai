# frozen_string_literal: true

require 'sai'
require 'sai/ansi'
require 'sai/ansi/sequenced_string'
require 'sai/conversion/color_sequence'
require 'sai/conversion/rgb'

module Sai
  # A decorator for applying ANSI styles and colors to text
  #
  # @author {https://aaronmallen.me Aaron Allen}
  # @since 0.1.0
  #
  # @api public
  class Decorator # rubocop:disable Metrics/ClassLength
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
      @background_sequence = nil
      @mode = mode
      @foreground = nil
      @foreground_sequence = nil
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

    # Darken the background color by a percentage
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api public
    #
    # @example
    #   decorator.on_blue.darken_text(0.5).decorate('Hello, world!').to_s #=> "\e[48;2;0;0;238mHello, world!\e[0m"
    #
    # @param amount [Float] the amount to darken the background color (0.0...1.0)
    #
    # @raise [ArgumentError] if the percentage is out of range
    # @return [Decorator] a new instance of Decorator with the darkened background color
    # @rbs (Float amount) -> Decorator
    def darken_background(amount)
      raise ArgumentError, "Invalid percentage: #{amount}" unless amount >= 0.0 && amount <= 1.0

      darken(amount, :background)
    end
    alias darken_bg darken_background

    # Darken the text color by a percentage
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api public
    #
    # @example
    #   decorator.blue.darken_text(0.5).decorate('Hello, world!').to_s #=> "\e[38;2;0;0;119mHello, world!\e[0m"
    #
    # @param amount [Float] the amount to darken the text color (0.0...1.0)
    #
    # @raise [ArgumentError] if the percentage is out of range
    # @return [Decorator] a new instance of Decorator with the darkened text color
    # @rbs (Float amount) -> Decorator
    def darken_text(amount)
      raise ArgumentError, "Invalid percentage: #{amount}" unless amount >= 0.0 && amount <= 1.0

      darken(amount, :foreground)
    end
    alias darken_fg darken_text
    alias darken_foreground darken_text

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
      return apply_sequence_gradient(text) if @foreground_sequence || @background_sequence

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

    # Build a foreground gradient between two colors for text decoration
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api public
    #
    # @example Create a foreground gradient from red to blue
    #   decorator.gradient(:red, :blue, 10).decorate('Hello, World!')
    #   #=> "\e[38;2;255;0;0mH\e[0m\e[38;2;204;0;51me\e[0m..."
    #
    # @param start_color [Array<Integer>, String, Symbol] the starting color
    # @param end_color [Array<Integer>, String, Symbol] the ending color
    # @param steps [Integer] the number of gradient steps (minimum 2)
    #
    # @raise [ArgumentError] if steps is less than 2
    # @return [Decorator] a new instance of Decorator with foreground gradient colors
    # @rbs (
    #   Array[Integer] | String | Symbol start_color,
    #   Array[Integer] | String | Symbol end_color,
    #   Integer steps
    #   ) -> Decorator
    def gradient(start_color, end_color, steps)
      colors = Conversion::RGB.gradient(start_color, end_color, steps)
      dup.tap { |duped| duped.instance_variable_set(:@foreground_sequence, colors) }
    end

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

    # Lighten the background color by a percentage
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api public
    #
    # @example
    #   decorator.on_blue.lighten_background(0.5).decorate('Hello, world!').to_s
    #   #=> "\e[48;2;0;0;255mHello, world!\e[0m"
    #
    # @param amount [Float] the amount to lighten the background color (0.0...1.0)
    #
    # @raise [ArgumentError] if the percentage is out of range
    # @return [Decorator] a new instance of Decorator with the lightened background color
    # @rbs (Float amount) -> Decorator
    def lighten_background(amount)
      raise ArgumentError, "Invalid percentage: #{amount}" unless amount >= 0.0 && amount <= 1.0

      lighten(amount, :background)
    end
    alias lighten_bg lighten_background

    # Lighten the text color by a percentage
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api public
    #
    # @example
    #   decorator.blue.lighten_text(0.5).decorate('Hello, world!').to_s #=> "\e[38;2;0;0;127mHello, world!\e[0m"
    #
    # @param amount [Float] the amount to lighten the text color (0.0...1.0)
    #
    # @raise [ArgumentError] if the percentage is out of range
    # @return [Decorator] a new instance of Decorator with the lightened text color
    # @rbs (Float amount) -> Decorator
    def lighten_text(amount)
      raise ArgumentError, "Invalid percentage: #{amount}" unless amount >= 0.0 && amount <= 1.0

      lighten(amount, :foreground)
    end
    alias lighten_fg lighten_text
    alias lighten_foreground lighten_text

    # Build a background gradient between two colors for text decoration
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api public
    #
    # @example Create a background gradient from red to blue
    #   decorator.on_gradient(:red, :blue, 10).decorate('Hello, World!')
    #   #=> "\e[48;2;255;0;0mH\e[0m\e[48;2;204;0;51me\e[0m..."
    #
    # @param start_color [Array<Integer>, String, Symbol] the starting color
    # @param end_color [Array<Integer>, String, Symbol] the ending color
    # @param steps [Integer] the number of gradient steps (minimum 2)
    #
    # @raise [ArgumentError] if steps is less than 2
    # @return [Decorator] a new instance of Decorator with background gradient colors
    # @rbs (
    #   Array[Integer] | String | Symbol start_color,
    #   Array[Integer] | String | Symbol end_color,
    #   Integer steps
    #   ) -> Decorator
    def on_gradient(start_color, end_color, steps)
      colors = Conversion::RGB.gradient(start_color, end_color, steps)
      dup.tap { |duped| duped.instance_variable_set(:@background_sequence, colors) }
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

    # Build a background rainbow gradient for text decoration
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api public
    #
    # @example Create a rainbow background gradient
    #   decorator.on_rainbow(6).decorate('Hello, World!')
    #   #=> "\e[48;2;255;0;0mH\e[0m\e[48;2;255;255;0me\e[0m..."
    #
    # @param steps [Integer] the number of colors to generate (minimum 2)
    #
    # @raise [ArgumentError] if steps is less than 2
    # @return [Decorator] a new instance of Decorator with background rainbow colors
    # @rbs (Integer steps) -> Decorator
    def on_rainbow(steps)
      colors = Conversion::RGB.rainbow_gradient(steps)
      dup.tap { |duped| duped.instance_variable_set(:@background_sequence, colors) }
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

    # Build a foreground rainbow gradient for text decoration
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api public
    #
    # @example Create a rainbow text gradient
    #   decorator.rainbow(6).decorate('Hello, World!')
    #   #=> "\e[38;2;255;0;0mH\e[0m\e[38;2;255;255;0me\e[0m..."
    #
    # @param steps [Integer] the number of colors to generate (minimum 2)
    #
    # @raise [ArgumentError] if steps is less than 2
    # @return [Decorator] a new instance of Decorator with foreground rainbow colors
    # @rbs (Integer steps) -> Decorator
    def rainbow(steps)
      colors = Conversion::RGB.rainbow_gradient(steps)
      dup.tap { |duped| duped.instance_variable_set(:@foreground_sequence, colors) }
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

    # Adjust number of colors to match text length
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param colors [Array<Array<Integer>>] original color sequence
    # @param text_length [Integer] desired number of colors
    #
    # @return [Array<Array<Integer>>] adjusted color sequence
    # @rbs (Array[Array[Integer]] colors, Integer text_length) -> Array[Array[Integer]]
    def adjust_colors_to_text_length(colors, text_length)
      return colors if colors.length == text_length
      return stretch_colors(colors, text_length) if colors.length < text_length

      shrink_colors(colors, text_length)
    end

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

    # Apply color sequence gradients to text
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param text [String] the text to apply the gradient to
    #
    # @return [ANSI::SequencedString] the text with gradient applied
    # @rbs (String text) -> ANSI::SequencedString
    def apply_sequence_gradient(text)
      return ANSI::SequencedString.new(text) unless should_decorate?

      chars = text.chars
      adjusted_colors = prepare_color_sequences(chars.length)
      gradient_text = build_gradient_text(chars, adjusted_colors)

      ANSI::SequencedString.new(gradient_text.join)
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

    # Build color sequences for a single character
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param colors [Hash] color sequences for foreground and background
    # @param index [Integer] character position
    #
    # @return [Array<String>] ANSI sequences for the character
    # @rbs (Hash[Symbol, Array[Array[Integer]]] colors, Integer index) -> Array[String]
    def build_color_sequences(colors, index)
      sequences = []
      sequences << get_foreground_sequence(colors[:foreground], index) if colors[:foreground]
      sequences << get_background_sequence(colors[:background], index) if colors[:background]
      sequences += style_sequences
      sequences.compact
    end

    # Build gradient text from characters and color sequences
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param chars [Array<String>] text characters
    # @param colors [Hash] color sequences for foreground and background
    #
    # @return [Array<String>] colored characters
    # @rbs (Array[String] chars, Hash[Symbol, Array[Array[Integer]]] colors) -> Array[String]
    def build_gradient_text(chars, colors)
      chars.each_with_index.map do |char, i|
        next char if char == ' '

        sequences = build_color_sequences(colors, i)
        "#{sequences.join}#{char}#{ANSI::RESET}"
      end
    end

    # Calculate indices and progress for color interpolation
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param position [Integer] current position in sequence
    # @param step_size [Float] size of each step
    # @param max_index [Integer] maximum index allowed
    #
    # @return [Hash] interpolation indices and progress
    # @rbs (Integer position, Float step_size, Integer max_index) -> Hash[Symbol, Integer | Float]
    def calculate_interpolation_indices(position, step_size, max_index)
      position_in_sequence = position * step_size
      lower = position_in_sequence.floor
      upper = [lower + 1, max_index - 1].min
      progress = position_in_sequence - lower

      { lower: lower, upper: upper, progress: progress }
    end

    # Darken the foreground or background color by a specified amount
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param amount [Float] a value between 0.0 and 1.0 to darken the color by
    # @param component [Symbol] the color component to darken
    #
    # @return [Decorator] a new instance of Decorator with the color darkened
    # @rbs (Float amount, Symbol component) -> Decorator
    def darken(amount, component)
      color = instance_variable_get(:"@#{component}")

      dup.tap do |duped|
        if color
          rgb = Conversion::RGB.darken(color, amount)
          duped.instance_variable_set(:"@#{component}", rgb)
        end
      end
    end

    # Get background sequence for a character
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param colors [Array<Array<Integer>>, nil] background color sequence
    # @param index [Integer] character position
    #
    # @return [String, nil] ANSI sequence for background
    # @rbs (Array[Array[Integer]]? colors, Integer index) -> String?
    def get_background_sequence(colors, index)
      if colors
        Conversion::ColorSequence.resolve(colors[index], @mode, :background)
      elsif @background_sequence
        Conversion::ColorSequence.resolve(@background_sequence[index], @mode, :background)
      end
    end

    # Get foreground sequence for a character
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param colors [Array<Array<Integer>>, nil] foreground color sequence
    # @param index [Integer] character position
    #
    # @return [String, nil] ANSI sequence for foreground
    # @rbs (Array[Array[Integer]]? colors, Integer index) -> String?
    def get_foreground_sequence(colors, index)
      if colors
        Conversion::ColorSequence.resolve(colors[index], @mode)
      elsif @foreground_sequence
        Conversion::ColorSequence.resolve(@foreground_sequence[index], @mode)
      end
    end

    # Interpolate between two colors in a sequence
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param colors [Array<Array<Integer>>] color sequence
    # @param indices [Hash] interpolation indices and progress
    #
    # @return [Array<Integer>] interpolated color
    # @rbs (Array[Array[Integer]] colors, Hash[Symbol, Integer | Float]) -> Array[Integer]
    def interpolate_sequence_colors(colors, indices)
      lower_index = indices[:lower].to_i
      upper_index = indices[:upper].to_i
      progress = indices[:progress].to_f

      color1 = colors[lower_index]
      color2 = colors[upper_index]

      # Add nil guards
      return [0, 0, 0] unless color1 && color2

      color1.zip(color2).map do |c1, c2|
        next 0 unless c1 && c2 # Add nil guard for individual components

        (c1 + ((c2 - c1) * progress)).round
      end
    end

    # Lighten the foreground or background color by a specified amount
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param amount [Float] a value between 0.0 and 1.0 to lighten the color by
    # @param component [Symbol] the color component to lighten
    #
    # @return [Decorator] a new instance of Decorator with the color lightened
    # @rbs (Float amount, Symbol component) -> Decorator
    def lighten(amount, component)
      color = instance_variable_get(:"@#{component}")

      dup.tap do |duped|
        if color
          rgb = Conversion::RGB.lighten(color, amount)
          duped.instance_variable_set(:"@#{component}", rgb)
        end
      end
    end

    # Prepare foreground and background color sequences for text
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param text_length [Integer] length of text to color
    #
    # @return [Hash] adjusted color sequences
    # @rbs (Integer text_length) -> Hash[Symbol, Array[Array[Integer]]]
    def prepare_color_sequences(text_length)
      sequences = {}
      sequences[:foreground] = prepare_sequence(@foreground_sequence, text_length) if @foreground_sequence
      sequences[:background] = prepare_sequence(@background_sequence, text_length) if @background_sequence
      sequences
    end

    # Prepare a single color sequence
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param sequence [Array<Array<Integer>>, nil] color sequence to prepare
    # @param text_length [Integer] length of text to color
    #
    # @return [Array<Array<Integer>>, nil] adjusted color sequence
    # @rbs (Array[Array[Integer]]? sequence, Integer text_length) -> Array[Array[Integer]]?
    def prepare_sequence(sequence, text_length)
      sequence && adjust_colors_to_text_length(sequence, text_length)
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
      return false if @foreground.nil? && @background.nil? && @styles.empty? &&
                      @foreground_sequence.nil? && @background_sequence.nil?

      true
    end

    # Shrink a color sequence to fit desired length
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param colors [Array<Array<Integer>>] original color sequence
    # @param target_length [Integer] desired number of colors
    #
    # @return [Array<Array<Integer>>] shrunk color sequence
    # @rbs (Array[Array[Integer]] colors, Integer target_length) -> Array[Array[Integer]]
    def shrink_colors(colors, target_length)
      step_size = (target_length - 1).to_f / (colors.length - 1)
      indices = (0...colors.length).select { |i| (i * step_size).round < target_length }
      indices.map { |i| colors[i] }
    end

    # Stretch a color sequence to fit desired length
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @param colors [Array<Array<Integer>>] original color sequence
    # @param target_length [Integer] desired number of colors
    #
    # @return [Array<Array<Integer>>] stretched color sequence
    # @rbs (Array[Array[Integer]] colors, Integer target_length) -> Array[Array[Integer]]
    def stretch_colors(colors, target_length)
      step_size = (colors.length - 1).to_f / (target_length - 1)

      (0...target_length).map do |i|
        indices = calculate_interpolation_indices(i, step_size, colors.length)
        interpolate_sequence_colors(colors, indices)
      end
    end

    # Get style sequences
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @return [Array<String>] ANSI sequences for styles
    # @rbs () -> Array[String]
    def style_sequences
      @styles.map { |style| "\e[#{ANSI::STYLES[style]}m" }
    end
  end
end
