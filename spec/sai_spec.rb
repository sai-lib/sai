# frozen_string_literal: true

require 'spec_helper'

# frozen_string_literal: true

RSpec.describe Sai do
  describe '.mode' do
    subject(:mode) { described_class.mode }

    it { is_expected.to eq(Sai::ModeSelector) }
  end

  describe '.register' do
    subject(:register) { described_class.register(color_name, color_value) }

    before do
      allow(Sai::Registry).to receive(:register)
    end

    let(:color_name) { :test }
    let(:color_value) { '#FF0000' }

    it 'is expected to register the color' do
      register

      expect(Sai::Registry).to have_received(:register).with(color_name, color_value)
    end
  end

  describe '.sequence' do
    subject(:sequence) { described_class.sequence(text) }

    let(:text) { "\e[31mHello, World!\e[0m" }

    it { is_expected.to be_a(Sai::ANSI::SequencedString) }
  end

  describe '.support' do
    subject(:support) { described_class.support }

    it { is_expected.to eq(Sai::Support) }
  end

  describe 'module inclusion' do
    let(:including_class) do
      Class.new do
        include Sai
      end
    end

    let(:instance) { including_class.new }

    describe '#color_mode' do
      subject(:color_mode) { instance.color_mode }

      it { is_expected.to eq(Sai::ModeSelector) }
    end

    describe '#decorator' do
      subject(:decorator) { instance.decorator(mode: mode) }

      let(:decorator_double) { instance_double(Sai::Decorator) }
      let(:mode) { described_class.mode.auto }

      before do
        allow(Sai::Decorator).to receive(:new).with(mode: mode).and_return(decorator_double)
      end

      it 'is expected to return a new Decorator instance with the specified mode' do
        decorator
        expect(Sai::Decorator).to have_received(:new).with(mode: mode)
      end

      context 'when no mode is specified' do
        subject(:decorator) { instance.decorator }

        it 'is expected to use auto mode by default' do
          decorator
          expect(Sai::Decorator).to have_received(:new).with(mode: described_class.mode.auto)
        end
      end
    end

    describe '#terminal_color_support' do
      subject(:terminal_color_support) { instance.terminal_color_support }

      it { is_expected.to eq(Sai::Support) }
    end
  end
end
