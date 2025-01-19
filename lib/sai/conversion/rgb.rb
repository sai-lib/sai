# frozen_string_literal: true

require 'sai/ansi'

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
          return :black if dark?(red, green, blue)
          return :white if grayscale?(red, green, blue)
          return primary_color(red, green, blue) if primary?(red, green, blue)
          return secondary_color(red, green, blue) if secondary?(red, green, blue)

          :white
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
          [red, green, blue].max < 0.3
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
          red == green && green == blue
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
          case color
          when Array then validate_rgb(color)
          when /^#?([A-Fa-f0-9]{6})$/
            hex_to_rgb(
              Regexp.last_match(1) #: String
            )
          when String, Symbol then named_to_rgb(color.to_s.downcase)
          else
            raise ArgumentError, "Invalid color format: #{color}"
          end
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

        # Convert a hex string to RGB values
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @param hex [String] the hex color code
        #
        # @return [Array<Integer>] the RGB components
        # @rbs (String hex) -> Array[Integer]
        def hex_to_rgb(hex)
          hex = hex.delete_prefix('#') #: String
          [
            hex[0..1].to_i(16), # steep:ignore UnexpectedPositionalArgument
            hex[2..3].to_i(16), # steep:ignore UnexpectedPositionalArgument
            hex[4..5].to_i(16) # steep:ignore UnexpectedPositionalArgument
          ]
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

        # Convert a named color to RGB values
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @param color_name [String] the color name
        #
        # @raise [ArgumentError] if the color name is unknown
        # @return [Array<Integer>] the RGB components
        # @rbs (String color_name) -> Array[Integer]
        def named_to_rgb(color_name)
          ANSI::COLOR_NAMES.fetch(color_name.to_sym) do
            raise ArgumentError, "Unknown color name: #{color_name}"
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
          max = [red, green, blue].max
          mid = [red, green, blue].sort[1]
          (max - mid) > 0.3
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
          max = [red, green, blue].max
          case max
          when red then :red
          when green then :green
          else :blue
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
          return true if yellow?(red, green, blue)
          return true if magenta?(red, green, blue)
          return true if cyan?(red, green, blue)

          false
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
          return :yellow if yellow?(red, green, blue)
          return :magenta if magenta?(red, green, blue)
          return :cyan if cyan?(red, green, blue)

          :white
        end

        # Validate RGB values
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @param color [Array<Integer>] the RGB components to validate
        # @return [Array<Integer>] the validated RGB components
        # @raise [ArgumentError] if the RGB values are invalid
        # @rbs (Array[Integer] color) -> Array[Integer]
        def validate_rgb(color)
          unless color.size == 3 && color.all? { |c| c.is_a?(Integer) && c.between?(0, 255) }
            raise ArgumentError, "Invalid RGB values: #{color}"
          end

          color
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
