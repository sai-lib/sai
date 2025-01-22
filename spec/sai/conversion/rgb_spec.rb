# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::Conversion::RGB do
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
