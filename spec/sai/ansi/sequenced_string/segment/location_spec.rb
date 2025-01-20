# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::ANSI::SequencedString::Segment::Location do
  describe '.new' do
    subject(:location) { described_class.new(end_position: end_pos, start_position: start_pos) }

    let(:end_pos)   { 10 }
    let(:start_pos) { 3 }

    it 'is expected to set the end_position and start_position' do
      expect(location).to have_attributes(end_position: 10, start_position: 3)
    end

    it { is_expected.to be_frozen }
  end
end
