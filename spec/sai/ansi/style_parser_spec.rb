# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::ANSI::StyleParser do
  subject(:style_parser) { described_class.new(segment) }

  let(:segment) { { styles: [] } }

  describe '#parse' do
    subject(:parse) { style_parser.parse(code) }

    context 'when given a valid basic style code (1-9)' do
      let(:code) { 1 }

      it 'is expected to add the style code to the segment' do
        parse
        expect(segment[:styles]).to eq(['1'])
      end
    end

    context 'when given a valid extended style code (21-29)' do
      let(:code) { 21 }

      it 'is expected to add the style code to the segment' do
        parse
        expect(segment[:styles]).to eq(['21'])
      end
    end

    context 'when given an invalid style code' do
      let(:code) { 10 }

      it 'is expected to not modify the segment styles' do
        parse
        expect(segment[:styles]).to be_empty
      end
    end

    context 'when given multiple valid style codes' do
      it 'is expected to accumulate all valid styles' do
        style_parser.parse(1)
        style_parser.parse(4)
        style_parser.parse(21)
        expect(segment[:styles]).to eq(%w[1 4 21])
      end
    end
  end
end
