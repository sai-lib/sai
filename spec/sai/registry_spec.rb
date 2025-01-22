# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::Registry do
  describe '.[]' do
    subject(:fetch) { described_class[color_name] }

    context 'when the color exists' do
      before { described_class.register(color_name, color_value) }

      let(:color_name) { :red }
      let(:color_value) { [255, 0, 0] }

      it 'is expected to return the color value' do
        expect(fetch).to eq(color_value)
      end
    end

    context 'when the color does not exist' do
      let(:color_name) { :red }

      it { is_expected.to be_nil }
    end
  end

  describe '.names' do
    subject(:names) { described_class.names }

    context 'when there are no colors' do
      it { is_expected.to be_empty }
    end

    context 'when there are colors' do
      before do
        described_class.register(:red, [255, 0, 0])
        described_class.register(:blue, [0, 0, 255])
      end

      it 'is expected to return all color names' do
        expect(names).to eq(%i[blue red])
      end
    end
  end

  describe '.register' do
    subject(:register) { described_class.register(color_name, color_value) }

    context 'when the color is registered' do
      let(:color_name) { :red }
      let(:color_value) { [255, 0, 0] }

      it 'is expected to return true' do
        expect(register).to be(true)
      end

      it 'is expected to register the color' do
        register
        expect(described_class[color_name]).to eq(color_value)
      end
    end

    context 'when registering multiple colors concurrently' do
      it 'is expected to handle concurrent registration safely' do
        colors = Array.new(50) { |i| [:"color_#{i}", [i, i, i]] }

        threads = colors.map do |color_name, color_value|
          Thread.new do
            sleep(rand(0.001..0.005))
            described_class.register(color_name, color_value)
          end
        end

        threads.each(&:join)

        registered_colors = colors.all? do |color_name, color_value|
          described_class[color_name] == color_value && described_class.names.include?(color_name)
        end

        expect(registered_colors).to be true
      end
    end
  end
end
