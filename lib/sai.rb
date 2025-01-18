# frozen_string_literal: true

require 'sai/support'
require 'sai/terminal/capabilities'
require 'singleton'

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
# @author {https://aaronmallen.me Aaron Allen}
# @since unreleased
#
# @api public
module Sai
  class << self
    # The supported color modes for the terminal
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api public
    #
    # @example Check the color support of the terminal
    #   Sai.support.ansi? # => true
    #   Sai.support.basic? # => true
    #   Sai.support.bit8? # => true
    #   Sai.support.no_color? # => false
    #   Sai.support.true_color? # => true
    #
    # @return [Support] the color support
    # @rbs () -> Support
    def support
      @support ||= Support.new(color_mode).freeze
    end

    private

    # Detect the color capabilities of the terminal
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    #
    # @return [Integer] the color mode
    # @rbs () -> Integer
    def color_mode
      Thread.current[:sai_color_mode] ||= Terminal::Capabilities.detect_color_support
    end
  end
end
