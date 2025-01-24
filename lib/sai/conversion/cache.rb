# frozen_string_literal: true

module Sai
  module Conversion
    # The cache module is responsible for storing the results of various calculation results
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since unreleased
    #
    # @api private
    module Cache
      class << self
        # Fetch a value from the cache
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since unreleased
        #
        # @api private
        #
        # @param operation_name [String, Symbol] The name of the operation
        # @param operation_variables [Object] The variables used in the operation
        # @yield The block to execute if the value is not found in the cache
        # @yieldreturn [Object] The result of the operation
        #
        # @return [Object] The result of the operation
        # @rbs (String | Symbol operation_name, untyped operation_variables) ?{ (?) -> untyped } -> untyped
        def fetch(operation_name, operation_variables, &)
          lookup[operation_name] ||= {}
          lookup[operation_name][operation_variables] ||= yield
        end

        private

        # The cache lookup table where results are stored
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since unreleased
        #
        # @api private
        #
        # @return [Hash{String => Object}]
        def lookup
          @lookup ||= {}
        end
      end
    end
  end
end
