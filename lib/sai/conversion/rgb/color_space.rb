# frozen_string_literal: true

require 'sai/ansi'

module Sai
  module Conversion
    module RGB
      # Convert colors between different color space formats
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      module ColorSpace
        class << self
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
            hue_sector = (hue / 60.0).floor.to_i
            hue_remainder = (hue / 60.0) - hue_sector

            components = calculate_hsv_components(value, saturation, hue_remainder)
            primary, secondary, tertiary = *components

            return [0, 0, 0] unless primary && secondary && tertiary

            rgb = select_rgb_values(hue_sector, value, primary, secondary, tertiary)
            normalize_rgb(rgb)
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
                Regexp.last_match(1) # steep:ignore ArgumentTypeMismatch
              )
            when String, Symbol then named_to_rgb(color.to_s.downcase)
            else
              raise ArgumentError, "Invalid color format: #{color}"
            end
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

            [primary, secondary, tertiary]
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
            hex = hex.delete_prefix('#')
            [
              hex[0..1].to_i(16), # steep:ignore UnexpectedPositionalArgument
              hex[2..3].to_i(16), # steep:ignore UnexpectedPositionalArgument
              hex[4..5].to_i(16)  # steep:ignore UnexpectedPositionalArgument
            ]
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
        end
      end
    end
  end
end
