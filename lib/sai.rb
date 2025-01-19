# frozen_string_literal: true

require 'sai/conversion/color_sequence'
require 'sai/conversion/rgb'
require 'sai/decorator'
require 'sai/mode_selector'
require 'sai/support'
require 'sai/terminal/capabilities'
require 'sai/terminal/color_mode'

# An elegant color management system for crafting sophisticated CLI applications
#
# Sai (彩) - meaning 'coloring' or 'paint' in Japanese - is a powerful and intuitive system for managing color output in
# command-line applications. Drawing inspiration from traditional Japanese artistic techniques, Sai brings vibrancy and
# harmony to terminal interfaces through its sophisticated color management
#
# Sai empowers developers to create beautiful, colorful CLI applications that maintain visual consistency across
# different terminal capabilities. Like its artistic namesake, it combines simplicity and sophistication to bring rich,
# adaptive color to your terminal interfaces
#
# When included in a class or module, Sai provides the following instance methods:
# * {#decorator} - Returns a new instance of {Decorator} for method chaining
# * {#terminal_color_support} - Returns the color support capabilities of the current terminal
#
# The Sai module itself responds to all the same methods as {Decorator}, excluding methods used for applying
# decorations (apply, call, decorate, encode). These methods are directly delegated to a new {Decorator} instance
#
# @author {https://aaronmallen.me Aaron Allen}
# @since 0.1.0
#
# @api public
#
# @example Using Sai as a module
#   class MyClass
#     include Sai
#   end
#
#   my_class = MyClass.new
#   my_class.decorator.red.on_blue.bold.decorate('Hello, World!')
#   #=> "\e[38;2;205;0;0m\e[48;2;0;0;238m\e[1mHello, World!\e[0m"
#
#   my_class.terminal_color_support.true_color? # => true
#
# @example Using Sai directly
#   Sai.red.on_blue.bold.decorate('Hello, World!')
#   #=> "\e[38;2;205;0;0m\e[48;2;0;0;238m\e[1mHello, World!\e[0m"
#
#   Sai.support.true_color? # => true
module Sai
  class << self
    ignored_decorator_methods = %i[apply call decorate encode]
    Decorator.instance_methods(false).reject { |m| ignored_decorator_methods.include?(m) }.each do |method|
      define_method(method) do |*arguments, **keyword_arguments|
        Decorator.new(mode: Sai.mode.auto).public_send(method, *arguments, **keyword_arguments)
      end
    end

    # The Sai {ModeSelector mode selector}
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api public
    #
    # @example
    #   Sai.mode.auto #=> 4
    #
    # @return [ModeSelector] the mode selector
    # @rbs () -> singleton(ModeSelector)
    def mode
      ModeSelector
    end

    # @rbs!
    #   def black: () -> Decorator
    #   def blink: () -> Decorator
    #   def blue: () -> Decorator
    #   def bold: () -> Decorator
    #   def bright_black: () -> Decorator
    #   def bright_blue: () -> Decorator
    #   def bright_cyan: () -> Decorator
    #   def bright_green: () -> Decorator
    #   def bright_magenta: () -> Decorator
    #   def bright_red: () -> Decorator
    #   def bright_white: () -> Decorator
    #   def bright_yellow: () -> Decorator
    #   def conceal: () -> Decorator
    #   def cyan: () -> Decorator
    #   def dim: () -> Decorator
    #   def green: () -> Decorator
    #   def italic: () -> Decorator
    #   def magenta: () -> Decorator
    #   def no_blink: () -> Decorator
    #   def no_conceal: () -> Decorator
    #   def no_italic: () -> Decorator
    #   def no_reverse: () -> Decorator
    #   def no_strike: () -> Decorator
    #   def no_underline: () -> Decorator
    #   def normal_intensity: () -> Decorator
    #   def on_black: () -> Decorator
    #   def on_blue: () -> Decorator
    #   def on_bright_black: () -> Decorator
    #   def on_bright_blue: () -> Decorator
    #   def on_bright_cyan: () -> Decorator
    #   def on_bright_green: () -> Decorator
    #   def on_bright_magenta: () -> Decorator
    #   def on_bright_red: () -> Decorator
    #   def on_bright_white: () -> Decorator
    #   def on_bright_yellow: () -> Decorator
    #   def on_cyan: () -> Decorator
    #   def on_green: () -> Decorator
    #   def on_magenta: () -> Decorator
    #   def on_red: () -> Decorator
    #   def on_white: () -> Decorator
    #   def on_yellow: () -> Decorator
    #   def rapid_blink: () -> Decorator
    #   def red: () -> Decorator
    #   def reverse: () -> Decorator
    #   def strike: () -> Decorator
    #   def underline: () -> Decorator
    #   def white: () -> Decorator
    #   def yellow: () -> Decorator

    # The supported color modes for the terminal
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api public
    #
    # @example Check the color support of the terminal
    #   Sai.support.ansi? # => true
    #   Sai.support.basic? # => true
    #   Sai.support.advanced? # => true
    #   Sai.support.no_color? # => false
    #   Sai.support.true_color? # => true
    #
    # @return [Support] the color support
    # @rbs () -> singleton(Support)
    def support
      Support
    end
  end

  # A helper method to initialize an instance of {Decorator}
  #
  # @author {https://aaronmallen.me Aaron Allen}
  # @since 0.1.0
  #
  # @api public
  #
  # @example Initialize a new instance of {Decorator}
  #   class MyClass
  #     include Sai
  #   end
  #
  #   MyClass.new.decorator.blue.on_red.bold.decorate('Hello, world!')
  #   #=> "\e[38;5;21m\e[48;5;160m\e[1mHello, world!\e[0m"
  #
  #   MyClass.new.decorator(mode: Sai.mode.no_color)
  #   #=> "Hello, world!"
  #
  # @param mode [Integer] the color mode to use
  #
  # @return [Decorator] the Decorator instance
  # @rbs (?mode: Integer) -> Decorator
  def decorator(mode: Sai.mode.auto)
    Decorator.new(mode:)
  end

  # The supported color modes for the terminal
  #
  # @author {https://aaronmallen.me Aaron Allen}
  # @since 0.1.0
  #
  # @api public
  #
  # @example Check the color support of the terminal
  #   class MyClass
  #     include Sai
  #   end
  #
  #   MyClass.new.terminal_color_support.ansi? # => true
  #   MyClass.new.terminal_color_support.basic? # => true
  #   MyClass.new.terminal_color_support.advanced? # => true
  #   MyClass.new.terminal_color_support.no_color? # => false
  #   MyClass.new.terminal_color_support.true_color? # => true
  #
  # @return [Support] the color support
  # @rbs () -> singleton(Support)
  def terminal_color_support
    Support
  end
end
