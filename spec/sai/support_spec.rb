# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::Support do
  before do
    %i[@color @eight_bit @four_bit @three_bit @twenty_four_bit].each do |ivar|
      described_class.instance_variable_set(ivar, nil)
    end
  end

  describe '.color?' do
    subject(:color?) { described_class.color? }

    context 'when NO_COLOR environment variable is set' do
      before { stub_const('ENV', { 'NO_COLOR' => 'true' }) }

      it { is_expected.to be false }
    end

    context 'when stdout is not a TTY' do
      before { allow($stdout).to receive(:tty?).and_return(false) }

      it { is_expected.to be false }
    end

    context 'when stdout is a TTY and NO_COLOR is not set' do
      before { allow($stdout).to receive(:tty?).and_return(true) }

      it { is_expected.to be true }
    end
  end

  describe '.eight_bit?' do
    subject(:eight_bit?) { described_class.eight_bit? }

    context 'when color is supported and TERM contains 256 color support' do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
        stub_const('ENV', { 'TERM' => 'xterm-256color' })
      end

      it { is_expected.to be true }
    end

    context 'when color is supported and TERM is not set and COLORTERM contains 256 color support' do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
        stub_const('ENV', { 'COLORTERM' => '256' })
      end

      it { is_expected.to be true }
    end

    context 'when color is not supported' do
      before { stub_const('ENV', { 'NO_COLOR' => 'true' }) }

      it { is_expected.to be false }
    end

    context 'when color is supported and TERM is not set and COLORTERM is not set' do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
        stub_const('ENV', {})
      end

      it { is_expected.to be false }
    end
  end

  describe '.four_bit?' do
    subject(:four_bit?) { described_class.four_bit? }

    %w[xterm screen vt100 ansi].each do |term|
      context "when color is supported and TERM contains #{term} color support" do
        before do
          allow($stdout).to receive(:tty?).and_return(true)
          stub_const('ENV', { 'TERM' => term })
        end

        it { is_expected.to be true }
      end
    end

    context 'when color is supported and TERM is not set and COLORTERM is not empty' do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
        stub_const('ENV', { 'COLORTERM' => 'ansi' })
      end

      it { is_expected.to be true }
    end

    context 'when color is not supported' do
      before { stub_const('ENV', { 'NO_COLOR' => 'true' }) }

      it { is_expected.to be false }
    end
  end

  describe '.three_bit?' do
    subject(:three_bit?) { described_class.three_bit? }

    context 'when color is supported' do
      before { allow($stdout).to receive(:tty?).and_return(true) }

      it { is_expected.to be true }
    end

    context 'when color is not supported' do
      before { stub_const('ENV', { 'NO_COLOR' => 'true' }) }

      it { is_expected.to be false }
    end
  end

  describe '.twenty_four_bit?' do
    subject(:twenty_four_bit?) { described_class.twenty_four_bit? }

    %w[truecolor 24bit].each do |color_term|
      context "when color is supported and COLORTERM contains #{color_term} color support" do
        before do
          allow($stdout).to receive(:tty?).and_return(true)
          stub_const('ENV', { 'COLORTERM' => color_term })
        end

        it { is_expected.to be true }
      end
    end

    %w[xterm-direct xterm-truecolor].each do |term|
      context "when color is supported and TERM contains #{term} color support" do
        before do
          allow($stdout).to receive(:tty?).and_return(true)
          stub_const('ENV', { 'TERM' => term })
        end

        it { is_expected.to be true }
      end
    end

    %w[iTerm.app WezTerm vscode].each do |term_program|
      context "when color is supported and TERM_PROGRAM contains #{term_program} color support" do
        before do
          allow($stdout).to receive(:tty?).and_return(true)
          stub_const('ENV', { 'TERM_PROGRAM' => term_program })
        end

        it { is_expected.to be true }
      end
    end

    context 'when color is not supported' do
      before { stub_const('ENV', { 'NO_COLOR' => 'true' }) }

      it { is_expected.to be false }
    end

    context 'when color is supported and TERM, COLORTERM, and TERM_PROGRAM are not set' do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
        stub_const('ENV', {})
      end

      it { is_expected.to be false }
    end
  end
end
