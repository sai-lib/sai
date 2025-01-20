# frozen_string_literal: true

require 'sai/ansi'
require 'strscan'

module Sai
  module ANSI
    # Extract ANSI sequence information from a string
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    class SequenceProcessor # rubocop:disable Metrics/ClassLength
      # The pattern to extract ANSI sequences from a string
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Regexp] the pattern
      SEQUENCE_PATTERN = /\e\[([0-9;]*)m/ #: Regexp
      private_constant :SEQUENCE_PATTERN

      # Matches the code portion of style sequences
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Regexp] the pattern
      STYLE_CODE_PATTERN = /(?:[1-9]|2[1-9])/ #: Regexp
      private_constant :STYLE_CODE_PATTERN

      # Initialize a new instance of SequenceProcessor and parse the provided string
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param string [String] the string to parse
      #
      # @return [Array<Hash{Symbol => Object}>] the segments
      # @rbs (String string) -> Array[Hash[Symbol, untyped]]
      def self.process(string)
        new(string).process
      end

      # Initialize a new instance of SequenceProcessor
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param string [String] the string to parse
      #
      # @return [SequenceProcessor] the new instance of SequenceProcessor
      # @rbs (String string) -> void
      def initialize(string)
        @scanner         = StringScanner.new(string)
        @segments        = [] #: Array[Hash[Symbol, untyped]]
        @current_segment = blank_segment
        @encoded_pos     = 0
        @stripped_pos    = 0
      end

      # Parse a string and return a hash of segments
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Array<Hash{Symbol => Object}>] the segments
      # @rbs () -> Array[Hash[Symbol, untyped]]
      def process
        consume_tokens
        finalize_segment_if_text!

        @segments
      end

      private

      # Applies 24-bit truecolor (e.g., 38;2;R;G;B or 48;2;R;G;B)
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param codes_array [Array<Integer>]
      # @param index [Integer]
      #
      # @return [Integer] the updated index (consumed 5 codes)
      # @rbs (Array[Integer] codes_array, Integer index) -> Integer
      def apply_24bit_color(codes_array, index)
        base_code = codes_array[index]
        r = codes_array[index + 2]
        g = codes_array[index + 3]
        b = codes_array[index + 4]

        if base_code == 38
          @current_segment[:foreground] = "38;2;#{r};#{g};#{b}"
        else
          @current_segment[:background] = "48;2;#{r};#{g};#{b}"
        end
        index + 5
      end

      # Applies 256-color mode (e.g., 38;5;160 or 48;5;21)
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param codes_array [Array<Integer>]
      # @param index [Integer]
      #
      # @return [Integer] the updated index (consumed 3 codes)
      # @rbs (Array[Integer] codes_array, Integer index) -> Integer
      def apply_256_color(codes_array, index)
        base_code = codes_array[index]
        color_number = codes_array[index + 2]
        if base_code == 38
          @current_segment[:foreground] = "38;5;#{color_number}"
        else
          @current_segment[:background] = "48;5;#{color_number}"
        end
        index + 3 # consumed 3 codes total
      end

      # Applies the appropriate action for the provided ANSI sequence
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param sequence [String] an ANSI sequence (e.g. "\e[31m", "\e[0m")
      #
      # @return [void]
      # @rbs (String sequence) -> void
      def apply_ansi_sequence(sequence)
        return reset_segment! if sequence == ANSI::RESET

        codes = sequence.match(SEQUENCE_PATTERN)&.[](1)
        return unless codes

        apply_codes(codes)
      end

      # Applies a basic color (FG or BG) in the range 30..37 (FG) or 40..47 (BG)
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param code [Integer] the numeric color code
      #
      # @return [void]
      # @rbs (Integer code) -> void
      def apply_basic_color(code)
        if (30..37).cover?(code)
          @current_segment[:foreground] = code.to_s
        else # 40..47
          @current_segment[:background] = code.to_s
        end
      end

      # Parse all numeric codes in the provided string, applying them in order (just like a real ANSI terminal)
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param codes_string [String] e.g. "38;5;160;48;5;21;1"
      #
      # @return [void]
      # @rbs (String codes_string) -> void
      def apply_codes(codes_string)
        codes_array = codes_string.split(';').map(&:to_i)
        i = 0
        i = apply_single_code(codes_array, i) while i < codes_array.size
      end

      # Applies a single code (or group) from the array. This might be:
      #  - 0 => reset
      #  - 30..37 => basic FG color
      #  - 40..47 => basic BG color
      #  - 38 or 48 => extended color sequence
      #  - otherwise => style code (bold, underline, etc.)
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param codes_array [Array<Integer>] the list of numeric codes
      # @param index [Integer] the current index
      #
      # @return [Integer] the updated index after consuming needed codes
      # @rbs (Array[Integer] codes_array, Integer index) -> Integer
      def apply_single_code(codes_array, index) # rubocop:disable Metrics/MethodLength
        code = codes_array[index]
        return index + 1 if code.nil?

        case code
        when 0
          reset_segment!
          index + 1
        when 30..37, 40..47
          apply_basic_color(code)
          index + 1
        when 38, 48
          parse_extended_color(codes_array, index)
        else
          apply_style_code(code)
          index + 1
        end
      end

      # Applies a single style code (e.g. 1=bold, 2=dim, 4=underline, etc.) if it matches
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param code [Integer] the numeric code to check
      #
      # @return [void]
      # @rbs (Integer code) -> void
      def apply_style_code(code)
        # If it matches the existing style pattern, add it to @current_segment[:styles]
        # Typically: 1..9, or 21..29, etc. (Your STYLE_CODE_PATTERN is /(?:[1-9]|2[1-9])/)
        return unless code.to_s.match?(STYLE_CODE_PATTERN)

        @current_segment[:styles] << code.to_s
      end

      # Creates and returns a fresh, blank segment
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Hash{Symbol => Object}] a new, empty segment
      # @rbs () -> Hash[Symbol, untyped]
      def blank_segment
        { text: +'', foreground: nil, background: nil, styles: [] }
      end

      # Scans the string for ANSI sequences or individual characters
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [void]
      # @rbs () -> void
      def consume_tokens
        handle_ansi_sequence || handle_character until @scanner.eos?
      end

      # Finalizes the current segment if any text is present, then resets it
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [void]
      # @rbs () -> void
      def finalize_segment_if_text!
        return if @current_segment[:text].empty?

        seg_len = @current_segment[:text].length
        segment = @current_segment.merge(
          encoded_start: @encoded_pos - seg_len,
          encoded_end: @encoded_pos,
          stripped_start: @stripped_pos - seg_len,
          stripped_end: @stripped_pos
        )

        @segments << segment
        reset_segment!
      end

      # Attempts to capture an ANSI sequence from the scanner If found, finalizes
      # the current text segment and applies the sequence
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Boolean] `true` if a sequence was found, `false` if otherwise
      # @rbs () -> bool
      def handle_ansi_sequence
        sequence = @scanner.scan(SEQUENCE_PATTERN)
        return false unless sequence

        finalize_segment_if_text!
        apply_ansi_sequence(sequence)
        @encoded_pos += sequence.length
        true
      end

      # Reads a single character from the scanner and appends it to the current segment
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [void]
      # @rbs () -> void
      def handle_character
        char = @scanner.getch
        @current_segment[:text] << char
        @encoded_pos  += 1
        @stripped_pos += 1
      end

      # Parse extended color codes from the array, e.g. 38;5;160 (256-color) or 38;2;R;G;B (24-bit),
      # and apply them to foreground or background
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param codes_array [Array<Integer>] the array of codes
      # @param index [Integer] the current position (where we saw 38 or 48)
      #
      # @return [Integer] the updated position in the codes array
      # @rbs (Array[Integer] codes_array, Integer index) -> Integer
      def parse_extended_color(codes_array, index)
        mode_code = codes_array[index + 1]

        return index + 1 unless mode_code

        case mode_code
        when 5
          apply_256_color(codes_array, index)
        when 2
          apply_24bit_color(codes_array, index)
        else
          index + 1
        end
      end

      # Resets the current segment to a fresh, blank state
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [void]
      # @rbs () -> void
      def reset_segment!
        @current_segment[:text] = +''
        @current_segment[:foreground] = nil
        @current_segment[:background] = nil
        @current_segment[:styles] = []
      end
    end
  end
end
