# frozen_string_literal: true

module Sai
  class Decorator
    # Named style methods for the {Decorator} class
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @abstract This module is meant to be included in the {Decorator} class to provide named style methods
    # @api private
    module NamedStyles
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

      private

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
      # @rbs (String | Symbol style) -> Decorator
      def apply_style(style)
        style = style.to_s.downcase.to_sym
        dup.tap { |duped| duped.instance_variable_set(:@styles, (@styles + [style]).uniq) } #: Decorator
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
end
