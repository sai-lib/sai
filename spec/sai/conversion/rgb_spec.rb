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

  describe '.gradient' do
    subject(:gradient) { described_class.gradient(start_color, end_color, steps) }

    context 'when given valid RGB arrays' do
      let(:start_color) { [255, 0, 0] }
      let(:end_color) { [0, 0, 255] }
      let(:steps) { 3 }

      it 'is expected to return an array of RGB colors' do
        expect(gradient).to eq([
                                 [255, 0, 0],
                                 [128, 0, 128],
                                 [0, 0, 255]
                               ])
      end
    end

    context 'when given valid hex colors' do
      let(:start_color) { '#FF0000' }
      let(:end_color) { '#0000FF' }
      let(:steps) { 3 }

      it 'is expected to return an array of RGB colors' do
        expect(gradient).to eq([
                                 [255, 0, 0],
                                 [128, 0, 128],
                                 [0, 0, 255]
                               ])
      end
    end

    context 'when given valid named colors' do
      let(:start_color) { :red }
      let(:end_color) { :blue }
      let(:steps) { 3 }

      it 'is expected to return an array of RGB colors' do
        start_rgb = Sai::ANSI::COLOR_NAMES[:red]
        end_rgb = Sai::ANSI::COLOR_NAMES[:blue]
        expect(gradient).to eq([
                                 start_rgb,
                                 [103, 0, 119],
                                 end_rgb
                               ])
      end
    end

    context 'when mixing color formats' do
      let(:start_color) { '#FF0000' }
      let(:end_color) { :blue }
      let(:steps) { 3 }

      it 'is expected to return an array of RGB colors' do
        end_rgb = Sai::ANSI::COLOR_NAMES[:blue]
        expect(gradient).to eq([
                                 [255, 0, 0],
                                 [128, 0, (end_rgb[2] / 2.0).round],
                                 end_rgb
                               ])
      end
    end

    context 'when given invalid steps' do
      let(:start_color) { [255, 0, 0] }
      let(:end_color) { [0, 0, 255] }

      context 'when steps is less than 2' do
        let(:steps) { 1 }

        it 'is expected to raise ArgumentError' do
          expect { gradient }.to raise_error(ArgumentError, /Steps must be at least 2/)
        end
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

  describe '.interpolate_color' do
    subject(:interpolate_color) { described_class.interpolate_color(start_color, end_color, step) }

    context 'when given valid RGB arrays' do
      let(:start_color) { [255, 0, 0] }
      let(:end_color) { [0, 0, 255] }

      context 'when step is 0.0' do
        let(:step) { 0.0 }

        it 'is expected to return the start color' do
          expect(interpolate_color).to eq(start_color)
        end
      end

      context 'when step is 1.0' do
        let(:step) { 1.0 }

        it 'is expected to return the end color' do
          expect(interpolate_color).to eq(end_color)
        end
      end

      context 'when step is 0.5' do
        let(:step) { 0.5 }

        it 'is expected to return the midpoint color' do
          expect(interpolate_color).to eq([128, 0, 128])
        end
      end
    end

    context 'when given invalid step' do
      let(:start_color) { [255, 0, 0] }
      let(:end_color) { [0, 0, 255] }

      context 'when step is negative' do
        let(:step) { -0.1 }

        it 'is expected to raise ArgumentError' do
          expect { interpolate_color }.to raise_error(ArgumentError, /Invalid step/)
        end
      end

      context 'when step is greater than 1.0' do
        let(:step) { 1.1 }

        it 'is expected to raise ArgumentError' do
          expect { interpolate_color }.to raise_error(ArgumentError, /Invalid step/)
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

  describe '.rainbow_gradient' do
    subject(:rainbow_gradient) { described_class.rainbow_gradient(steps) }

    context 'when given valid steps' do
      let(:steps) { 6 }

      it 'is expected to return an array of RGB colors' do
        expect(rainbow_gradient).to eq([
                                         [255, 0, 0],     # Red (0°)
                                         [255, 255, 0],   # Yellow (60°)
                                         [0, 255, 0],     # Green (120°)
                                         [0, 255, 255],   # Cyan (180°)
                                         [0, 0, 255],     # Blue (240°)
                                         [255, 0, 255]    # Magenta (300°)
                                       ])
      end

      it 'is expected to return the specified number of colors' do
        expect(rainbow_gradient.size).to eq(steps)
      end
    end

    context 'when given invalid steps' do
      context 'when steps is less than 2' do
        let(:steps) { 1 }

        it 'is expected to raise ArgumentError' do
          expect { rainbow_gradient }.to raise_error(ArgumentError, /Steps must be at least 2/)
        end
      end
    end

    context 'when checking color values' do
      let(:steps) { 12 }

      it 'is expected to return valid RGB values' do
        expect(rainbow_gradient).to all(satisfy { |color|
          color.size == 3 &&
            color.all? { |c| c.is_a?(Integer) && c.between?(0, 255) }
        })
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
