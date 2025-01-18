# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai do
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
end
