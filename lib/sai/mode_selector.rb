# frozen_string_literal: true

require 'sai/terminal/capabilities'
require 'sai/terminal/color_mode'

module Sai
  # Color mode selection methods
  #
  # @author {https://aaronmallen.me Aaron Allen}
  # @since 0.2.0
  #
  # @api public
  module ModeSelector
    class << self
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
      def advanced
        Terminal::ColorMode::ADVANCED
      end
      alias color256 advanced
      alias colour256 advanced
      alias eight_bit advanced
      alias two_hundred_fifty_six_color advanced
      alias two_hundred_fifty_six_colour advanced

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
      def advanced_auto
        [Terminal::Capabilities.detect_color_support, Terminal::ColorMode::ADVANCED].min
      end
      alias color256_auto advanced_auto
      alias colour256_auto advanced_auto
      alias eight_bit_auto advanced_auto
      alias two_hundred_fifty_six_color_auto advanced_auto
      alias two_hundred_fifty_six_colour_auto advanced_auto

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
      def ansi
        Terminal::ColorMode::ANSI
      end
      alias color16 ansi
      alias colour16 ansi
      alias four_bit ansi
      alias sixteen_color ansi
      alias sixteen_colour ansi

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
      def ansi_auto
        [Terminal::Capabilities.detect_color_support, Terminal::ColorMode::ANSI].min
      end
      alias color16_auto ansi_auto
      alias colour16_auto ansi_auto
      alias four_bit_auto ansi_auto
      alias sixteen_color_auto ansi_auto
      alias sixteen_colour_auto ansi_auto

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
        Terminal::Capabilities.detect_color_support
      end
      alias color16m_auto auto
      alias colour16m_auto auto
      alias enabled auto
      alias sixteen_million_color_auto auto
      alias sixteen_million_colour_auto auto
      alias twenty_for_bit_auto auto

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
      def basic
        Terminal::ColorMode::BASIC
      end
      alias color8 basic
      alias colour8 basic
      alias eight_color basic
      alias eight_colour basic
      alias three_bit basic

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
      def basic_auto
        [Terminal::Capabilities.detect_color_support, Terminal::ColorMode::BASIC].min
      end
      alias color8_auto basic_auto
      alias colour8_auto basic_auto
      alias eight_color_auto basic_auto
      alias eight_colour_auto basic_auto
      alias three_bit_auto basic_auto

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
        Terminal::ColorMode::NO_COLOR
      end
      alias disabled no_color
      alias mono no_color
      alias no_colour no_color

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
      def true_color
        Terminal::ColorMode::TRUE_COLOR
      end
      alias color16m true_color
      alias colour16m true_color
      alias sixteen_million_color true_color
      alias sixteen_million_colour true_color
      alias twenty_for_bit true_color
    end
  end
end
