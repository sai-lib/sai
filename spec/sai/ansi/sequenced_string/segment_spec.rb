# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::ANSI::SequencedString::Segment do
  let(:options) do
    {
      background: "\e[44m",
      foreground: "\e[31m",
      encoded_end: 10,
      encoded_start: 5,
      stripped_end: 7,
      stripped_start: 3,
      styles: ["\e[1m"],
      text: 'hello'
    }
  end

  describe '.new' do
    subject(:segment) { described_class.new(**options) }

    it 'is expected to initialize background, foreground, styles, text, and location info' do
      expect(segment).to have_attributes(
        background: "\e[44m",
        foreground: "\e[31m",
        styles: contain_exactly("\e[1m"),
        text: 'hello'
      )
    end

    it 'is expected to initialize encoded_location properly' do
      expect(segment.encoded_location).to have_attributes(
        start_position: 5,
        end_position: 10
      )
    end

    it 'is expected to initialize stripped_location properly' do
      expect(segment.stripped_location).to have_attributes(
        start_position: 3,
        end_position: 7
      )
    end

    it { is_expected.to be_frozen }
  end
end
