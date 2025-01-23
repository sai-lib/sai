# frozen_string_literal: true

require 'sai/decorator/color_manipulations'
require 'sai/decorator/gradients'
require 'sai/decorator/hex_colors'
require 'sai/decorator/named_styles'
require 'sai/decorator/rgb_colors'

module Sai
  class Decorator
    # Provides method delegation to the {Decorator} class for classes or modules that include it
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.4.0
    #
    # @abstract Include in a class or module to provide method delegation to the {Decorator} class
    # @api private
    module Delegator
      # @rbs!
      #   def blink: () -> Decorator
      #   def bold: () -> Decorator
      #   def conceal: () -> Decorator
      #   def darken_background: () -> Decorator
      #   def darken_bg: () -> Decorator
      #   def darken_fg: () -> Decorator
      #   def darken_foreground: () -> Decorator
      #   def darken_text: () -> Decorator
      #   def dim: () -> Decorator
      #   def gradient: () -> Decorator
      #   def hex: () -> Decorator
      #   def italic: () -> Decorator
      #   def lighten_background: () -> Decorator
      #   def lighten_bg: () -> Decorator
      #   def lighten_fg: () -> Decorator
      #   def lighten_foreground: () -> Decorator
      #   def lighten_text: () -> Decorator
      #   def no_blink: () -> Decorator
      #   def no_conceal: () -> Decorator
      #   def no_italic: () -> Decorator
      #   def no_reverse: () -> Decorator
      #   def no_strike: () -> Decorator
      #   def no_underline: () -> Decorator
      #   def normal_intensity: () -> Decorator
      #   def on_gradient: () -> Decorator
      #   def on_hex: () -> Decorator
      #   def on_rainbow: () -> Decorator
      #   def on_rgb: () -> Decorator
      #   def rainbow: () -> Decorator
      #   def rapid_blink: () -> Decorator
      #   def reverse: () -> Decorator
      #   def rgb: () -> Decorator
      #   def strike: () -> Decorator
      #   def underline: () -> Decorator

      [ColorManipulations, Gradients, HexColors, NamedStyles, RGBColors].each do |mod|
        mod.instance_methods.each do |method|
          define_method(method) do |*arguments, **keyword_arguments|
            Decorator.new.public_send(method, *arguments, **keyword_arguments)
          end
        end
      end

      # Apply a specific color mode to the {Decorator} instance
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.4.0
      #
      # @api private
      #
      # @param mode [Integer] the color mode to use
      #
      # @return [Decorator] a new instance of Decorator with the applied color mode
      # @rbs (Integer mode) -> Decorator
      def with_mode(mode)
        Decorator.new(mode:)
      end
    end
  end
end
