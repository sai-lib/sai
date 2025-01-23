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

  describe 'color registration' do
    subject(:register_color) { Sai::Registry.register(color_name, color_value) }

    let(:color_name) { :test_color }
    let(:color_value) { [255, 0, 0] }
    let(:text) { 'test' }

    after do
      if described_class.singleton_methods.include?(color_name)
        described_class.singleton_class.send(:remove_method,
                                             color_name)
      end
      if described_class.singleton_methods.include?(:"on_#{color_name}")
        described_class.singleton_class.send(:remove_method,
                                             :"on_#{color_name}")
      end
    end

    it 'is expected to define a foreground color method' do
      register_color
      expect(described_class).to respond_to(color_name)
    end

    it 'is expected to define a background color method' do
      register_color
      expect(described_class).to respond_to(:"on_#{color_name}")
    end

    it 'is expected to delegate foreground method to Decorator' do
      register_color
      result = described_class.public_send(color_name).with_mode(described_class.mode.true_color).decorate(text)
      expect(result.to_s).to eq("\e[38;2;255;0;0m#{text}\e[0m")
    end

    it 'is expected to delegate background method to Decorator' do
      register_color
      result = described_class.public_send(:"on_#{color_name}")
                              .with_mode(described_class.mode.true_color)
                              .decorate(text)
      expect(result.to_s).to eq("\e[48;2;255;0;0m#{text}\e[0m")
    end

    context 'when registering multiple colors' do
      let(:colors) do
        {
          test_blue: [0, 0, 255],
          test_green: [0, 255, 0]
        }
      end

      before do
        colors.each { |name, value| Sai::Registry.register(name, value) }
      end

      after do
        colors.each_key do |name|
          described_class.singleton_class.send(:remove_method, name) if described_class.singleton_methods.include?(name)
          if described_class.singleton_methods.include?(:"on_#{name}")
            described_class.singleton_class.send(:remove_method,
                                                 :"on_#{name}")
          end
        end
      end

      it 'is expected to create all color methods' do
        colors.each_key do |name|
          expect(described_class).to respond_to(name).and(respond_to(:"on_#{name}"))
        end
      end
    end
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
