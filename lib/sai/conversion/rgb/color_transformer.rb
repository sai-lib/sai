# frozen_string_literal: true

require 'sai/conversion/rgb/color_space'

module Sai
  module Conversion
    module RGB
      # Perform color transformations
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.1
      #
      # @api private
      module ColorTransformer
        class << self
          # Darken an RGB color by a percentage
          #
          # @author {https://aaronmallen.me Aaron Allen}
          # @since 0.3.1
          #
          # @api private
          #
          # @param color [Array<Integer>, String, Symbol] the color to darken
          # @param amount [Float] amount to darken by (0.0-1.0)
          #
          # @raise [ArgumentError] if amount is not between 0.0 and 1.0
          # @return [Array<Integer>] the darkened RGB values
          # @rbs ((Array[Integer] | String | Symbol) color, Float amount) -> Array[Integer]
          def darken(color, amount)
            raise ArgumentError, "Invalid amount: #{amount}" unless amount.between?(0.0, 1.0)

            rgb = ColorSpace.resolve(color)
            rgb.map { |c| [0, (c * (1 - amount)).round].max }
          end

          # Generate a gradient between two colors with a specified number of steps
          #
          # @author {https://aaronmallen.me Aaron Allen}
          # @since 0.3.1
          #
          # @api private
          #
          # @param start_color [Array<Integer>, String, Symbol] the starting color
          # @param end_color [Array<Integer>, String, Symbol] the ending color
          # @param steps [Integer] the number of colors to generate (minimum 2)
          #
          # @raise [ArgumentError] if steps is less than 2
          # @return [Array<Array<Integer>>] the gradient colors as RGB values
          # @rbs (
          #   (Array[Integer] | String | Symbol) start_color,
          #   (Array[Integer] | String | Symbol) end_color,
          #   Integer steps
          #   ) -> Array[Array[Integer]]
          def gradient(start_color, end_color, steps)
            raise ArgumentError, "Steps must be at least 2, got: #{steps}" if steps < 2

            (0...steps).map do |i|
              step = i.to_f / (steps - 1)
              interpolate_color(start_color, end_color, step)
            end
          end

          # Interpolate between two colors to create a gradient step
          #
          # @author {https://aaronmallen.me Aaron Allen}
          # @since 0.3.1
          #
          # @api private
          #
          # @param start_color [Array<Integer>, String, Symbol] the starting color
          # @param end_color [Array<Integer>, String, Symbol] the ending color
          # @param step [Float] the interpolation step (0.0-1.0)
          #
          # @raise [ArgumentError] if step is not between 0.0 and 1.0
          # @return [Array<Integer>] the interpolated RGB values
          # @rbs (
          #   (Array[Integer] | String | Symbol) start_color,
          #   (Array[Integer] | String | Symbol) end_color,
          #   Float step
          #   ) -> Array[Integer]
          def interpolate_color(start_color, end_color, step)
            raise ArgumentError, "Invalid step: #{step}" unless step.between?(0.0, 1.0)

            start_rgb = ColorSpace.resolve(start_color)
            end_rgb = ColorSpace.resolve(end_color)

            start_rgb.zip(end_rgb).map do |values|
              start_val, end_val = values
              next 0 unless start_val && end_val # Handle potential nil values

              (start_val + ((end_val - start_val) * step)).round.clamp(0, 255)
            end
          end

          # Lighten an RGB color by a percentage
          #
          # @author {https://aaronmallen.me Aaron Allen}
          # @since 0.3.1
          #
          # @api private
          #
          # @param color [Array<Integer>, String, Symbol] the color to lighten
          # @param amount [Float] amount to lighten by (0.0-1.0)
          #
          # @raise [ArgumentError] if amount is not between 0.0 and 1.0
          # @return [Array<Integer>] the lightened RGB values
          # @rbs ((Array[Integer] | String | Symbol) color, Float amount) -> Array[Integer]
          def lighten(color, amount)
            raise ArgumentError, "Invalid amount: #{amount}" unless amount.between?(0.0, 1.0)

            rgb = ColorSpace.resolve(color)
            rgb.map { |c| [255, (c * (1 + amount)).round].min }
          end

          # Generate a rainbow gradient with a specified number of steps
          #
          # @author {https://aaronmallen.me Aaron Allen}
          # @since 0.3.1
          #
          # @api private
          #
          # @param steps [Integer] the number of colors to generate (minimum 2)
          #
          # @raise [ArgumentError] if steps is less than 2
          # @return [Array<Array<Integer>>] the rainbow gradient colors as RGB values
          # @rbs (Integer steps) -> Array[Array[Integer]]
          def rainbow_gradient(steps)
            raise ArgumentError, "Steps must be at least 2, got: #{steps}" if steps < 2

            hue_step = 360.0 / steps
            (0...steps).map do |i|
              hue = (i * hue_step) % 360
              ColorSpace.hsv_to_rgb(hue, 1.0, 1.0)
            end
          end
        end
      end
    end
  end
end
