# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::Conversion::RGB do
  describe '.closest_ansi_color' do
    subject(:closest_ansi_color) { described_class.closest_ansi_color(red, green, blue) }

    context 'when color is dark' do
      let(:red) { 0.1 }
      let(:green) { 0.1 }
      let(:blue) { 0.1 }

      it { is_expected.to eq(:black) }
    end

    context 'when color is grayscale' do
      let(:red) { 0.5 }
      let(:green) { 0.5 }
      let(:blue) { 0.5 }

      it { is_expected.to eq(:white) }
    end

    context 'when color is primary' do
      context 'when color is red' do
        let(:red) { 0.9 }
        let(:green) { 0.1 }
        let(:blue) { 0.1 }

        it { is_expected.to eq(:red) }
      end

      context 'when color is green' do
        let(:red) { 0.1 }
        let(:green) { 0.9 }
        let(:blue) { 0.1 }

        it { is_expected.to eq(:green) }
      end

      context 'when color is blue' do
        let(:red) { 0.1 }
        let(:green) { 0.1 }
        let(:blue) { 0.9 }

        it { is_expected.to eq(:blue) }
      end
    end

    context 'when color is secondary' do
      context 'when color is yellow' do
        let(:red) { 0.9 }
        let(:green) { 0.9 }
        let(:blue) { 0.1 }

        it { is_expected.to eq(:yellow) }
      end

      context 'when color is magenta' do
        let(:red) { 0.9 }
        let(:green) { 0.1 }
        let(:blue) { 0.9 }

        it { is_expected.to eq(:magenta) }
      end

      context 'when color is cyan' do
        let(:red) { 0.1 }
        let(:green) { 0.9 }
        let(:blue) { 0.9 }

        it { is_expected.to eq(:cyan) }
      end

      context 'when color matches no specific secondary color' do
        let(:red) { 0.5 }
        let(:green) { 0.35 }
        let(:blue) { 0.4 }

        it { is_expected.to eq(:magenta) }
      end
    end
  end

  describe '.darken' do
    subject(:darken) { described_class.darken(color, amount) }

    context 'when given an RGB array' do
      let(:color) { [255, 128, 64] }
      let(:amount) { 0.5 }

      it 'is expected to darken the color by the specified amount' do
        expect(darken).to eq([128, 64, 32])
      end

      context 'when amount would make values negative' do
        let(:amount) { 1.0 }

        it 'is expected to clamp values at 0' do
          expect(darken).to eq([0, 0, 0])
        end
      end
    end

    context 'when given a hex color' do
      let(:color) { '#FF8040' }
      let(:amount) { 0.5 }

      it 'is expected to darken the color by the specified amount' do
        expect(darken).to eq([128, 64, 32])
      end
    end

    context 'when given a named color' do
      let(:color) { :red }
      let(:amount) { 0.5 }

      it 'is expected to darken the color by the specified amount' do
        rgb = Sai::ANSI::COLOR_NAMES[:red]
        expected = rgb.map { |c| (c * 0.5).round }
        expect(darken).to eq(expected)
      end
    end

    context 'when given an invalid amount' do
      let(:color) { [255, 128, 64] }

      context 'when amount is negative' do
        let(:amount) { -0.5 }

        it 'is expected to raise ArgumentError' do
          expect { darken }.to raise_error(ArgumentError, /Invalid amount/)
        end
      end

      context 'when amount is greater than 1.0' do
        let(:amount) { 1.5 }

        it 'is expected to raise ArgumentError' do
          expect { darken }.to raise_error(ArgumentError, /Invalid amount/)
        end
      end
    end
  end

  describe '.lighten' do
    subject(:lighten) { described_class.lighten(color, amount) }

    context 'when given an RGB array' do
      let(:color) { [128, 64, 32] }
      let(:amount) { 0.5 }

      it 'is expected to lighten the color by the specified amount' do
        expect(lighten).to eq([192, 96, 48])
      end

      context 'when amount would exceed 255' do
        let(:amount) { 1.0 }

        it 'is expected to clamp values at 255' do
          expect(lighten).to eq([255, 128, 64])
        end
      end
    end

    context 'when given a hex color' do
      let(:color) { '#804020' }
      let(:amount) { 0.5 }

      it 'is expected to lighten the color by the specified amount' do
        expect(lighten).to eq([192, 96, 48])
      end
    end

    context 'when given a named color' do
      let(:color) { :blue }
      let(:amount) { 0.5 }

      it 'is expected to lighten the color by the specified amount' do
        rgb = Sai::ANSI::COLOR_NAMES[:blue]
        expected = rgb.map { |c| [255, (c * 1.5).round].min }
        expect(lighten).to eq(expected)
      end
    end

    context 'when given an invalid amount' do
      let(:color) { [128, 64, 32] }

      context 'when amount is negative' do
        let(:amount) { -0.5 }

        it 'is expected to raise ArgumentError' do
          expect { lighten }.to raise_error(ArgumentError, /Invalid amount/)
        end
      end

      context 'when amount is greater than 1.0' do
        let(:amount) { 1.5 }

        it 'is expected to raise ArgumentError' do
          expect { lighten }.to raise_error(ArgumentError, /Invalid amount/)
        end
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
        expect(resolve).to eq(Sai::ANSI::COLOR_NAMES[:red])
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

  describe '.to_color_cube_index' do
    subject(:to_color_cube_index) { described_class.to_color_cube_index(rgb) }

    context 'when given black RGB values' do
      let(:rgb) { [0, 0, 0] }

      it { is_expected.to eq(16) }
    end

    context 'when given white RGB values' do
      let(:rgb) { [255, 255, 255] }

      it { is_expected.to eq(231) }
    end

    context 'when given mid-range RGB values' do
      let(:rgb) { [128, 128, 128] }

      it 'is expected to return appropriate cube index' do
        expect(to_color_cube_index).to be_between(16, 231)
      end
    end
  end

  describe '.to_grayscale_index' do
    subject(:to_grayscale_index) { described_class.to_grayscale_index(rgb) }

    context 'when given black RGB values' do
      let(:rgb) { [0, 0, 0] }

      it { is_expected.to eq(232) }
    end

    context 'when given white RGB values' do
      let(:rgb) { [255, 255, 255] }

      it { is_expected.to eq(255) }
    end

    context 'when given mid-range RGB values' do
      let(:rgb) { [128, 128, 128] }

      it 'is expected to return appropriate grayscale index' do
        expect(to_grayscale_index).to be_between(232, 255)
      end
    end
  end
end
