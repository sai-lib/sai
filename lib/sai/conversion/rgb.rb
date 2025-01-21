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
    module RGB # rubocop:disable Metrics/ModuleLength
      class << self # rubocop:disable Metrics/ClassLength
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

        # Darken an RGB color by a percentage
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since unreleased
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

          rgb = resolve(color)
          rgb.map { |c| [0, (c * (1 - amount)).round].max }
        end

        # Generate a gradient between two colors with a specified number of steps
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since unreleased
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

        # Interpolate between two colors to create a gradient step
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since unreleased
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

          start_rgb = resolve(start_color)
          end_rgb = resolve(end_color)

          start_rgb.zip(end_rgb).map do |values|
            start_val, end_val = values
            next 0 unless start_val && end_val # Handle potential nil values

            (start_val + ((end_val - start_val) * step)).round.clamp(0, 255)
          end
        end

        # Lighten an RGB color by a percentage
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since unreleased
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

          rgb = resolve(color)
          rgb.map { |c| [255, (c * (1 + amount)).round].min }
        end

        # Generate a rainbow gradient with a specified number of steps
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since unreleased
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
            hsv_to_rgb(hue, 1.0, 1.0)
          end
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

        # Calculate the intermediate HSV components
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since unreleased
        #
        # @api private
        #
        # @param value [Float] the value component
        # @param saturation [Float] the saturation component
        # @param hue_remainder [Float] the remainder of hue / 60
        #
        # @return [Array<Float>] the primary, secondary, and tertiary components
        # @rbs (Float value, Float saturation, Float hue_remainder) -> [Float, Float, Float]
        def calculate_hsv_components(value, saturation, hue_remainder)
          primary = value * (1 - saturation)
          secondary = value * (1 - (saturation * hue_remainder))
          tertiary = value * (1 - (saturation * (1 - hue_remainder)))

          [primary, secondary, tertiary] #: [Float, Float, Float]
        end

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

        # Convert HSV values to RGB
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since unreleased
        #
        # @api private
        #
        # @param hue [Float] the hue component (0-360)
        # @param saturation [Float] the saturation component (0-1)
        # @param value [Float] the value component (0-1)
        #
        # @return [Array<Integer>] the RGB values
        # @rbs (Float hue, Float saturation, Float value) -> Array[Integer]
        def hsv_to_rgb(hue, saturation, value)
          hue_sector = (hue / 60.0).floor.to_i # Explicitly convert to Integer
          hue_remainder = (hue / 60.0) - hue_sector

          components = calculate_hsv_components(value, saturation, hue_remainder)
          primary, secondary, tertiary = *components # Destructure with splat to handle potential nil

          # Ensure we have valid values before proceeding
          return [0, 0, 0] unless primary && secondary && tertiary

          rgb = select_rgb_values(hue_sector, value, primary, secondary, tertiary)
          normalize_rgb(rgb)
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

        # Convert RGB values from 0-1 range to 0-255 range
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since unreleased
        #
        # @api private
        #
        # @param rgb [Array<Float>] RGB values in 0-1 range
        #
        # @return [Array<Integer>] RGB values in 0-255 range
        # @rbs (Array[Float] rgb) -> Array[Integer]
        def normalize_rgb(rgb)
          rgb.map { |c| (c * 255).round.clamp(0, 255) }
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

        # Select RGB values based on the hue sector
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since unreleased
        #
        # @api private
        #
        # @param sector [Integer] the hue sector (0-5)
        # @param value [Float] the value component
        # @param primary [Float] primary component from HSV calculation
        # @param secondary [Float] secondary component from HSV calculation
        # @param tertiary [Float] tertiary component from HSV calculation
        #
        # @return [Array<Float>] the RGB values before normalization
        # @rbs (Integer sector, Float value, Float primary, Float secondary, Float tertiary) -> Array[Float]
        def select_rgb_values(sector, value, primary, secondary, tertiary)
          case sector % 6
          when 0 then [value, tertiary, primary]
          when 1 then [secondary, value, primary]
          when 2 then [primary, value, tertiary]
          when 3 then [primary, secondary, value]
          when 4 then [tertiary, primary, value]
          else [value, primary, secondary]
          end
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
