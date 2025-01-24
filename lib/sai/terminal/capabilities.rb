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
          @detect_color_support ||= no_color || true_color || advanced || ansi || basic || ColorMode::NO_COLOR
        end

        private

        # Check for 256 color (8-bit) support
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @return [Integer, nil] the {ColorMode} or `nil` if not supported
        # @rbs () -> Integer?
        def advanced
          return ColorMode::ADVANCED if ENV.fetch('TERM', '').end_with?('-256color')

          ColorMode::ADVANCED if ENV.fetch('COLORTERM', '0').to_i >= 256
        end

        # Check for ANSI color support
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @return [Integer, nil] the {ColorMode} or `nil` if not supported
        # @rbs () -> Integer?
        def ansi
          return ColorMode::ANSI if ENV.fetch('TERM', '').match?(/^(xterm|screen|vt100|ansi)/)

          ColorMode::ANSI unless ENV.fetch('COLORTERM', '').empty?
        end

        # Check for basic color support
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @return [Integer, nil] the {ColorMode} or `nil` if not supported
        # @rbs () -> Integer?
        def basic
          ColorMode::BASIC unless ENV.fetch('TERM', '').empty?
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
        # @return [Integer, nil] the {ColorMode} or `nil` if not supported
        # @rbs () -> Integer?
        def no_color
          ColorMode::NO_COLOR unless ENV.fetch('NO_COLOR', '').empty? || !$stdout.tty?
        end

        # Check for true color (24-bit) support
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @return [Integer, nil] the {ColorMode} or `nil` if not supported
        # @rbs () -> Integer?
        def true_color
          return ColorMode::TRUE_COLOR if ENV.fetch('COLORTERM', '').match?(/^(truecolor|24bit)$/)

          case ENV.fetch('TERM', nil)
          when 'xterm-direct', 'xterm-truecolor'
            return ColorMode::TRUE_COLOR
          end

          case ENV.fetch('TERM_PROGRAM', nil)
          when 'iTerm.app', 'WezTerm', 'vscode'
            ColorMode::TRUE_COLOR
          end
        end
      end
    end
  end
end
