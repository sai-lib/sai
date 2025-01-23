# frozen_string_literal: true

module Sai
  # The named color registry
  #
  # @author {https://aaronmallen.me Aaron Allen}
  # @since unreleased
  #
  # @api private
  module Registry
    class << self
      # Look up an RGB value by color name
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.1
      #
      # @api private
      #
      # @param name [String, Symbol] the color name
      #
      # @return [Array<Integer>] the RGB value
      # @rbs (String | Symbol name) -> Array[Integer]?
      def [](name)
        lookup[name.to_sym]
      end

      # Get a list of all color names
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since 0.3.1
      #
      # @api private
      #
      # @return [Array<Symbol>] the color names
      def names
        @names ||= lookup.keys.uniq.sort
      end

      # Register a named color with an RGB or Hexadecimal value
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param name [String, Symbol] the name of the color being registered
      # @param rgb_or_hex [Array<Integer>, String] the RGB or Hexadecimal value of the color
      #
      # @return [Boolean] `true` if the color was registered
      # @rbs (String | Symbol name, Array[Integer] | String rgb_or_hex) -> void
      def register(name, rgb_or_hex)
        key = name.to_s.downcase.to_sym
        rgb = Conversion::RGB.resolve(rgb_or_hex)
        thread_lock.synchronize { lookup[key] = rgb }
        broadcast_registration(key)
        true
      end

      # Subscribe to registry changes
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param subscriber [Object] the subscriber
      #
      # @return [void]
      # @rbs (Object subscriber) -> void
      def subscribe(subscriber)
        thread_lock.synchronize { subscribers << subscriber }
      end

      private

      # Broadcast a color registration to all subscribers
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @param color_name [Symbol] the color name
      #
      # @return [void]
      # @rbs (Symbol name) -> void
      def broadcast_registration(color_name)
        subscribers.each do |subscriber|
          next unless subscriber.respond_to?(:on_color_registration, true)

          subscriber.send(:on_color_registration, color_name)
        end
      end

      # The Sai named colors lookup
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Hash{Symbol => Array<Integer>}] the named colors lookup
      def lookup
        @lookup ||= {}
      end

      # The registry subscribers
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Array<Class, Module, Object>] the subscribers
      # @rbs () -> Array[Class | Module | Object]
      def subscribers
        @subscribers ||= []
      end

      # A Mutex for thread safety
      #
      # @author {https://aaronmallen.me Aaron Allen}
      # @since unreleased
      #
      # @api private
      #
      # @return [Mutex] the thread lock
      # @rbs () -> Mutex
      def thread_lock
        @thread_lock ||= Mutex.new
      end
    end
  end
end
