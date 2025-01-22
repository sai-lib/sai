# frozen_string_literal: true

require 'sai/ansi'
require 'sai/conversion/rgb/color_classifier'
require 'sai/conversion/rgb/color_indexer'
require 'sai/conversion/rgb/color_space'
require 'sai/conversion/rgb/color_transformer'

module Sai
  module Conversion
    # RGB color conversion utilities
    #
    # @author {https://aaronmallen.me Aaron Allen}
    # @since 0.1.0
    #
    # @api private
    module RGB
      class << self
        # Color classification utilities
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.3.1
        #
        # @api private
        #
        # @return [Module<ColorClassifier>] the ColorClassifier module
        # @rbs () -> singleton(ColorClassifier)
        def classify
          ColorClassifier
        end

        # Color indexing utilities
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.3.1
        #
        # @api private
        #
        # @return [Module<ColorIndexer>] the ColorIndexer module
        # @rbs () -> singleton(ColorIndexer)
        def index
          ColorIndexer
        end

        # Convert a color value to RGB components
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.1.0
        #
        # @api private
        #
        # @param color [String, Array<Integer>] the color to convert
        #
        # @raise [ArgumentError] if the color format is invalid
        # @return [Array<Integer>] the RGB components
        # @rbs (Array[Integer] | String | Symbol color) -> Array[Integer]
        def resolve(color)
          ColorSpace.resolve(color)
        end

        # Transform RGB values
        #
        # @author {https://aaronmallen.me Aaron Allen}
        # @since 0.3.1
        #
        # @api private
        #
        # @return [Module<ColorTransformer>] the color transformer
        # @rbs () -> singleton(ColorTransformer)
        def transform
          ColorTransformer
        end
      end
    end
  end
end
