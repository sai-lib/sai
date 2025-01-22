# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::Conversion::RGB::ColorSpace do
  describe '.hsv_to_rgb' do
    subject(:hsv_to_rgb) { described_class.hsv_to_rgb(hue, saturation, value) }

    context 'when converting primary colors' do
      context 'when converting red' do
        let(:hue) { 0.0 }
        let(:saturation) { 1.0 }
        let(:value) { 1.0 }

        it 'is expected to return red RGB values' do
          expect(hsv_to_rgb).to eq([255, 0, 0])
        end
      end

      context 'when converting green' do
        let(:hue) { 120.0 }
        let(:saturation) { 1.0 }
        let(:value) { 1.0 }

        it 'is expected to return green RGB values' do
          expect(hsv_to_rgb).to eq([0, 255, 0])
        end
      end

      context 'when converting blue' do
        let(:hue) { 240.0 }
        let(:saturation) { 1.0 }
        let(:value) { 1.0 }

        it 'is expected to return blue RGB values' do
          expect(hsv_to_rgb).to eq([0, 0, 255])
        end
      end
    end

    context 'when converting secondary colors' do
      context 'when converting yellow' do
        let(:hue) { 60.0 }
        let(:saturation) { 1.0 }
        let(:value) { 1.0 }

        it 'is expected to return yellow RGB values' do
          expect(hsv_to_rgb).to eq([255, 255, 0])
        end
      end

      context 'when converting cyan' do
        let(:hue) { 180.0 }
        let(:saturation) { 1.0 }
        let(:value) { 1.0 }

        it 'is expected to return cyan RGB values' do
          expect(hsv_to_rgb).to eq([0, 255, 255])
        end
      end

      context 'when converting magenta' do
        let(:hue) { 300.0 }
        let(:saturation) { 1.0 }
        let(:value) { 1.0 }

        it 'is expected to return magenta RGB values' do
          expect(hsv_to_rgb).to eq([255, 0, 255])
        end
      end
    end

    context 'when value is 0' do
      let(:hue) { 0.0 }
      let(:saturation) { 1.0 }
      let(:value) { 0.0 }

      it 'is expected to return black' do
        expect(hsv_to_rgb).to eq([0, 0, 0])
      end
    end

    context 'when saturation is 0' do
      let(:hue) { 0.0 }
      let(:saturation) { 0.0 }
      let(:value) { 0.5 }

      it 'is expected to return grayscale' do
        expect(hsv_to_rgb).to eq([128, 128, 128])
      end
    end
  end

  describe '.resolve' do
    subject(:resolve) { described_class.resolve(color) }

    context 'when given an RGB array' do
      let(:color) { [255, 128, 0] }

      it 'is expected to return the same RGB values' do
        expect(resolve).to eq([255, 128, 0])
      end

      context 'when given invalid RGB values' do
        let(:color) { [300, -1, 128] }

        it 'is expected to raise ArgumentError' do
          expect { resolve }.to raise_error(ArgumentError, /Invalid RGB values/)
        end
      end
    end

    context 'when given a hex color string' do
      let(:color) { '#FF8000' }

      it 'is expected to convert to RGB values' do
        expect(resolve).to eq([255, 128, 0])
      end

      context 'when given hex without #' do
        let(:color) { 'FF8000' }

        it 'is expected to convert to RGB values' do
          expect(resolve).to eq([255, 128, 0])
        end
      end
    end

    context 'when given a named color' do
      let(:color) { 'red' }

      it 'is expected to convert to RGB values' do
        expect(resolve).to eq(Sai::NamedColors[:red])
      end

      context 'when given unknown color name' do
        let(:color) { 'not_a_color' }

        it 'is expected to raise ArgumentError' do
          expect { resolve }.to raise_error(ArgumentError, /Unknown color name/)
        end
      end
    end

    context 'when given invalid input', rbs: :skip do
      let(:color) { 123 }

      it 'is expected to raise ArgumentError' do
        expect { resolve }.to raise_error(ArgumentError, /Invalid color format/)
      end
    end
  end
end
