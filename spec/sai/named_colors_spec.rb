# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::NamedColors do
  describe '.[]' do
    subject(:fetch) { described_class[name] }

    described_class::ANSI.each_key do |name|
      context "when name is #{name}" do
        let(:name) { name }

        it 'is expected to return the correct RGB values' do
          expect(fetch).to eq(described_class::ANSI[name])
        end
      end
    end

    described_class::XTERM.each_key do |name|
      context "when name is #{name}" do
        let(:name) { name }

        it 'is expected to return the correct RGB values' do
          expect(fetch).to eq(described_class::XTERM[name]).or(eq(described_class::ANSI[name]))
        end
      end
    end

    described_class::CSS.each_key do |name|
      context "when name is #{name}" do
        let(:name) { name }

        it 'is expected to return the correct RGB values' do
          expect(fetch).to eq(described_class::CSS[name])
            .or(eq(described_class::XTERM[name]))
            .or(eq(described_class::ANSI[name]))
        end
      end
    end
  end

  describe '.names' do
    subject(:names) { described_class.names }

    it 'is expected to return all color names' do
      expect(names).to eq(
        (described_class::ANSI.keys + described_class::XTERM.keys + described_class::CSS.keys).uniq.sort
      )
    end
  end
end
