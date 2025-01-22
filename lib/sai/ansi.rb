# frozen_string_literal: true

module Sai
  # ANSI constants for encoding text styles and colors
  #
  # @author {https://aaronmallen.me Aaron Allen}
  # @since 0.1.0
  #
  # @api private
  module ANSI
    # ANSI color code mappings
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api private
    #
    # @return [Hash{Symbol => Integer}] the color codes
    COLOR_CODES = {
      black: 0,
      red: 1,
      green: 2,
      yellow: 3,
      blue: 4,
      magenta: 5,
      cyan: 6,
      white: 7
    }.freeze # Hash[Symbol, Integer]

    # ANSI escape sequence for resetting text formatting
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api private
    #
    # @return [String] the ANSI escape sequence
    RESET = "\e[0m" # String

    # Standard ANSI style codes
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api private
    #
    # @return [Hash{Symbol => Integer}] the style codes
    STYLES = {
      bold: 1,
      dim: 2,
      italic: 3,
      underline: 4,
      blink: 5,
      rapid_blink: 6,
      reverse: 7,
      conceal: 8,
      strike: 9,
      normal_intensity: 22,
      no_italic: 23,
      no_underline: 24,
      no_blink: 25,
      no_reverse: 27,
      no_conceal: 28,
      no_strike: 29
    }.freeze # Hash[Symbol, Integer]
  end
end
