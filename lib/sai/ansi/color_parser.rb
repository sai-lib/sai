# frozen_string_literal: true

module Sai
  module ANSI
    # Handles parsing of ANSI color codes
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.3.1
    #
    # @api private
    class ColorParser
      # The current segment being processed
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.1
      #
      # @api private
      #
      # @return [Hash] the current segment being processed
      attr_reader :segment #: Hash[Symbol, untyped]

      # Initialize a new instance of ColorParser
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.1
      #
      # @api private
      #
      # @param segment [Hash] the segment to update
      #
      # @return [ColorParser] the new instance of ColorParser
      # @rbs (Hash[Symbol, untyped] segment) -> void
      def initialize(segment)
        @segment = segment
      end

      # Parse a 256-color code
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.1
      #
      # @api private
      #
      # @param codes [Array<Integer>] array of color codes
      # @param index [Integer] current position in array
      #
      # @return [Integer] new position in array
      # @rbs (Array[Integer] codes, Integer index) -> Integer
      def parse256(codes, index)
        base_code = codes[index]
        color_number = codes[index + 2]

        if base_code == 38
          segment[:foreground] = "38;5;#{color_number}"
        else
          segment[:background] = "48;5;#{color_number}"
        end

        index + 3
      end

      # Parse a 24-bit color code
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.1
      #
      # @api private
      #
      # @param codes [Array<Integer>] array of color codes
      # @param index [Integer] current position in array
      #
      # @return [Integer] new position in array
      # @rbs (Array[Integer] codes, Integer index) -> Integer
      def parse_24bit(codes, index)
        base_code = codes[index]
        r = codes[index + 2]
        g = codes[index + 3]
        b = codes[index + 4]

        if base_code == 38
          segment[:foreground] = "38;2;#{r};#{g};#{b}"
        else
          segment[:background] = "48;2;#{r};#{g};#{b}"
        end

        index + 5
      end

      # Parse a basic color code
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.1
      #
      # @api private
      #
      # @param code [Integer] the color code
      #
      # @return [void]
      # @rbs (Integer code) -> void
      def parse_basic(code)
        if (30..37).cover?(code)
          segment[:foreground] = code.to_s
        else # 40..47
          segment[:background] = code.to_s
        end
      end
    end
  end
end
