# frozen_string_literal: true

require 'sai/ansi'

module Sai
  class Decorator
    # Named color methods for the {Decorator} class
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @abstract This module is meant to be included in the {Decorator} class to provide named color methods
    # @api private
    module NamedColors
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
        dup.tap { |duped| duped.instance_variable_set(:"@#{style_type}", color) } #: Decorator
      end
    end
  end
end
