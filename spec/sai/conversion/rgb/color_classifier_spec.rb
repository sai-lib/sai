# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::Conversion::RGB::ColorClassifier do
  let(:red) { 1.0 }
  let(:green) { 0.0 }
  let(:blue) { 0.0 }

  describe '.closest_ansi_color' do
    subject(:closest_ansi_color) { described_class.closest_ansi_color(red, green, blue) }

    context 'when color is dark' do
      let(:red) { 0.2 }
      let(:green) { 0.2 }
      let(:blue) { 0.2 }

      it 'is expected to return :black' do
        expect(closest_ansi_color).to eq(:black)
      end
    end

    context 'when color is grayscale' do
      let(:red) { 0.5 }
      let(:green) { 0.5 }
      let(:blue) { 0.5 }

      it 'is expected to return :white' do
        expect(closest_ansi_color).to eq(:white)
      end
    end

    context 'when color is primary' do
      context 'when color is red' do
        let(:red) { 1.0 }
        let(:green) { 0.0 }
        let(:blue) { 0.0 }

        it 'is expected to return :red' do
          expect(closest_ansi_color).to eq(:red)
        end
      end

      context 'when color is green' do
        let(:red) { 0.0 }
        let(:green) { 1.0 }
        let(:blue) { 0.0 }

        it 'is expected to return :green' do
          expect(closest_ansi_color).to eq(:green)
        end
      end

      context 'when color is blue' do
        let(:red) { 0.0 }
        let(:green) { 0.0 }
        let(:blue) { 1.0 }

        it 'is expected to return :blue' do
          expect(closest_ansi_color).to eq(:blue)
        end
      end
    end

    context 'when color is secondary' do
      context 'when color is yellow' do
        let(:red) { 1.0 }
        let(:green) { 1.0 }
        let(:blue) { 0.0 }

        it 'is expected to return :yellow' do
          expect(closest_ansi_color).to eq(:yellow)
        end
      end

      context 'when color is magenta' do
        let(:red) { 1.0 }
        let(:green) { 0.0 }
        let(:blue) { 1.0 }

        it 'is expected to return :magenta' do
          expect(closest_ansi_color).to eq(:magenta)
        end
      end

      context 'when color is cyan' do
        let(:red) { 0.0 }
        let(:green) { 1.0 }
        let(:blue) { 1.0 }

        it 'is expected to return :cyan' do
          expect(closest_ansi_color).to eq(:cyan)
        end
      end
    end
  end

  describe '.dark?' do
    subject(:dark?) { described_class.dark?(red, green, blue) }

    context 'when maximum component is less than 0.3' do
      let(:red) { 0.2 }
      let(:green) { 0.2 }
      let(:blue) { 0.2 }

      it { is_expected.to be true }
    end

    context 'when maximum component is equal to 0.3' do
      let(:red) { 0.3 }
      let(:green) { 0.2 }
      let(:blue) { 0.2 }

      it { is_expected.to be false }
    end
  end

  describe '.grayscale?' do
    subject(:grayscale?) { described_class.grayscale?(red, green, blue) }

    context 'when all components are equal' do
      let(:red) { 0.5 }
      let(:green) { 0.5 }
      let(:blue) { 0.5 }

      it { is_expected.to be true }
    end

    context 'when components are different' do
      let(:red) { 0.5 }
      let(:green) { 0.6 }
      let(:blue) { 0.5 }

      it { is_expected.to be false }
    end
  end

  describe '.primary?' do
    subject(:primary?) { described_class.primary?(red, green, blue) }

    context 'when color is primary' do
      it { is_expected.to be true }
    end

    context 'when color is not primary' do
      let(:red) { 0.5 }
      let(:green) { 0.5 }
      let(:blue) { 0.0 }

      it { is_expected.to be false }
    end
  end

  describe '.secondary?' do
    subject(:secondary?) { described_class.secondary?(red, green, blue) }

    context 'when color is yellow' do
      let(:red) { 1.0 }
      let(:green) { 1.0 }
      let(:blue) { 0.0 }

      it { is_expected.to be true }
    end

    context 'when color is magenta' do
      let(:red) { 1.0 }
      let(:green) { 0.0 }
      let(:blue) { 1.0 }

      it { is_expected.to be true }
    end

    context 'when color is cyan' do
      let(:red) { 0.0 }
      let(:green) { 1.0 }
      let(:blue) { 1.0 }

      it { is_expected.to be true }
    end

    context 'when color is not secondary' do
      it { is_expected.to be false }
    end
  end

  describe '.primary_color' do
    subject(:primary_color) { described_class.primary_color(red, green, blue) }

    context 'when red is maximum' do
      let(:red) { 1.0 }
      let(:green) { 0.0 }
      let(:blue) { 0.0 }

      it { is_expected.to eq(:red) }
    end

    context 'when green is maximum' do
      let(:red) { 0.0 }
      let(:green) { 1.0 }
      let(:blue) { 0.0 }

      it { is_expected.to eq(:green) }
    end

    context 'when blue is maximum' do
      let(:red) { 0.0 }
      let(:green) { 0.0 }
      let(:blue) { 1.0 }

      it { is_expected.to eq(:blue) }
    end
  end

  describe '.secondary_color' do
    subject(:secondary_color) { described_class.secondary_color(red, green, blue) }

    context 'when color is yellow' do
      let(:red) { 1.0 }
      let(:green) { 1.0 }
      let(:blue) { 0.0 }

      it { is_expected.to eq(:yellow) }
    end

    context 'when color is magenta' do
      let(:red) { 1.0 }
      let(:green) { 0.0 }
      let(:blue) { 1.0 }

      it { is_expected.to eq(:magenta) }
    end

    context 'when color is cyan' do
      let(:red) { 0.0 }
      let(:green) { 1.0 }
      let(:blue) { 1.0 }

      it { is_expected.to eq(:cyan) }
    end

    context 'when color is not secondary' do
      it { is_expected.to eq(:white) }
    end
  end
end
