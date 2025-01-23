# frozen_string_literal: true

module Sai
  class Decorator
    # Named color methods for the {Decorator} class
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.3.1
    #
    # @abstract This module is meant to be included in the {Decorator} class to provide named color methods
    # @api private
    #
    # @note For each named color, two methods are dynamically generated:
    #   * color_name - Applies the color to the foreground
    #   * on_color_name - Applies the color to the backgroundAll color methods return {Decorator}
    # @see Sai::NamedColors Sai::NamedColors for available color names
    #
    # @example Using a named color
    #   decorator.azure.decorate('Hello')      #=> "\e[38;2;0;127;255mHello\e[0m"
    #   decorator.on_azure.decorate('Hello')   #=> "\e[48;2;0;127;255mHello\e[0m"
    module NamedColors
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
