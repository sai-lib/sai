# frozen_string_literal: true

require 'spec_helper'

# frozen_string_literal: true

RSpec.describe Sai do
  describe '.mode' do
    subject(:mode) { described_class.mode }

    it { is_expected.to eq(Sai::ModeSelector) }
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

  describe 'delegated decorator methods' do
    shared_examples 'a delegated method without arguments' do |method|
      subject(:delegated_call) { described_class.public_send(method) }

      let(:decorator_instance) { instance_spy(Sai::Decorator) }

      before do
        allow(Sai::Decorator).to receive(:new).with(mode: described_class.mode.auto).and_return(decorator_instance)
      end

      it 'is expected to delegate the method call to a new Decorator instance' do
        delegated_call
        expect(decorator_instance).to have_received(method).with(no_args)
      end
    end

    shared_examples 'a delegated method with hex argument' do
      subject(:delegated_call) { described_class.hex('#FF0000') }

      let(:decorator_instance) { instance_spy(Sai::Decorator) }

      before do
        allow(Sai::Decorator).to receive(:new).with(mode: described_class.mode.auto).and_return(decorator_instance)
      end

      it 'is expected to delegate the method call to a new Decorator instance' do
        delegated_call
        expect(decorator_instance).to have_received(:hex).with('#FF0000')
      end
    end

    shared_examples 'a delegated method with rgb arguments' do
      subject(:delegated_call) { described_class.rgb(255, 0, 0) }

      let(:decorator_instance) { instance_spy(Sai::Decorator) }

      before do
        allow(Sai::Decorator).to receive(:new).with(mode: described_class.mode.auto).and_return(decorator_instance)
      end

      it 'is expected to delegate the method call to a new Decorator instance' do
        delegated_call
        expect(decorator_instance).to have_received(:rgb).with(255, 0, 0)
      end
    end

    describe '.red' do
      include_examples 'a delegated method without arguments', :red
    end

    describe '.blue' do
      include_examples 'a delegated method without arguments', :blue
    end

    describe '.bold' do
      include_examples 'a delegated method without arguments', :bold
    end

    describe '.italic' do
      include_examples 'a delegated method without arguments', :italic
    end

    describe '.hex' do
      include_examples 'a delegated method with hex argument'
    end

    describe '.rgb' do
      include_examples 'a delegated method with rgb arguments'
    end

    describe 'excluded methods' do
      %i[apply call decorate encode].each do |method|
        it "is not expected to respond to ##{method}" do
          expect(described_class).not_to respond_to(method)
        end
      end
    end
  end
end
