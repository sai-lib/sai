# frozen_string_literal: true

module Sai
  class Decorator
    # Named color methods for the {Decorator} class
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.3.1
    #
    # @abstract This module is meant to be included in the {Decorator} class to provide named color methods
    # @api private
    #
    # @note For each named color, two methods are dynamically generated:
    #   * color_name - Applies the color to the foreground
    #   * on_color_name - Applies the color to the backgroundAll color methods return {Decorator}
    #
    # @example Using a named color
    #   decorator.blue.decorate('Hello').to_s      #=> "\e[38;2;0;0;238mHello\e[0m"
    #   decorator.on_blue.decorate('Hello').to_s   #=> "\e[48;2;0;0;238mHello\e[0m"
    module NamedColors
      # Inject ClassMethods into the including class
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param base [Class] the class including this module
      #
      # @return [void]
      # @rbs (Class base) -> void
      def self.included(base)
        base.extend(ClassMethods)
      end

      # NamedColors ClassMethods
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      module ClassMethods
        private

        # Handle a color registration
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since unreleased
        #
        # @api private
        #
        # @param color_name [Symbol] the color name
        #
        # @return [void]
        # @rbs (Symbol color_name) -> void
        def on_color_registration(color_name)
          { color_name => :foreground, :"on_#{color_name}" => :background }.each_pair do |method, component|
            # @type self: singleton(Decorator)
            # @type var component: Sai::Conversion::ColorSequence::style_type

            undef_method(method) if method_defined?(method)
            define_method(method) { apply_named_color(component, color_name) }
          end
        end
      end

      private

      # Apply a named color to the specified style type
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.1.0
      #
      # @api private
      #
      # @param style_type [Symbol] the style type to apply the color to
      # @param color [Symbol] the color to apply
      #
      # @return [Decorator] a new instance of Decorator with the color applied
      # @rbs (Conversion::ColorSequence::style_type style_type, Symbol color) -> Decorator
      def apply_named_color(style_type, color)
        dup.tap { |duped| duped.instance_variable_set(:"@#{style_type}", color) } #: Decorator
      end
    end
  end
end
