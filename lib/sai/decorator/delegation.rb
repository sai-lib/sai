# frozen_string_literal: true

require 'sai/decorator'
require 'sai/decorator/color_manipulations'
require 'sai/decorator/gradients'
require 'sai/decorator/hex_colors'
require 'sai/decorator/named_colors'
require 'sai/decorator/named_styles'
require 'sai/decorator/rgb_colors'

module Sai
  class Decorator
    # Delegates all methods from the Decorator class and its component modules
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.3.1
    #
    # @api private
    module Delegation
      # The list of component modules to delegate methods from
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.1
      #
      # @api private
      #
      # @return [Array<Symbol>] the list of component modules
      COMPONENT_MODULES = %i[
        ColorManipulations
        Gradients
        HexColors
        NamedColors
        NamedStyles
        RGBColors
      ].freeze #: Array[Symbol]
      private_constant :COMPONENT_MODULES

      class << self
        # Install delegated methods on the given class or module
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.3.1
        #
        # @api private
        #
        # @param klass [Class, Module] the class or module to install the methods on
        #
        # @return [void]
        # @rbs (Class | Module) -> void
        def install(klass)
          ignored_methods = %i[apply call decorate encode]
          methods = collect_delegatable_methods.reject { |m| ignored_methods.include?(m) }

          methods.each do |method|
            klass.define_method(method) do |*args, **kwargs|
              Decorator.new(mode: Sai.mode.auto).public_send(method, *args, **kwargs)
            end
          end
        end

        private

        # Collect all methods from the Decorator class and its component modules
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.3.1
        #
        # @api private
        #
        # @return [Array<Symbol>] the list of methods to delegate
        # @rbs () -> Array[Symbol]
        def collect_delegatable_methods
          methods = Decorator.instance_methods(false)

          COMPONENT_MODULES.each do |mod|
            methods.concat(Decorator.const_get(mod).instance_methods(false))
          end

          methods.uniq
        end
      end
    end
  end
end
