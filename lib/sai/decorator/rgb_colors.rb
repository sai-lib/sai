# frozen_string_literal: true

module Sai
  class Decorator
    # RGB color methods for the {Decorator} class
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @abstract This module is meant to be included in the {Decorator} class to provide RGB color methods
    # @api private
    module RGBColors
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

        dup.tap { |duped| duped.instance_variable_set(:@background, [red, green, blue]) } #: Decorator
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

        dup.tap { |duped| duped.instance_variable_set(:@foreground, [red, green, blue]) } #: Decorator
      end
    end
  end
end
