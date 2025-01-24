# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::Terminal::Capabilities do
  describe '.detect_color_support' do
    subject(:detect_color_support) { described_class.detect_color_support }

    before { described_class.instance_variable_set(:@detect_color_support, nil) }

    context 'when NO_COLOR environment variable is set' do
      before do
        stub_const('ENV', { 'NO_COLOR' => 'true' })
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it { is_expected.to eq(Sai::Terminal::ColorMode::NO_COLOR) }
    end

    context 'when stdout is not a TTY' do
      before do
        stub_const('ENV', {})
        allow($stdout).to receive(:tty?).and_return(false)
      end

      it { is_expected.to eq(Sai::Terminal::ColorMode::NO_COLOR) }
    end

    context 'when COLORTERM indicates true color support' do
      before do
        stub_const('ENV', { 'COLORTERM' => 'truecolor' })
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it { is_expected.to eq(Sai::Terminal::ColorMode::TRUE_COLOR) }
    end

    context 'when TERM indicates true color support' do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      context 'with xterm-direct' do
        before { stub_const('ENV', { 'TERM' => 'xterm-direct' }) }

        it { is_expected.to eq(Sai::Terminal::ColorMode::TRUE_COLOR) }
      end

      context 'with xterm-truecolor' do
        before { stub_const('ENV', { 'TERM' => 'xterm-truecolor' }) }

        it { is_expected.to eq(Sai::Terminal::ColorMode::TRUE_COLOR) }
      end
    end

    context 'when TERM_PROGRAM indicates true color support' do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      context 'with iTerm.app' do
        before { stub_const('ENV', { 'TERM_PROGRAM' => 'iTerm.app' }) }

        it { is_expected.to eq(Sai::Terminal::ColorMode::TRUE_COLOR) }
      end

      context 'with WezTerm' do
        before { stub_const('ENV', { 'TERM_PROGRAM' => 'WezTerm' }) }

        it { is_expected.to eq(Sai::Terminal::ColorMode::TRUE_COLOR) }
      end

      context 'with vscode' do
        before { stub_const('ENV', { 'TERM_PROGRAM' => 'vscode' }) }

        it { is_expected.to eq(Sai::Terminal::ColorMode::TRUE_COLOR) }
      end
    end

    context 'when TERM indicates 256 color support' do
      before do
        stub_const('ENV', { 'TERM' => 'xterm-256color' })
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it { is_expected.to eq(Sai::Terminal::ColorMode::ADVANCED) }
    end

    context 'when COLORTERM indicates 256 color support' do
      before do
        stub_const('ENV', { 'COLORTERM' => '256' })
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it { is_expected.to eq(Sai::Terminal::ColorMode::ADVANCED) }
    end

    context 'when TERM indicates ANSI color support' do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      %w[xterm screen vt100 ansi].each do |term|
        context "with #{term}" do
          before { stub_const('ENV', { 'TERM' => term }) }

          it { is_expected.to eq(Sai::Terminal::ColorMode::ANSI) }
        end
      end
    end

    context 'when COLORTERM is set but does not indicate specific support' do
      before do
        stub_const('ENV', { 'COLORTERM' => 'yes' })
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it { is_expected.to eq(Sai::Terminal::ColorMode::ANSI) }
    end

    context 'when only TERM is set' do
      before do
        stub_const('ENV', { 'TERM' => 'dumb' })
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it { is_expected.to eq(Sai::Terminal::ColorMode::BASIC) }
    end

    context 'when no color environment variables are set' do
      before do
        stub_const('ENV', {})
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it { is_expected.to eq(Sai::Terminal::ColorMode::NO_COLOR) }
    end
  end
end
