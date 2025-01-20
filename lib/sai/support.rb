# frozen_string_literal: true

require 'sai/terminal/capabilities'
require 'sai/terminal/color_mode'

module Sai
  # Determine the color capabilities of the terminal
  #
  # @author {https://aaronmallen.me Aaron Allen}
  # @since 0.1.0
  #
  # @api public
  module Support
    class << self
      # Check if the terminal supports 256 colors (8-bit)
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.1.0
      #
      # @api public
      #
      # @example Check if the terminal supports 256 colors
      #   Sai.advanced? # => true
      #
      # @return [Boolean] `true` if the terminal supports 256 colors (8-bit), otherwise `false`
      # @rbs () -> bool
      def advanced?
        Terminal::Capabilities.detect_color_support >= Terminal::ColorMode::ADVANCED
      end
      alias color256? advanced?
      alias colour256? advanced?
      alias eight_bit? advanced?
      alias two_hundred_fifty_six_color? advanced?
      alias two_hundred_fifty_six_colour? advanced?

      # Check if the terminal supports ANSI colors (4-bit)
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.1.0
      #
      # @api public
      #
      # @example Check if the terminal supports ANSI colors
      #   Sai.ansi? # => true
      #
      # @return [Boolean] `true` if the terminal supports ANSI colors (4-bit), otherwise `false`
      # @rbs () -> bool
      def ansi?
        Terminal::Capabilities.detect_color_support >= Terminal::ColorMode::ANSI
      end
      alias color16? ansi?
      alias colour16? ansi?
      alias four_bit? ansi?
      alias sixteen_color? ansi?
      alias sixteen_colour? ansi?

      # Check if the terminal supports basic colors (3-bit)
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.1.0
      #
      # @api public
      #
      # @example Check if the terminal supports basic colors
      #   Sai.basic? # => true
      #
      # @return [Boolean] `true` if the terminal supports basic colors (3-bit), otherwise `false`
      # @rbs () -> bool
      def basic?
        Terminal::Capabilities.detect_color_support >= Terminal::ColorMode::BASIC
      end
      alias color8? basic?
      alias colour8? basic?
      alias eight_color? basic?
      alias eight_colour? basic?
      alias three_bit? basic?

      # Check if the terminal supports color output
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.1.0
      #
      # @api public
      #
      # @example Check if the terminal supports color
      #   Sai.color? # => true
      #
      # @return [Boolean] `true` if the terminal supports color output, otherwise `false`
      # @rbs () -> bool
      def color?
        Terminal::Capabilities.detect_color_support > Terminal::ColorMode::NO_COLOR
      end

      # Check if the terminal supports true color (24-bit)
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.1.0
      #
      # @api public
      #
      # @example Check if the terminal supports true color
      #   Sai.true_color? # => true
      #
      # @return [Boolean] `true` if the terminal supports true color (24-bit), otherwise `false`
      # @rbs () -> bool
      def true_color?
        Terminal::Capabilities.detect_color_support >= Terminal::ColorMode::TRUE_COLOR
      end
      alias color16m? true_color?
      alias colour16m? true_color?
      alias sixteen_million_color? true_color?
      alias sixteen_million_colour? true_color?
      alias twenty_for_bit? true_color?
    end
  end
end
