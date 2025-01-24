# frozen_string_literal: true

require 'sai/conversion/cache'

module Sai
  module Conversion
    module RGB
      # Classify color characteristics
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.1
      #
      # @api private
      module ColorClassifier
        class << self
          # Get closest ANSI color for RGB values
          #
          # @author {https://aaronmallen.me Aaron Allen}
          # @since 0.1.0
          #
          # @api private
          #
          # @param red [Float] the red component (0-1)
          # @param green [Float] the green component (0-1)
          # @param blue [Float] the blue component (0-1)
          #
          # @return [Symbol] the closest ANSI color name
          # @rbs (Float red, Float green, Float blue) -> Symbol
          def closest_ansi_color(red, green, blue)
            Cache.fetch(:classifier_closest_ansi_color, [red, green, blue]) do
              return :black if dark?(red, green, blue)
              return :white if grayscale?(red, green, blue)
              return primary_color(red, green, blue) if primary?(red, green, blue)
              return secondary_color(red, green, blue) if secondary?(red, green, blue)

              :white
            end
          end

          # Determine if a color is dark
          #
          # @author {https://aaronmallen.me Aaron Allen}
          # @since 0.1.0
          #
          # @api private
          #
          # @param red [Float] the red component (0-1)
          # @param green [Float] the green component (0-1)
          # @param blue [Float] the blue component (0-1)
          #
          # @return [Boolean] true if color is dark
          # @rbs (Float red, Float green, Float blue) -> bool
          def dark?(red, green, blue)
            Cache.fetch(:classifier_dark_predicate, [red, green, blue]) do
              [red, green, blue].max < 0.3
            end
          end

          # Determine if a color is grayscale
          #
          # @author {https://aaronmallen.me Aaron Allen}
          # @since 0.1.0
          #
          # @api private
          #
          # @param red [Float] the red component (0-1)
          # @param green [Float] the green component (0-1)
          # @param blue [Float] the blue component (0-1)
          #
          # @return [Boolean] true if color is grayscale
          # @rbs (Float red, Float green, Float blue) -> bool
          def grayscale?(red, green, blue)
            Cache.fetch(:classifier_grayscale_predicate, [red, green, blue]) do
              red == green && green == blue
            end
          end

          # Determine if RGB values represent a primary color
          #
          # @author {https://aaronmallen.me Aaron Allen}
          # @since 0.1.0
          #
          # @api private
          #
          # @param red [Float] the red component (0-1)
          # @param green [Float] the green component (0-1)
          # @param blue [Float] the blue component (0-1)
          #
          # @return [Boolean] true if color is primary
          # @rbs (Float red, Float green, Float blue) -> bool
          def primary?(red, green, blue)
            Cache.fetch(:classifier_primary_predicate, [red, green, blue]) do
              max = [red, green, blue].max
              mid = [red, green, blue].sort[1]
              (max - mid) > 0.3
            end
          end

          # Get the closest primary color
          #
          # @author {https://aaronmallen.me Aaron Allen}
          # @since 0.1.0
          #
          # @api private
          #
          # @param red [Float] the red component (0-1)
          # @param green [Float] the green component (0-1)
          # @param blue [Float] the blue component (0-1)
          #
          # @return [Symbol] the primary color name
          # @rbs (Float red, Float green, Float blue) -> Symbol
          def primary_color(red, green, blue)
            Cache.fetch(:classifier_primary_color, [red, green, blue]) do
              max = [red, green, blue].max
              case max
              when red then :red
              when green then :green
              else :blue
              end
            end
          end

          # Determine if RGB values represent a secondary color
          #
          # @author {https://aaronmallen.me Aaron Allen}
          # @since 0.1.0
          #
          # @api private
          #
          # @param red [Float] the red component (0-1)
          # @param green [Float] the green component (0-1)
          # @param blue [Float] the blue component (0-1)
          #
          # @return [Boolean] true if color is secondary
          # @rbs (Float red, Float green, Float blue) -> bool
          def secondary?(red, green, blue)
            Cache.fetch(:classifier_secondary_predicate, [red, green, blue]) do
              return true if yellow?(red, green, blue)
              return true if magenta?(red, green, blue)
              return true if cyan?(red, green, blue)

              false
            end
          end

          # Get the closest secondary color
          #
          # @author {https://aaronmallen.me Aaron Allen}
          # @since 0.1.0
          #
          # @api private
          #
          # @param red [Float] the red component (0-1)
          # @param green [Float] the green component (0-1)
          # @param blue [Float] the blue component (0-1)
          #
          # @return [Symbol] the secondary color name
          # @rbs (Float red, Float green, Float blue) -> Symbol
          def secondary_color(red, green, blue)
            Cache.fetch(:classifier_secondary_color, [red, green, blue]) do
              return :yellow if yellow?(red, green, blue)
              return :magenta if magenta?(red, green, blue)
              return :cyan if cyan?(red, green, blue)

              :white
            end
          end

          private

          # Check if RGB values represent cyan
          #
          # @author {https://aaronmallen.me Aaron Allen}
          # @since 0.1.0
          #
          # @api private
          #
          # @param red [Float] the red component (0-1)
          # @param green [Float] the green component (0-1)
          # @param blue [Float] the blue component (0-1)
          #
          # @return [Boolean] true if color is cyan
          # @rbs (Float red, Float green, Float blue) -> bool
          def cyan?(red, green, blue)
            green > red && blue > red
          end

          # Check if RGB values represent magenta
          #
          # @author {https://aaronmallen.me Aaron Allen}
          # @since 0.1.0
          #
          # @api private
          #
          # @param red [Float] the red component (0-1)
          # @param green [Float] the green component (0-1)
          # @param blue [Float] the blue component (0-1)
          #
          # @return [Boolean] true if color is magenta
          # @rbs (Float red, Float green, Float blue) -> bool
          def magenta?(red, green, blue)
            red > green && blue > green
          end

          # Check if RGB values represent yellow
          #
          # @author {https://aaronmallen.me Aaron Allen}
          # @since 0.1.0
          #
          # @api private
          #
          # @param red [Float] the red component (0-1)
          # @param green [Float] the green component (0-1)
          # @param blue [Float] the blue component (0-1)
          #
          # @return [Boolean] true if color is yellow
          # @rbs (Float red, Float green, Float blue) -> bool
          def yellow?(red, green, blue)
            red > blue && green > blue && (red - green).abs < 0.3
          end
        end
      end
    end
  end
end
