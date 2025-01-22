# frozen_string_literal: true

module Sai
  module Conversion
    module RGB
      # Color indexing utilities
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.1
      #
      # @api private
      module ColorIndexer
        class << self
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
          def color_cube(rgb)
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
          def grayscale(rgb)
            232 + ((rgb[0] / 255.0) * 23).round
          end
        end
      end
    end
  end
end
