# frozen_string_literal: true

require 'sai/terminal/color_mode'

module Sai
  # Determine the color capabilities of the terminal
  #
  # @author {https://aaronmallen.me Aaron Allen}
  # @since 0.1.0
  #
  # @api public
  class Support
    # Initialize a new instance of Support
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api private
    #
    # @param color_mode [Integer] the color mode
    #
    # @return [Support] the new instance of support
    # @rbs (Integer color_mode) -> void
    def initialize(color_mode)
      @color_mode = color_mode
    end

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
      @color_mode >= Terminal::ColorMode::ANSI
    end
    alias bit4? ansi?
    alias four_bit? ansi?

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
      @color_mode >= Terminal::ColorMode::BASIC
    end
    alias bit3? basic?
    alias three_bit? basic?

    # Check if the terminal supports 256 colors (8-bit)
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api public
    #
    # @example Check if the terminal supports 256 colors
    #   Sai.bit8? # => true
    #
    # @return [Boolean] `true` if the terminal supports 256 colors (8-bit), otherwise `false`
    # @rbs () -> bool
    def bit8?
      @color_mode >= Terminal::ColorMode::BIT8
    end
    alias eight_bit? bit8?

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
      @color_mode > Terminal::ColorMode::NO_COLOR
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
      @color_mode >= Terminal::ColorMode::TRUE_COLOR
    end
    alias bit24? true_color?
    alias twenty_four_bit? true_color?
  end
end
