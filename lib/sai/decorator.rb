# frozen_string_literal: true

require 'sai'
require 'sai/ansi'
require 'sai/ansi/sequenced_string'
require 'sai/conversion/color_sequence'
require 'sai/decorator/color_manipulations'
require 'sai/decorator/gradients'
require 'sai/decorator/hex_colors'
require 'sai/decorator/named_colors'
require 'sai/decorator/named_styles'
require 'sai/decorator/rgb_colors'
require 'sai/terminal/color_mode'

module Sai
  # A decorator for applying ANSI styles and colors to text
  #
  # @author {https://aaronmallen.me Aaron Allen}
  # @since 0.1.0
  #
  # @api public
  class Decorator
    include ColorManipulations
    include Gradients
    include HexColors
    include NamedColors
    include NamedStyles
    include RGBColors

    # Initialize a new instance of Decorator
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api private
    #
    # @param mode [Integer] the color mode to use
    #
    # @return [Decorator] the new instance of Decorator
    # @rbs (?mode: Integer) -> void
    def initialize(mode: Sai.mode.auto)
      @background = nil
      @background_sequence = nil
      @mode = mode
      @foreground = nil
      @foreground_sequence = nil
      @styles = [] #: Array[Symbol]
    end

    # Apply the styles and colors to the text
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api public
    #
    # @example
    #   decorator.red.on_blue.bold.decorate('Hello, world!').to_s #=> "\e[38;5;160;48;5;21;1mHello, world!\e[0m"
    #
    # @param text [String] the text to decorate
    #
    # @return [ANSI::SequencedString] the decorated text
    # @rbs (String text) -> ANSI::SequencedString
    def decorate(text)
      return ANSI::SequencedString.new(text) unless should_decorate?
      return apply_sequence_gradient(text) if @foreground_sequence || @background_sequence

      sequences = [
        @foreground && Conversion::ColorSequence.resolve(@foreground, @mode),
        @background && Conversion::ColorSequence.resolve(@background, @mode, :background),
        style_sequences.join
      ].compact.join

      ANSI::SequencedString.new("#{sequences}#{text}#{ANSI::RESET}")
    end
    alias apply decorate
    alias call decorate
    alias encode decorate

    # Apply a specific color mode to the decorator
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.2.0
    #
    # @api public
    #
    # @example
    #   decorator.with_mode(Sai.mode.basic_auto) #=> => #<Sai::Decorator:0x123 @mode=1>
    #
    # @param mode [Integer] the color mode to use
    #
    # @return [Decorator] a new instance of Decorator with the applied color mode
    # @rbs (Integer mode) -> Decorator
    def with_mode(mode)
      dup.tap { |duped| duped.instance_variable_set(:@mode, mode) }
    end

    private

    # Check if text should be decorated
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.2.0
    #
    # @api private
    #
    # @return [Boolean] `true` if text should be decorated, `false` otherwise
    # @rbs () -> bool
    def should_decorate?
      return false if @mode == Terminal::ColorMode::NO_COLOR
      return false if @foreground.nil? && @background.nil? && @styles.empty? &&
                      @foreground_sequence.nil? && @background_sequence.nil?

      true
    end
  end
end
