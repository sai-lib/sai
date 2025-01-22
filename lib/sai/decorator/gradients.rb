# frozen_string_literal: true

require 'sai/ansi/sequenced_string'
require 'sai/conversion/rgb'

module Sai
  class Decorator
    # Color gradient methods for the {Decorator} class
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @abstract This module is meant to be included in the {Decorator} class to provide color gradient methods
    # @api private
    module Gradients
      # Build a foreground gradient between two colors for text decoration
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api public
      #
      # @example Create a foreground gradient from red to blue
      #   decorator.gradient(:red, :blue, 10).decorate('Hello, World!')
      #   #=> "\e[38;2;255;0;0mH\e[0m\e[38;2;204;0;51me\e[0m..."
      #
      # @param start_color [Array<Integer>, String, Symbol] the starting color
      # @param end_color [Array<Integer>, String, Symbol] the ending color
      # @param steps [Integer] the number of gradient steps (minimum 2)
      #
      # @raise [ArgumentError] if steps is less than 2
      # @return [Decorator] a new instance of Decorator with foreground gradient colors
      # @rbs (
      #   Array[Integer] | String | Symbol start_color,
      #   Array[Integer] | String | Symbol end_color,
      #   Integer steps
      #   ) -> Decorator
      def gradient(start_color, end_color, steps)
        colors = Conversion::RGB.gradient(start_color, end_color, steps)
        dup.tap { |duped| duped.instance_variable_set(:@foreground_sequence, colors) } #: Decorator
      end

      # Build a background gradient between two colors for text decoration
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api public
      #
      # @example Create a background gradient from red to blue
      #   decorator.on_gradient(:red, :blue, 10).decorate('Hello, World!')
      #   #=> "\e[48;2;255;0;0mH\e[0m\e[48;2;204;0;51me\e[0m..."
      #
      # @param start_color [Array<Integer>, String, Symbol] the starting color
      # @param end_color [Array<Integer>, String, Symbol] the ending color
      # @param steps [Integer] the number of gradient steps (minimum 2)
      #
      # @raise [ArgumentError] if steps is less than 2
      # @return [Decorator] a new instance of Decorator with background gradient colors
      # @rbs (
      #   Array[Integer] | String | Symbol start_color,
      #   Array[Integer] | String | Symbol end_color,
      #   Integer steps
      #   ) -> Decorator
      def on_gradient(start_color, end_color, steps)
        colors = Conversion::RGB.gradient(start_color, end_color, steps)
        dup.tap { |duped| duped.instance_variable_set(:@background_sequence, colors) } #: Decorator
      end

      # Build a background rainbow gradient for text decoration
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api public
      #
      # @example Create a rainbow background gradient
      #   decorator.on_rainbow(6).decorate('Hello, World!')
      #   #=> "\e[48;2;255;0;0mH\e[0m\e[48;2;255;255;0me\e[0m..."
      #
      # @param steps [Integer] the number of colors to generate (minimum 2)
      #
      # @raise [ArgumentError] if steps is less than 2
      # @return [Decorator] a new instance of Decorator with background rainbow colors
      # @rbs (Integer steps) -> Decorator
      def on_rainbow(steps)
        colors = Conversion::RGB.rainbow_gradient(steps)
        dup.tap { |duped| duped.instance_variable_set(:@background_sequence, colors) } #: Decorator
      end

      # Build a foreground rainbow gradient for text decoration
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api public
      #
      # @example Create a rainbow text gradient
      #   decorator.rainbow(6).decorate('Hello, World!')
      #   #=> "\e[38;2;255;0;0mH\e[0m\e[38;2;255;255;0me\e[0m..."
      #
      # @param steps [Integer] the number of colors to generate (minimum 2)
      #
      # @raise [ArgumentError] if steps is less than 2
      # @return [Decorator] a new instance of Decorator with foreground rainbow colors
      # @rbs (Integer steps) -> Decorator
      def rainbow(steps)
        colors = Conversion::RGB.rainbow_gradient(steps)
        dup.tap { |duped| duped.instance_variable_set(:@foreground_sequence, colors) } #: Decorator
      end

      private

      # Adjust number of colors to match text length
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param colors [Array<Array<Integer>>] original color sequence
      # @param text_length [Integer] desired number of colors
      #
      # @return [Array<Array<Integer>>] adjusted color sequence
      # @rbs (Array[Array[Integer]] colors, Integer text_length) -> Array[Array[Integer]]
      def adjust_colors_to_text_length(colors, text_length)
        return colors if colors.length == text_length
        return stretch_colors(colors, text_length) if colors.length < text_length

        shrink_colors(colors, text_length)
      end

      # Apply color sequence gradients to text
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param text [String] the text to apply the gradient to
      #
      # @return [ANSI::SequencedString] the text with gradient applied
      # @rbs (String text) -> ANSI::SequencedString
      def apply_sequence_gradient(text)
        # @type self: Decorator
        return ANSI::SequencedString.new(text) unless should_decorate?

        chars = text.chars
        adjusted_colors = prepare_color_sequences(chars.length)
        gradient_text = build_gradient_text(chars, adjusted_colors)

        ANSI::SequencedString.new(gradient_text.join)
      end

      # Build color sequences for a single character
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param colors [Hash] color sequences for foreground and background
      # @param index [Integer] character position
      #
      # @return [Array<String>] ANSI sequences for the character
      # @rbs (Hash[Symbol, Array[Array[Integer]]] colors, Integer index) -> Array[String]
      def build_color_sequences(colors, index)
        # @type self: Decorator
        sequences = []
        sequences << get_foreground_sequence(colors[:foreground], index) if colors[:foreground]
        sequences << get_background_sequence(colors[:background], index) if colors[:background]
        sequences += style_sequences
        sequences.compact
      end

      # Build gradient text from characters and color sequences
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param chars [Array<String>] text characters
      # @param colors [Hash] color sequences for foreground and background
      #
      # @return [Array<String>] colored characters
      # @rbs (Array[String] chars, Hash[Symbol, Array[Array[Integer]]] colors) -> Array[String]
      def build_gradient_text(chars, colors)
        chars.each_with_index.map do |char, i|
          next char if char == ' '

          sequences = build_color_sequences(colors, i)
          "#{sequences.join}#{char}#{ANSI::RESET}"
        end
      end

      # Calculate indices and progress for color interpolation
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param position [Integer] current position in sequence
      # @param step_size [Float] size of each step
      # @param max_index [Integer] maximum index allowed
      #
      # @return [Hash] interpolation indices and progress
      # @rbs (Integer position, Float step_size, Integer max_index) -> Hash[Symbol, Integer | Float]
      def calculate_interpolation_indices(position, step_size, max_index)
        position_in_sequence = position * step_size
        lower = position_in_sequence.floor
        upper = [lower + 1, max_index - 1].min
        progress = position_in_sequence - lower

        { lower: lower, upper: upper, progress: progress }
      end

      # Get background sequence for a character
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param colors [Array<Array<Integer>>, nil] background color sequence
      # @param index [Integer] character position
      #
      # @return [String, nil] ANSI sequence for background
      # @rbs (Array[Array[Integer]]? colors, Integer index) -> String?
      def get_background_sequence(colors, index)
        if colors
          Conversion::ColorSequence.resolve(colors[index], @mode, :background)
        elsif @background_sequence
          Conversion::ColorSequence.resolve(@background_sequence[index], @mode, :background)
        end
      end

      # Get foreground sequence for a character
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param colors [Array<Array<Integer>>, nil] foreground color sequence
      # @param index [Integer] character position
      #
      # @return [String, nil] ANSI sequence for foreground
      # @rbs (Array[Array[Integer]]? colors, Integer index) -> String?
      def get_foreground_sequence(colors, index)
        if colors
          Conversion::ColorSequence.resolve(colors[index], @mode)
        elsif @foreground_sequence
          Conversion::ColorSequence.resolve(@foreground_sequence[index], @mode)
        end
      end

      # Interpolate between two colors in a sequence
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param colors [Array<Array<Integer>>] color sequence
      # @param indices [Hash] interpolation indices and progress
      #
      # @return [Array<Integer>] interpolated color
      # @rbs (Array[Array[Integer]] colors, Hash[Symbol, Integer | Float]) -> Array[Integer]
      def interpolate_sequence_colors(colors, indices)
        lower_index = indices[:lower].to_i
        upper_index = indices[:upper].to_i
        progress = indices[:progress].to_f

        color1 = colors[lower_index]
        color2 = colors[upper_index]

        # Add nil guards
        return [0, 0, 0] unless color1 && color2

        color1.zip(color2).map do |c1, c2|
          next 0 unless c1 && c2 # Add nil guard for individual components

          (c1 + ((c2 - c1) * progress)).round
        end
      end

      # Prepare foreground and background color sequences for text
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param text_length [Integer] length of text to color
      #
      # @return [Hash] adjusted color sequences
      # @rbs (Integer text_length) -> Hash[Symbol, Array[Array[Integer]]]
      def prepare_color_sequences(text_length)
        sequences = {}
        sequences[:foreground] = prepare_sequence(@foreground_sequence, text_length) if @foreground_sequence
        sequences[:background] = prepare_sequence(@background_sequence, text_length) if @background_sequence
        sequences
      end

      # Prepare a single color sequence
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param sequence [Array<Array<Integer>>, nil] color sequence to prepare
      # @param text_length [Integer] length of text to color
      #
      # @return [Array<Array<Integer>>, nil] adjusted color sequence
      # @rbs (Array[Array[Integer]]? sequence, Integer text_length) -> Array[Array[Integer]]?
      def prepare_sequence(sequence, text_length)
        sequence && adjust_colors_to_text_length(sequence, text_length)
      end

      # Shrink a color sequence to fit desired length
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param colors [Array<Array<Integer>>] original color sequence
      # @param target_length [Integer] desired number of colors
      #
      # @return [Array<Array<Integer>>] shrunk color sequence
      # @rbs (Array[Array[Integer]] colors, Integer target_length) -> Array[Array[Integer]]
      def shrink_colors(colors, target_length)
        step_size = (target_length - 1).to_f / (colors.length - 1)
        indices = (0...colors.length).select { |i| (i * step_size).round < target_length }
        indices.map { |i| colors[i] }
      end

      # Stretch a color sequence to fit desired length
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param colors [Array<Array<Integer>>] original color sequence
      # @param target_length [Integer] desired number of colors
      #
      # @return [Array<Array<Integer>>] stretched color sequence
      # @rbs (Array[Array[Integer]] colors, Integer target_length) -> Array[Array[Integer]]
      def stretch_colors(colors, target_length)
        step_size = (colors.length - 1).to_f / (target_length - 1)

        (0...target_length).map do |i|
          indices = calculate_interpolation_indices(i, step_size, colors.length)
          interpolate_sequence_colors(colors, indices)
        end
      end
    end
  end
end
