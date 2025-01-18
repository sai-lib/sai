# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::Conversion::ColorSequence do
  describe '.resolve' do
    subject(:resolve) { described_class.resolve(color, mode, style_type) }

    let(:style_type) { :foreground }

    context 'when in true color mode' do
      let(:mode) { Sai::Terminal::ColorMode::TRUE_COLOR }

      context 'when given RGB array' do
        let(:color) { [255, 128, 0] }

        it 'is expected to return 24-bit color sequence' do
          expect(resolve).to eq("\e[38;2;255;128;0m")
        end

        context 'with background style' do
          let(:style_type) { :background }

          it 'is expected to return background color sequence' do
            expect(resolve).to eq("\e[48;2;255;128;0m")
          end
        end
      end

      context 'when given hex color' do
        let(:color) { '#FF8000' }

        it 'is expected to return 24-bit color sequence' do
          expect(resolve).to eq("\e[38;2;255;128;0m")
        end
      end

      context 'when given named color' do
        let(:color) { 'red' }

        it 'is expected to return sequence for named color' do
          rgb = Sai::ANSI::COLOR_NAMES[:red]
          expect(resolve).to eq("\e[38;2;#{rgb.join(';')}m")
        end
      end
    end

    context 'when in 8-bit color mode' do
      let(:mode) { Sai::Terminal::ColorMode::BIT8 }

      context 'when given grayscale color' do
        let(:color) { [128, 128, 128] }

        it 'is expected to return grayscale sequence' do
          expect(resolve).to eq("\e[38;5;244m")
        end

        context 'with background style' do
          let(:style_type) { :background }

          it 'is expected to return background grayscale sequence' do
            expect(resolve).to eq("\e[48;5;244m")
          end
        end
      end

      context 'when given RGB color' do
        let(:color) { [255, 128, 0] }

        it 'is expected to return color cube sequence' do
          expect(resolve).to eq("\e[38;5;214m")
        end
      end
    end

    context 'when in ANSI color mode' do
      let(:mode) { Sai::Terminal::ColorMode::ANSI }

      context 'when given RGB color' do
        let(:color) { [255, 128, 128] }

        it 'is expected to return bright ANSI sequence' do
          expect(resolve).to eq("\e[91m")
        end

        context 'with background style' do
          let(:style_type) { :background }

          it 'is expected to return bright background ANSI sequence' do
            expect(resolve).to eq("\e[101m")
          end
        end
      end

      context 'when given darker color' do
        let(:color) { [128, 0, 0] }

        it 'is expected to return non-bright ANSI sequence' do
          expect(resolve).to eq("\e[31m")
        end
      end
    end

    context 'when in basic color mode' do
      let(:mode) { Sai::Terminal::ColorMode::BASIC }

      context 'when given RGB color' do
        let(:color) { [255, 0, 0] }

        it 'is expected to return basic color sequence' do
          expect(resolve).to eq("\e[31m")
        end

        context 'with background style' do
          let(:style_type) { :background }

          it 'is expected to return background basic sequence' do
            expect(resolve).to eq("\e[41m")
          end
        end
      end
    end

    context 'when in unsupported color mode' do
      let(:mode) { -1 }
      let(:color) { [255, 0, 0] }

      it 'is expected to return empty string' do
        expect(resolve).to eq('')
      end
    end

    context 'when given invalid style type', rbs: :skip do
      let(:mode) { Sai::Terminal::ColorMode::BASIC }
      let(:color) { [255, 0, 0] }
      let(:style_type) { :invalid }

      it { expect { resolve }.to raise_error(ArgumentError, 'Invalid style type: invalid') }
    end

    context 'when given invalid color format', rbs: :skip do
      let(:mode) { Sai::Terminal::ColorMode::BASIC }
      let(:color) { 123 }

      it { expect { resolve }.to raise_error(ArgumentError, 'Invalid color format: 123') }
    end
  end
end
