# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::Conversion::RGB::ColorIndexer do
  describe '.to_color_cube_index' do
    subject(:color_cube) { described_class.color_cube(rgb) }

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
        expect(color_cube).to be_between(16, 231)
      end
    end
  end

  describe '.grayscale' do
    subject(:grayscale) { described_class.grayscale(rgb) }

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
        expect(grayscale).to be_between(232, 255)
      end
    end
  end
end
