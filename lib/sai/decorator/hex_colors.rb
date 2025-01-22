# frozen_string_literal: true

module Sai
  class Decorator
    # Hexadecimal color methods for the {Decorator} class
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @abstract This module is meant to be included in the {Decorator} class to provide hexadecimal color methods
    # @api private
    module HexColors
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

        dup.tap { |duped| duped.instance_variable_set(:@foreground, code) } #: Decorator
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

        dup.tap { |duped| duped.instance_variable_set(:@background, code) } #: Decorator
      end
    end
  end
end
