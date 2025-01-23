# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::ANSI do
  describe '.install' do
    subject(:install) { described_class.install }

    before { allow(Sai).to receive(:register) }

    it 'is expected to register the colors' do
      install

      described_class::COLORS.each_pair do |name, color|
        expect(Sai).to have_received(:register).with(name, color)
      end
    end
  end
end
