# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai do
  let(:color_mode) { Sai::Terminal::ColorMode::TRUE_COLOR }

  before do
    allow(Sai::Terminal::Capabilities).to receive(:detect_color_support).and_return(color_mode)
  end

  describe '.support' do
    subject(:support) { described_class.support }

    it 'is expected to return a frozen Support instance' do
      expect(support).to be_a(Sai::Support).and(be_frozen)
    end

    it 'is expected to memoize the Support instance' do
      first_call = described_class.support
      second_call = described_class.support

      expect(first_call).to be(second_call)
    end
  end

  describe 'module inclusion' do
    let(:including_class) do
      Class.new do
        include Sai
      end
    end

    let(:instance) { including_class.new }

    describe '#decorator' do
      subject(:decorator) { instance.decorator }

      let(:decorator_double) { instance_double(Sai::Decorator) }

      before do
        allow(Sai::Decorator).to receive(:new).with(color_mode).and_return(decorator_double)
        decorator
      end

      it 'is expected to return a new Decorator instance' do
        expect(Sai::Decorator).to have_received(:new).with(color_mode)
      end
    end

    describe '#terminal_color_support' do
      subject(:terminal_color_support) { instance.terminal_color_support }

      it 'is expected to return the support instance' do
        expect(terminal_color_support).to be(described_class.support)
      end
    end
  end

  describe 'delegated decorator methods' do
    shared_examples 'a delegated method without arguments' do |method|
      subject(:delegated_call) { described_class.public_send(method) }

      let(:decorator_instance) { instance_spy(Sai::Decorator) }

      before do
        allow(Sai::Decorator).to receive(:new).and_return(decorator_instance)
        delegated_call
      end

      it 'is expected to create a new Decorator with the current color mode' do
        expect(Sai::Decorator).to have_received(:new).with(color_mode)
      end

      it 'is expected to delegate the method call to the Decorator instance' do
        expect(decorator_instance).to have_received(method).with(no_args)
      end
    end

    shared_examples 'a delegated method with hex argument' do
      subject(:delegated_call) { described_class.hex('#FF0000') }

      let(:decorator_instance) { instance_spy(Sai::Decorator) }

      before do
        allow(Sai::Decorator).to receive(:new).and_return(decorator_instance)
        delegated_call
      end

      it 'is expected to create a new Decorator with the current color mode' do
        expect(Sai::Decorator).to have_received(:new).with(color_mode)
      end

      it 'is expected to delegate the method call to the Decorator instance' do
        expect(decorator_instance).to have_received(:hex).with('#FF0000')
      end
    end

    shared_examples 'a delegated method with rgb arguments' do
      subject(:delegated_call) { described_class.rgb(255, 0, 0) }

      let(:decorator_instance) { instance_spy(Sai::Decorator) }

      before do
        allow(Sai::Decorator).to receive(:new).and_return(decorator_instance)
        delegated_call
      end

      it 'is expected to create a new Decorator with the current color mode' do
        expect(Sai::Decorator).to have_received(:new).with(color_mode)
      end

      it 'is expected to delegate the method call to the Decorator instance' do
        expect(decorator_instance).to have_received(:rgb).with(255, 0, 0)
      end
    end

    # Test methods without arguments
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

    # Test methods with arguments
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

  describe 'thread safety' do
    describe '.color_mode' do
      subject(:color_mode_value) { described_class.send(:color_mode) }

      before do
        Thread.current[:sai_color_mode] = nil
      end

      it 'is expected to store color mode in thread local storage' do
        expect { color_mode_value }
          .to change { Thread.current[:sai_color_mode] }
          .from(nil)
          .to(color_mode)
      end

      it 'is expected to memoize the color mode per thread' do # rubocop:disable RSpec/MultipleExpectations
        first_call = described_class.send(:color_mode)
        described_class.send(:color_mode)

        expect(Sai::Terminal::Capabilities)
          .to have_received(:detect_color_support).once
        expect(first_call).to eq(color_mode)
      end
    end

    describe 'thread isolation' do
      it 'is expected to maintain color mode isolation' do
        Thread.current[:sai_color_mode] = color_mode
        alternate_thread = Thread.new do
          Thread.current[:sai_color_mode] = Sai::Terminal::ColorMode::BASIC
          Thread.current[:sai_color_mode]
        end

        expect(alternate_thread.value).to eq(Sai::Terminal::ColorMode::BASIC)
      end

      it 'is expected to maintain the original thread color mode' do
        Thread.current[:sai_color_mode] = color_mode
        Thread.new do
          Thread.current[:sai_color_mode] = Sai::Terminal::ColorMode::BASIC
        end.join

        expect(Thread.current[:sai_color_mode]).to eq(color_mode)
      end
    end
  end
end
