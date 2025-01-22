# frozen_string_literal: true

require 'sai/ansi'
require 'sai/ansi/color_parser'
require 'sai/ansi/style_parser'
require 'strscan'

module Sai
  module ANSI
    # Extract ANSI sequence information from a string
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.3.0
    #
    # @api private
    class SequenceProcessor
      # The pattern to extract ANSI sequences from a string
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.0
      #
      # @api private
      #
      # @return [Regexp] the pattern
      SEQUENCE_PATTERN = /\e\[([0-9;]*)m/ #: Regexp
      private_constant :SEQUENCE_PATTERN

      # Initialize a new instance of SequenceProcessor and parse the provided string
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.0
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
      # @since 0.3.0
      #
      # @api private
      #
      # @param string [String] the string to parse
      #
      # @return [SequenceProcessor] the new instance of SequenceProcessor
      # @rbs (String string) -> void
      def initialize(string)
        @scanner = StringScanner.new(string)
        @segments = []
        @current_segment = { text: +'', foreground: nil, background: nil, styles: [] }
        @encoded_pos = 0
        @stripped_pos = 0
        @color_parser = ColorParser.new(@current_segment)
        @style_parser = StyleParser.new(@current_segment)
      end

      # Parse a string and return a hash of segments
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.0
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

      # Applies the appropriate action for the provided ANSI sequence
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.0
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

      # Parse all numeric codes in the provided string, applying them in order (just like a real ANSI terminal)
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.0
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
      # @since 0.3.0
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
          @color_parser.parse_basic(code)
          index + 1
        when 38, 48
          parse_extended_color(codes_array, index)
        else
          @style_parser.parse(code)
          index + 1
        end
      end

      # Scans the string for ANSI sequences or individual characters
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.0
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
      # @since 0.3.0
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
      # @since 0.3.0
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
      # @since 0.3.0
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
      # @since 0.3.0
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
        when 5 then @color_parser.parse256(codes_array, index)
        when 2 then @color_parser.parse_24bit(codes_array, index)
        else index + 1
        end
      end

      # Resets the current segment to a fresh, blank state
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.0
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
