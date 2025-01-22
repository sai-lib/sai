# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::Conversion::RGB do
  describe '.classify' do
    subject(:classify) { described_class.classify }

    it { is_expected.to eq(Sai::Conversion::RGB::ColorClassifier) }
  end

  describe '.index' do
    subject(:index) { described_class.index }

    it { is_expected.to eq(Sai::Conversion::RGB::ColorIndexer) }
  end

  describe '.resolve' do
    subject(:resolve) { described_class.resolve(color) }

    before do
      allow(Sai::Conversion::RGB::ColorSpace).to receive(:resolve).and_call_original
    end

    let(:color) { 'red' }

    it 'is expected to delegate to ColorSpace.resolve' do
      resolve

      expect(Sai::Conversion::RGB::ColorSpace).to have_received(:resolve).with(color)
    end
  end

  describe '.transform' do
    subject(:transform) { described_class.transform }

    it { is_expected.to eq(Sai::Conversion::RGB::ColorTransformer) }
  end
end
