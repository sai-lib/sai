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

    # Standard ANSI color names and their RGB values
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api private
    #
    # @return [Hash{Symbol => Array<Integer>}] the color names and RGB values
    COLOR_NAMES = {
      black: [0, 0, 0],
      red: [205, 0, 0],
      green: [0, 205, 0],
      yellow: [205, 205, 0],
      blue: [0, 0, 238],
      magenta: [205, 0, 205],
      cyan: [0, 205, 205],
      white: [229, 229, 229],
      bright_black: [127, 127, 127],
      bright_red: [255, 0, 0],
      bright_green: [0, 255, 0],
      bright_yellow: [255, 255, 0],
      bright_blue: [92, 92, 255],
      bright_magenta: [255, 0, 255],
      bright_cyan: [0, 255, 255],
      bright_white: [255, 255, 255]
    }.freeze # Hash[Symbol, Array[Integer]]

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
