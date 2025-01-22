# frozen_string_literal: true

require 'sai/ansi'
require 'sai/conversion/rgb/color_classifier'
require 'sai/conversion/rgb/color_space'
require 'sai/conversion/rgb/color_transformer'

module Sai
  module Conversion
    # RGB color conversion utilities
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api private
    module RGB
      class << self
        # Color classification utilities
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @return [Module<ColorClassifier>] the ColorClassifier module
        # @rbs () -> singleton(ColorClassifier)
        def classify
          ColorClassifier
        end

        # Convert a color value to RGB components
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @param color [String, Array<Integer>] the color to convert
        #
        # @raise [ArgumentError] if the color format is invalid
        # @return [Array<Integer>] the RGB components
        # @rbs (Array[Integer] | String | Symbol color) -> Array[Integer]
        def resolve(color)
          ColorSpace.resolve(color)
        end

        # Convert RGB values to 256-color cube index
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @param rgb [Array<Integer>] RGB values (0-255)
        #
        # @return [Integer] the color cube index
        # @rbs (Array[Integer] rgb) -> Integer
        def to_color_cube_index(rgb)
          r, g, b = rgb.map { |c| ((c / 255.0) * 5).round } #: [Integer, Integer, Integer]
          16 + (r * 36) + (g * 6) + b
        end

        # Convert RGB values to grayscale index
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @param rgb [Array<Integer>] RGB values
        #
        # @return [Integer] the grayscale index
        # @rbs (Array[Integer] rgb) -> Integer
        def to_grayscale_index(rgb)
          232 + ((rgb[0] / 255.0) * 23).round
        end

        # Transform RGB values
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since unreleased
        #
        # @api private
        #
        # @return [Module<ColorTransformer>] the color transformer
        # @rbs () -> singleton(ColorTransformer)
        def transform
          ColorTransformer
        end
      end
    end
  end
end
