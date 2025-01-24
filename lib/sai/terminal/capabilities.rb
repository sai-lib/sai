# frozen_string_literal: true

require 'sai/terminal/color_mode'

module Sai
  module Terminal
    # Detect the color capabilities of the terminal
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api private
    module Capabilities
      class << self
        # Detect the color capabilities of the current terminal
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @return [Integer] the {ColorMode} of the terminal
        # @rbs () -> Integer
        def detect_color_support
          return ColorMode::NO_COLOR if no_color?
          return ColorMode::TRUE_COLOR if true_color?
          return ColorMode::ADVANCED if advanced?
          return ColorMode::ANSI if ansi?
          return ColorMode::BASIC if basic?

          ColorMode::NO_COLOR
        end

        private

        # Check for 256 color (8-bit) support
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @return [Boolean] `true` if the terminal supports 256 colors, otherwise `false`
        # @rbs () -> bool
        def advanced?
          return true if ENV.fetch('TERM', '').end_with?('-256color')

          ENV.fetch('COLORTERM', '0').to_i >= 256
        end

        # Check for ANSI color support
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @return [Boolean] `true` if the terminal supports basic ANSI colors, otherwise `false`
        # @rbs () -> bool
        def ansi?
          return true if ENV.fetch('TERM', '').match?(/^(xterm|screen|vt100|ansi)/)

          !ENV.fetch('COLORTERM', '').empty?
        end

        # Check for basic color support
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @return [Boolean] `true` if the terminal supports basic colors, otherwise `false`
        # @rbs () -> bool
        def basic?
          !ENV.fetch('TERM', '').empty?
        end

        # Check for NO_COLOR environment variable
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @see https://no-color.org
        #
        # @return [Boolean] `true` if the NO_COLOR environment variable is set, otherwise `false`
        # @rbs () -> bool
        def no_color?
          !ENV.fetch('NO_COLOR', '').empty? || !tty?
        end

        # Check for true color (24-bit) support
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @return [Boolean] `true` if the terminal supports true color, otherwise `false`
        # @rbs () -> bool
        def true_color?
          return true if ENV.fetch('COLORTERM', '').match?(/^(truecolor|24bit)$/)

          case ENV.fetch('TERM', nil)
          when 'xterm-direct', 'xterm-truecolor'
            return true
          end

          case ENV.fetch('TERM_PROGRAM', nil)
          when 'iTerm.app', 'WezTerm', 'vscode'
            return true
          end

          false
        end

        # Check if stdout is a TTY
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since unreleased
        #
        # @api private
        #
        # @return [Boolean] `true` if stdout is a TTY, otherwise `false`
        # @rbs () -> bool
        def tty?
          @tty ||= $stdout.tty?
        end
      end
    end
  end
end
