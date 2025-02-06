# frozen_string_literal: true

require 'sai/support'

module Sai
  # Color mode selection methods
  #
  # @author {https://aaronmallen.me Aaron Allen}
  # @since 0.2.0
  #
  # @api public
  module ModeSelector
    # No color
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @return [Integer] the color mode
    NO_COLOR = 0 #: Integer

    # 8 colors (3-bit)
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @return [Integer] the color mode
    THREE_BIT = 1 #: Integer

    # 16 colors (4-bit)
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @return [Integer] the color mode
    FOUR_BIT = 2 #: Integer

    # 256 colors (8-bit)
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @return [Integer] the color mode
    EIGHT_BIT = 3 #: Integer

    # True color (24-bit)
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @return [Integer] the color mode
    TWENTY_FOUR_BIT = 4 #: Integer

    class << self
      # Set the color mode based on the current Terminal's capabilities
      #
      # This is the default color mode for {Sai}
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.2.0
      #
      # @api public
      #
      # @example With 24-bit color support enabled
      #   ENV['COLORTERM'] #=> 'truecolor'
      #   Sai.node.auto    #=> 4
      #
      # @example With only 8-bit color support enabled
      #   ENV['COLORTERM'] #=> nil
      #   ENV['TERM']      #=> 'xterm-256color'
      #   Sai.mode.auto    #=> 3
      #
      # @example With only 4-bit color support
      #   ENV['NO_COLOR'] #=> nil
      #   ENV['TERM']     #=> 'ansi'
      #   Sai.mode.auto   #=> 2
      #
      # @example With only 3-bit color support
      #   ENV['TERM']     #=> nil
      #   ENV['NO_COLOR'] #=> nil
      #   Sai.mode.auto   #=> 1
      #
      # @example With color support disabled
      #   ENV['NO_COLOR'] #=> 'true'
      #   Sai.mode.auto   #=> 0
      #
      # @return [Integer] the color mode
      # @rbs () -> Integer
      def auto
        supported_color_mode
      end
      alias color16m_auto auto
      alias colour16m_auto auto
      alias enabled auto
      alias sixteen_million_color_auto auto
      alias sixteen_million_colour_auto auto
      alias twenty_four_bit_auto auto

      # Set the color mode to 256 color (8-bit) mode
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.2.0
      #
      # @api public
      #
      # @example
      #   Sai.mode.advanced  #=> 3
      #   Sai.mode.eight_bit #=> 3
      #   Sai.mode.color256  #=> 3
      #
      # @return [Integer] the color mode
      # @rbs () -> Integer
      def eight_bit
        EIGHT_BIT
      end
      alias advanced eight_bit
      alias color256 eight_bit
      alias colour256 eight_bit
      alias two_hundred_fifty_six_color eight_bit
      alias two_hundred_fifty_six_colour eight_bit

      # Automatically set the color mode to advanced (8-bit) or lower
      #
      # Sets the terminal color mode to advanced (8-bit) support, which provides 256 colors
      # The mode will automatically downgrade to 4-bit, 3-bit, or NO_COLOR if the terminal doesn't support
      # advanced colors
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.2.0
      #
      # @api public
      #
      # @example With color support enabled
      #   ENV['COLORTERM']        #=> nil
      #   ENV['TERM']             #=> 'xterm-256color'
      #   Sai.mode.advanced_auto  #=> 3
      #   Sai.mode.eight_bit_auto #=> 3
      #   Sai.mode.color256_auto  #=> 3
      #
      # @example With only 4-bit color support
      #   ENV['NO_COLOR']         #=> nil
      #   ENV['TERM']             #=> 'ansi'
      #   Sai.mode.advanced_auto  #=> 2
      #   Sai.mode.eight_bit_auto #=> 2
      #   Sai.mode.color256_auto  #=> 2
      #
      # @example With only 3-bit color support
      #   ENV['TERM']             #=> nil
      #   ENV['NO_COLOR']         #=> nil
      #   Sai.mode.advanced_auto  #=> 1
      #   Sai.mode.eight_bit_auto #=> 1
      #   Sai.mode.color256_auto  #=> 1
      #
      # @example With color support disabled
      #   ENV['NO_COLOR']         #=> 'true'
      #   Sai.mode.advanced_auto  #=> 0
      #   Sai.mode.eight_bit_auto #=> 0
      #   Sai.mode.color256_auto  #=> 0
      #
      # @return [Integer] the color mode
      # @rbs () -> Integer
      def eight_bit_auto
        [supported_color_mode, EIGHT_BIT].min
      end
      alias advanced_auto eight_bit_auto
      alias color256_auto eight_bit_auto
      alias colour256_auto eight_bit_auto
      alias two_hundred_fifty_six_color_auto eight_bit_auto
      alias two_hundred_fifty_six_colour_auto eight_bit_auto

      # Set the color mode to 16 color (4-bit) mode
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.2.0
      #
      # @api public
      #
      # @example
      #   Sai.mode.ansi     #=> 2
      #   Sai.mode.color16 #=> 2
      #   Sai.mode.four_bit #=> 2
      #
      # @return [Integer] the color mode
      # @rbs () -> Integer
      def four_bit
        FOUR_BIT
      end
      alias ansi four_bit
      alias color16 four_bit
      alias colour16 four_bit
      alias sixteen_color four_bit
      alias sixteen_colour four_bit

      # Automatically set the color mode to ansi (4-bit) or lower
      #
      # Sets the terminal color mode to ansi (4-bit) support, which provides 8 colors
      # The mode will automatically downgrade to 3-bit or NO_COLOR if the terminal doesn't support
      # ansi colors
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.2.0
      #
      # @api public
      #
      # @example With color support enabled
      #   ENV['NO_COLOR'] #=> nil
      #   ENV['TERM'] #=> 'ansi'
      #   Sai.mode.ansi_auto     #=> 2
      #   Sai.mode.four_bit_auto #=> 2
      #   Sai.mode.color16_auto  #=> 2
      #
      # @example With only 3-bit color support
      #   ENV['TERM']             #=> nil
      #   ENV['NO_COLOR']         #=> nil
      #   Sai.mode.ansi_auto      #=> 1
      #   Sai.mode.four_bit_auto  #=> 1
      #   Sai.mode.color16_auto   #=> 1
      #
      # @example With color support disabled
      #   ENV['NO_COLOR']         #=> 'true'
      #   Sai.mode.ansi_auto      #=> 0
      #   Sai.mode.four_bit_auto  #=> 0
      #   Sai.mode.color16_auto   #=> 0
      #
      # @return [Integer] the color mode
      # @rbs () -> Integer
      def four_bit_auto
        [supported_color_mode, FOUR_BIT].min
      end
      alias ansi_auto four_bit_auto
      alias color16_auto four_bit_auto
      alias colour16_auto four_bit_auto
      alias sixteen_color_auto four_bit_auto
      alias sixteen_colour_auto four_bit_auto

      # Set the color mode to disable all color and styling
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.2.0
      #
      # @api public
      #
      # @example
      #   Sai.mode.no_color #=> 0
      #   Sai.mode.disabled #=> 0
      #   Sai.mode.mono     #=> 0
      #
      # @return [Integer] the color mode
      # @rbs () -> Integer
      def no_color
        NO_COLOR
      end
      alias disabled no_color
      alias mono no_color
      alias no_colour no_color

      # Set the color mode to 8 color (3-bit) mode
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.2.0
      #
      # @api public
      #
      # @example
      #   Sai.mode.basic     #=> 1
      #   Sai.mode.color8    #=> 1
      #   Sai.mode.three_bit #=> 1
      #
      # @return [Integer] the 4 color (3-bit) mode
      # @rbs () -> Integer
      def three_bit
        THREE_BIT
      end
      alias basic three_bit
      alias color8 three_bit
      alias colour8 three_bit
      alias eight_color three_bit
      alias eight_colour three_bit

      # Automatically set the color mode to basic (3-bit) or lower
      #
      # Sets the terminal color mode to basic (3-bit) support, which provides 8 colors
      # The mode will automatically downgrade to NO_COLOR if the terminal doesn't support
      # basic colors
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.2.0
      #
      # @api public
      #
      # @example With color support enabled
      #   ENV['NO_COLOR']         #=> nil
      #   Sai.mode.basic_auto     #=> 1
      #   Sai.mode.three_bit_auto #=> 1
      #   Sai.mode.color8_auto    #=> 1
      #
      # @example With color support disabled
      #   ENV['NO_COLOR']         #=> 'true'
      #   Sai.mode.basic_auto     #=> 0
      #   Sai.mode.three_bit_auto #=> 0
      #   Sai.mode.color8_auto    #=> 0
      #
      # @return [Integer] the color mode
      # @rbs () -> Integer
      def three_bit_auto
        [supported_color_mode, THREE_BIT].min
      end
      alias basic_auto three_bit_auto
      alias color8_auto three_bit_auto
      alias colour8_auto three_bit_auto
      alias eight_color_auto three_bit_auto
      alias eight_colour_auto three_bit_auto

      # Set the color mode to 16-million color (24-bit) mode
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.2.0
      #
      # @api public
      #
      # @example
      #   Sai.mode.true_color      #=> 4
      #   Sai.mode.twenty_four_bit #=> 4
      #   Sai.mode.color_16m       #=> 4
      #
      # @return [Integer] the color mode
      # @rbs () -> Integer
      def twenty_four_bit
        TWENTY_FOUR_BIT
      end
      alias color16m twenty_four_bit
      alias colour16m twenty_four_bit
      alias sixteen_million_color twenty_four_bit
      alias sixteen_million_colour twenty_four_bit
      alias true_color twenty_four_bit

      private

      # Determine the highest color mode supported by the terminal
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Integer] the highest supported color mode
      # @rbs () -> Integer
      def supported_color_mode
        @supported_color_mode ||= if Support.twenty_four_bit? then TWENTY_FOUR_BIT
                                  elsif Support.eight_bit? then EIGHT_BIT
                                  elsif Support.four_bit? then FOUR_BIT
                                  elsif Support.three_bit? then THREE_BIT
                                  else
                                    NO_COLOR
                                  end
      end
    end
  end
end
