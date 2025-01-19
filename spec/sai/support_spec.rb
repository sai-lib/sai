# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::Support do
  before do
    allow(Sai::Terminal::Capabilities).to receive(:detect_color_support).and_return(color_mode)
  end

  describe '.advanced?' do
    subject(:advanced?) { described_class.advanced? }

    context 'when terminal supports true color' do
      let(:color_mode) { Sai::Terminal::ColorMode::TRUE_COLOR }

      it { is_expected.to be true }
    end

    context 'when terminal supports 8-bit color' do
      let(:color_mode) { Sai::Terminal::ColorMode::ADVANCED }

      it { is_expected.to be true }
    end

    context 'when terminal supports 4-bit color' do
      let(:color_mode) { Sai::Terminal::ColorMode::ANSI }

      it { is_expected.to be false }
    end

    context 'when terminal supports 3-bit color' do
      let(:color_mode) { Sai::Terminal::ColorMode::BASIC }

      it { is_expected.to be false }
    end

    context 'when terminal has no color support' do
      let(:color_mode) { Sai::Terminal::ColorMode::NO_COLOR }

      it { is_expected.to be false }
    end
  end

  describe '.ansi?' do
    subject(:ansi?) { described_class.ansi? }

    context 'when terminal supports true color' do
      let(:color_mode) { Sai::Terminal::ColorMode::TRUE_COLOR }

      it { is_expected.to be true }
    end

    context 'when terminal supports 8-bit color' do
      let(:color_mode) { Sai::Terminal::ColorMode::ADVANCED }

      it { is_expected.to be true }
    end

    context 'when terminal supports 4-bit color' do
      let(:color_mode) { Sai::Terminal::ColorMode::ANSI }

      it { is_expected.to be true }
    end

    context 'when terminal supports 3-bit color' do
      let(:color_mode) { Sai::Terminal::ColorMode::BASIC }

      it { is_expected.to be false }
    end

    context 'when terminal has no color support' do
      let(:color_mode) { Sai::Terminal::ColorMode::NO_COLOR }

      it { is_expected.to be false }
    end
  end

  describe '.basic?' do
    subject(:basic?) { described_class.basic? }

    context 'when terminal supports true color' do
      let(:color_mode) { Sai::Terminal::ColorMode::TRUE_COLOR }

      it { is_expected.to be true }
    end

    context 'when terminal supports 8-bit color' do
      let(:color_mode) { Sai::Terminal::ColorMode::ADVANCED }

      it { is_expected.to be true }
    end

    context 'when terminal supports 4-bit color' do
      let(:color_mode) { Sai::Terminal::ColorMode::ANSI }

      it { is_expected.to be true }
    end

    context 'when terminal supports 3-bit color' do
      let(:color_mode) { Sai::Terminal::ColorMode::BASIC }

      it { is_expected.to be true }
    end

    context 'when terminal has no color support' do
      let(:color_mode) { Sai::Terminal::ColorMode::NO_COLOR }

      it { is_expected.to be false }
    end
  end

  describe '.color?' do
    subject(:color?) { described_class.color? }

    context 'when terminal supports true color' do
      let(:color_mode) { Sai::Terminal::ColorMode::TRUE_COLOR }

      it { is_expected.to be true }
    end

    context 'when terminal supports 8-bit color' do
      let(:color_mode) { Sai::Terminal::ColorMode::ADVANCED }

      it { is_expected.to be true }
    end

    context 'when terminal supports 4-bit color' do
      let(:color_mode) { Sai::Terminal::ColorMode::ANSI }

      it { is_expected.to be true }
    end

    context 'when terminal supports 3-bit color' do
      let(:color_mode) { Sai::Terminal::ColorMode::BASIC }

      it { is_expected.to be true }
    end

    context 'when terminal has no color support' do
      let(:color_mode) { Sai::Terminal::ColorMode::NO_COLOR }

      it { is_expected.to be false }
    end
  end

  describe '.true_color?' do
    subject(:true_color?) { described_class.true_color? }

    context 'when terminal supports true color' do
      let(:color_mode) { Sai::Terminal::ColorMode::TRUE_COLOR }

      it { is_expected.to be true }
    end

    context 'when terminal supports 8-bit color' do
      let(:color_mode) { Sai::Terminal::ColorMode::ADVANCED }

      it { is_expected.to be false }
    end

    context 'when terminal supports 4-bit color' do
      let(:color_mode) { Sai::Terminal::ColorMode::ANSI }

      it { is_expected.to be false }
    end

    context 'when terminal supports 3-bit color' do
      let(:color_mode) { Sai::Terminal::ColorMode::BASIC }

      it { is_expected.to be false }
    end

    context 'when terminal has no color support' do
      let(:color_mode) { Sai::Terminal::ColorMode::NO_COLOR }

      it { is_expected.to be false }
    end
  end
end
