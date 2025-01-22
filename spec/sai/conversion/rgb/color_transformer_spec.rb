# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::Conversion::RGB::ColorTransformer do
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
        rgb = Sai::NamedColors[:red]
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
        start_rgb = Sai::NamedColors[:red]
        end_rgb = Sai::NamedColors[:blue]
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
        end_rgb = Sai::NamedColors[:blue]
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
        rgb = Sai::NamedColors[:blue]
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
end
