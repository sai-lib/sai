# frozen_string_literal: true

module Sai
  module Terminal
    # Represents different color support levels for terminal interfaces
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    module ColorMode
      # The terminal does not support color output
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Integer] the color mode
      NO_COLOR = 0 #: Integer

      # The terminal supports 8 colors (3-bit)
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Integer] the color mode
      BASIC = 1 #: Integer

      # The terminal supports 16 colors (4-bit)
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Integer] the color mode
      ANSI = 2 #: Integer

      # The terminal supports 256 colors (8-bit)
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Integer] the color mode
      BIT8 = 3 #: Integer

      # The terminal supports 16 million colors (24-bit)
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Integer] the color mode
      TRUE_COLOR = 4 #: Integer
    end
  end
end
