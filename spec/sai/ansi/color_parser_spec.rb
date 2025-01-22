# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::ANSI::ColorParser do
  subject(:color_parser) { described_class.new(segment) }

  let(:segment) { { foreground: nil, background: nil, styles: [] } }

  describe '#parse_basic' do
    subject(:parse_basic) { color_parser.parse_basic(code) }

    context 'when given a foreground color code (30-37)' do
      let(:code) { 31 }

      it 'is expected to set the foreground color in the segment' do
        parse_basic
        expect(segment[:foreground]).to eq('31')
      end
    end

    context 'when given a background color code (40-47)' do
      let(:code) { 41 }

      it 'is expected to set the background color in the segment' do
        parse_basic
        expect(segment[:background]).to eq('41')
      end
    end
  end

  describe '#parse256' do
    subject(:parse256) { color_parser.parse256(codes, index) }

    let(:index) { 0 }

    context 'when parsing foreground color (38;5;n)' do
      let(:codes) { [38, 5, 160] }

      it 'is expected to set the foreground color in the segment' do
        parse256
        expect(segment[:foreground]).to eq('38;5;160')
      end

      it 'is expected to return the updated index' do
        expect(parse256).to eq(3)
      end
    end

    context 'when parsing background color (48;5;n)' do
      let(:codes) { [48, 5, 21] }

      it 'is expected to set the background color in the segment' do
        parse256
        expect(segment[:background]).to eq('48;5;21')
      end

      it 'is expected to return the updated index' do
        expect(parse256).to eq(3)
      end
    end
  end

  describe '#parse_24bit' do
    subject(:parse_24bit) { color_parser.parse_24bit(codes, index) }

    let(:index) { 0 }

    context 'when parsing foreground color (38;2;r;g;b)' do
      let(:codes) { [38, 2, 255, 0, 0] }

      it 'is expected to set the foreground color in the segment' do
        parse_24bit
        expect(segment[:foreground]).to eq('38;2;255;0;0')
      end

      it 'is expected to return the updated index' do
        expect(parse_24bit).to eq(5)
      end
    end

    context 'when parsing background color (48;2;r;g;b)' do
      let(:codes) { [48, 2, 0, 255, 0] }

      it 'is expected to set the background color in the segment' do
        parse_24bit
        expect(segment[:background]).to eq('48;2;0;255;0')
      end

      it 'is expected to return the updated index' do
        expect(parse_24bit).to eq(5)
      end
    end
  end
end
