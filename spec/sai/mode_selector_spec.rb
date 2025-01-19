# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::ModeSelector do
  describe '.advanced' do
    subject(:advanced) { described_class.advanced }

    it { is_expected.to eq(Sai::Terminal::ColorMode::ADVANCED) }
  end

  describe '.advanced_auto' do
    subject(:advanced_auto) { described_class.advanced_auto }

    before do
      allow(Sai::Terminal::Capabilities).to receive(:detect_color_support).and_return(color_support)
    end

    context 'when terminal supports true color' do
      let(:color_support) { Sai::Terminal::ColorMode::TRUE_COLOR }

      it { is_expected.to eq(Sai::Terminal::ColorMode::ADVANCED) }
    end

    context 'when terminal supports 8-bit color' do
      let(:color_support) { Sai::Terminal::ColorMode::ADVANCED }

      it { is_expected.to eq(Sai::Terminal::ColorMode::ADVANCED) }
    end

    context 'when terminal only supports 4-bit color' do
      let(:color_support) { Sai::Terminal::ColorMode::ANSI }

      it { is_expected.to eq(Sai::Terminal::ColorMode::ANSI) }
    end

    context 'when terminal only supports 3-bit color' do
      let(:color_support) { Sai::Terminal::ColorMode::BASIC }

      it { is_expected.to eq(Sai::Terminal::ColorMode::BASIC) }
    end

    context 'when terminal has no color support' do
      let(:color_support) { Sai::Terminal::ColorMode::NO_COLOR }

      it { is_expected.to eq(Sai::Terminal::ColorMode::NO_COLOR) }
    end
  end

  describe '.ansi' do
    subject(:ansi) { described_class.ansi }

    it { is_expected.to eq(Sai::Terminal::ColorMode::ANSI) }
  end

  describe '.ansi_auto' do
    subject(:ansi_auto) { described_class.ansi_auto }

    before do
      allow(Sai::Terminal::Capabilities).to receive(:detect_color_support).and_return(color_support)
    end

    context 'when terminal supports true color' do
      let(:color_support) { Sai::Terminal::ColorMode::TRUE_COLOR }

      it { is_expected.to eq(Sai::Terminal::ColorMode::ANSI) }
    end

    context 'when terminal supports 8-bit color' do
      let(:color_support) { Sai::Terminal::ColorMode::ADVANCED }

      it { is_expected.to eq(Sai::Terminal::ColorMode::ANSI) }
    end

    context 'when terminal supports 4-bit color' do
      let(:color_support) { Sai::Terminal::ColorMode::ANSI }

      it { is_expected.to eq(Sai::Terminal::ColorMode::ANSI) }
    end

    context 'when terminal only supports 3-bit color' do
      let(:color_support) { Sai::Terminal::ColorMode::BASIC }

      it { is_expected.to eq(Sai::Terminal::ColorMode::BASIC) }
    end

    context 'when terminal has no color support' do
      let(:color_support) { Sai::Terminal::ColorMode::NO_COLOR }

      it { is_expected.to eq(Sai::Terminal::ColorMode::NO_COLOR) }
    end
  end

  describe '.auto' do
    subject(:auto) { described_class.auto }

    before do
      allow(Sai::Terminal::Capabilities).to receive(:detect_color_support).and_return(color_support)
    end

    context 'when terminal supports true color' do
      let(:color_support) { Sai::Terminal::ColorMode::TRUE_COLOR }

      it { is_expected.to eq(Sai::Terminal::ColorMode::TRUE_COLOR) }
    end

    context 'when terminal supports 8-bit color' do
      let(:color_support) { Sai::Terminal::ColorMode::ADVANCED }

      it { is_expected.to eq(Sai::Terminal::ColorMode::ADVANCED) }
    end

    context 'when terminal supports 4-bit color' do
      let(:color_support) { Sai::Terminal::ColorMode::ANSI }

      it { is_expected.to eq(Sai::Terminal::ColorMode::ANSI) }
    end

    context 'when terminal supports 3-bit color' do
      let(:color_support) { Sai::Terminal::ColorMode::BASIC }

      it { is_expected.to eq(Sai::Terminal::ColorMode::BASIC) }
    end

    context 'when terminal has no color support' do
      let(:color_support) { Sai::Terminal::ColorMode::NO_COLOR }

      it { is_expected.to eq(Sai::Terminal::ColorMode::NO_COLOR) }
    end
  end

  describe '.basic' do
    subject(:basic) { described_class.basic }

    it { is_expected.to eq(Sai::Terminal::ColorMode::BASIC) }
  end

  describe '.basic_auto' do
    subject(:basic_auto) { described_class.basic_auto }

    before do
      allow(Sai::Terminal::Capabilities).to receive(:detect_color_support).and_return(color_support)
    end

    context 'when terminal supports true color' do
      let(:color_support) { Sai::Terminal::ColorMode::TRUE_COLOR }

      it { is_expected.to eq(Sai::Terminal::ColorMode::BASIC) }
    end

    context 'when terminal supports 8-bit color' do
      let(:color_support) { Sai::Terminal::ColorMode::ADVANCED }

      it { is_expected.to eq(Sai::Terminal::ColorMode::BASIC) }
    end

    context 'when terminal supports 4-bit color' do
      let(:color_support) { Sai::Terminal::ColorMode::ANSI }

      it { is_expected.to eq(Sai::Terminal::ColorMode::BASIC) }
    end

    context 'when terminal supports 3-bit color' do
      let(:color_support) { Sai::Terminal::ColorMode::BASIC }

      it { is_expected.to eq(Sai::Terminal::ColorMode::BASIC) }
    end

    context 'when terminal has no color support' do
      let(:color_support) { Sai::Terminal::ColorMode::NO_COLOR }

      it { is_expected.to eq(Sai::Terminal::ColorMode::NO_COLOR) }
    end
  end

  describe '.no_color' do
    subject(:no_color) { described_class.no_color }

    it { is_expected.to eq(Sai::Terminal::ColorMode::NO_COLOR) }
  end

  describe '.true_color' do
    subject(:true_color) { described_class.true_color }

    it { is_expected.to eq(Sai::Terminal::ColorMode::TRUE_COLOR) }
  end
end
