# frozen_string_literal: true

module Sai
  # Determine the color capabilities of the terminal
  #
  # @author {https://aaronmallen.me Aaron Allen}
  # @since 0.1.0
  #
  # @api public
  module Support
    class << self
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
        @color ||= ENV.fetch('NO_COLOR', '').empty? && $stdout.tty?
      end

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
      def eight_bit?
        @eight_bit ||= color? &&
                       (ENV.fetch('TERM', '').end_with?('-256color') || ENV.fetch('COLORTERM', '0').to_i >= 256)
      end
      alias advanced? eight_bit?
      alias color256? eight_bit?
      alias colour256? eight_bit?
      alias two_hundred_fifty_six_color? eight_bit?
      alias two_hundred_fifty_six_colour? eight_bit?

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
      def four_bit?
        @four_bit ||= color? &&
                      (ENV.fetch('TERM', '').match?(/^(xterm|screen|vt100|ansi)/) || !ENV.fetch('COLORTERM', '').empty?)
      end
      alias ansi? four_bit?
      alias color16? four_bit?
      alias colour16? four_bit?
      alias sixteen_color? four_bit?
      alias sixteen_colour? four_bit?

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
      def three_bit?
        @three_bit ||= color?
      end
      alias basic? three_bit?
      alias color8? three_bit?
      alias colour8? three_bit?
      alias eight_color? three_bit?
      alias eight_colour? three_bit?

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
      def twenty_four_bit?
        @twenty_four_bit ||= color? &&
                             (
                               ENV.fetch('COLORTERM', '').match?(/^(truecolor|24bit)$/) ||
                               %w[xterm-direct xterm-truecolor].include?(ENV.fetch('TERM', '')) ||
                               %w[iTerm.app WezTerm vscode].include?(ENV.fetch('TERM_PROGRAM', ''))
                             )
      end
      alias color16m? twenty_four_bit?
      alias colour16m? twenty_four_bit?
      alias sixteen_million_color? twenty_four_bit?
      alias sixteen_million_colour? twenty_four_bit?
      alias true_color? twenty_four_bit?
    end
  end
end
