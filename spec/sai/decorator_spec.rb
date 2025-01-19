# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::Decorator do
  describe '.new' do
    subject(:decorator) { described_class.new(color_mode) }

    let(:color_mode) { Sai::Terminal::ColorMode::TRUE_COLOR }

    it 'is expected to initialize with empty styles' do
      expect(decorator.instance_variable_get(:@styles)).to eq([])
    end

    it 'is expected to initialize with nil foreground' do
      expect(decorator.instance_variable_get(:@foreground)).to be_nil
    end

    it 'is expected to initialize with nil background' do
      expect(decorator.instance_variable_get(:@background)).to be_nil
    end

    it 'is expected to initialize with the provided color mode' do
      expect(decorator.instance_variable_get(:@color_mode)).to eq(color_mode)
    end
  end

  describe '#decorate' do
    subject(:decorated_text) { decorator.decorate(text) }

    let(:decorator) { described_class.new(color_mode) }
    let(:color_mode) { Sai::Terminal::ColorMode::TRUE_COLOR }
    let(:text) { 'Hello, world!' }

    context 'when no styles or colors are applied' do
      it 'is expected to return the original text' do
        expect(decorated_text).to eq(text)
      end
    end

    context 'when a foreground color is applied' do
      before { decorator.red }

      it 'is expected to wrap the text with the color sequence and reset' do
        expect(decorated_text).to eq("\e[38;2;205;0;0m#{text}\e[0m")
      end
    end

    context 'when a background color is applied' do
      before { decorator.on_blue }

      it 'is expected to wrap the text with the color sequence and reset' do
        expect(decorated_text).to eq("\e[48;2;0;0;238m#{text}\e[0m")
      end
    end

    context 'when styles are applied' do
      before { decorator.bold }

      it 'is expected to wrap the text with the style sequence and reset' do
        expect(decorated_text).to eq("\e[1m#{text}\e[0m")
      end
    end

    context 'when multiple decorations are applied' do
      before do
        decorator.red.on_blue.bold
      end

      it 'is expected to apply all decorations in order' do
        expect(decorated_text).to eq("\e[38;2;205;0;0m\e[48;2;0;0;238m\e[1m#{text}\e[0m")
      end
    end
  end

  describe '#hex' do
    subject(:hex) { decorator.hex(code) }

    let(:decorator) { described_class.new(Sai::Terminal::ColorMode::TRUE_COLOR) }

    context 'when given a valid hex code' do
      let(:code) { '#EB4133' }

      it 'is expected to set the foreground color' do
        hex
        expect(decorator.instance_variable_get(:@foreground)).to eq(code)
      end

      it 'is expected to return self for chaining' do
        expect(hex).to eq(decorator)
      end
    end

    context 'when given an invalid hex code' do
      let(:code) { 'invalid' }

      it 'is expected to raise an ArgumentError' do
        expect { hex }.to raise_error(ArgumentError, 'Invalid hex color code: invalid')
      end
    end
  end

  describe '#on_hex' do
    subject(:on_hex) { decorator.on_hex(code) }

    let(:decorator) { described_class.new(Sai::Terminal::ColorMode::TRUE_COLOR) }

    context 'when given a valid hex code' do
      let(:code) { '#EB4133' }

      it 'is expected to set the background color' do
        on_hex
        expect(decorator.instance_variable_get(:@background)).to eq(code)
      end

      it 'is expected to return self for chaining' do
        expect(on_hex).to eq(decorator)
      end
    end

    context 'when given an invalid hex code' do
      let(:code) { 'invalid' }

      it 'is expected to raise an ArgumentError' do
        expect { on_hex }.to raise_error(ArgumentError, 'Invalid hex color code: invalid')
      end
    end
  end

  describe '#rgb' do
    subject(:rgb) { decorator.rgb(red, green, blue) }

    let(:decorator) { described_class.new(Sai::Terminal::ColorMode::TRUE_COLOR) }
    let(:red) { 235 }
    let(:green) { 65 }
    let(:blue) { 51 }

    context 'when given valid RGB values' do
      it 'is expected to set the foreground color' do
        rgb
        expect(decorator.instance_variable_get(:@foreground)).to eq([red, green, blue])
      end

      it 'is expected to return self for chaining' do
        expect(rgb).to eq(decorator)
      end
    end

    context 'when given invalid RGB values' do
      let(:red) { 300 }

      it 'is expected to raise an ArgumentError' do
        expect { rgb }.to raise_error(ArgumentError, 'Invalid RGB value: 300, 65, 51')
      end
    end
  end

  describe '#on_rgb' do
    subject(:on_rgb) { decorator.on_rgb(red, green, blue) }

    let(:decorator) { described_class.new(Sai::Terminal::ColorMode::TRUE_COLOR) }
    let(:red) { 235 }
    let(:green) { 65 }
    let(:blue) { 51 }

    context 'when given valid RGB values' do
      it 'is expected to set the background color' do
        on_rgb
        expect(decorator.instance_variable_get(:@background)).to eq([red, green, blue])
      end

      it 'is expected to return self for chaining' do
        expect(on_rgb).to eq(decorator)
      end
    end

    context 'when given invalid RGB values' do
      let(:red) { 300 }

      it 'is expected to raise an ArgumentError' do
        expect { on_rgb }.to raise_error(ArgumentError, 'Invalid RGB value: 300, 65, 51')
      end
    end
  end

  # Test each named color method
  Sai::ANSI::COLOR_NAMES.each_key do |color|
    describe "##{color}" do
      subject(:color_method) { decorator.public_send(color) }

      let(:decorator) { described_class.new(Sai::Terminal::ColorMode::TRUE_COLOR) }

      it 'is expected to set the foreground color' do
        color_method
        expect(decorator.instance_variable_get(:@foreground)).to eq(color)
      end

      it 'is expected to return self for chaining' do
        expect(color_method).to eq(decorator)
      end
    end

    describe "#on_#{color}" do
      subject(:background_color_method) { decorator.public_send(:"on_#{color}") }

      let(:decorator) { described_class.new(Sai::Terminal::ColorMode::TRUE_COLOR) }

      it 'is expected to set the background color' do
        background_color_method
        expect(decorator.instance_variable_get(:@background)).to eq(color)
      end

      it 'is expected to return self for chaining' do
        expect(background_color_method).to eq(decorator)
      end
    end
  end

  # Test each style method
  Sai::ANSI::STYLES.each_key do |style|
    describe "##{style}" do
      subject(:style_method) { decorator.public_send(style) }

      let(:decorator) { described_class.new(Sai::Terminal::ColorMode::TRUE_COLOR) }

      it 'is expected to add the style' do
        style_method
        expect(decorator.instance_variable_get(:@styles)).to include(style)
      end

      it 'is expected to return self for chaining' do
        expect(style_method).to eq(decorator)
      end

      it 'is expected not to duplicate styles' do
        2.times { style_method }
        styles = decorator.instance_variable_get(:@styles)
        expect(styles.count(style)).to eq(1)
      end
    end
  end
end
