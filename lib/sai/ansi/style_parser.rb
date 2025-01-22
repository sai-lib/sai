# frozen_string_literal: true

module Sai
  module ANSI
    # Handles parsing of ANSI style codes
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    class StyleParser
      # Matches the code portion of style sequences
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Regexp] the pattern
      STYLE_CODE_PATTERN = /^(?:[1-9]|2[1-9])$/ #: Regexp
      private_constant :STYLE_CODE_PATTERN

      # The current segment being processed
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Hash] the current segment being processed
      attr_reader :segment #: Hash[Symbol, untyped]

      # Initialize a new instance of StyleParser
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param segment [Hash] the segment to update
      #
      # @return [StyleParser] the new instance of StyleParser
      # @rbs (Hash[Symbol, untyped] segment) -> void
      def initialize(segment)
        @segment = segment
      end

      # Parse a style code
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param code [Integer] the style code
      #
      # @return [void]
      # @rbs (Integer code) -> void
      def parse(code)
        return unless code.to_s.match?(STYLE_CODE_PATTERN)

        segment[:styles] << code.to_s
      end
    end
  end
end
