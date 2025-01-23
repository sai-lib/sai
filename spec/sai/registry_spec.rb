# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::Registry do
  let(:subscriber) do
    Class.new do
      def self.on_color_registration(name); end
    end
  end

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

    before do
      described_class.subscribe(subscriber)
      allow(subscriber).to receive(:on_color_registration)
    end

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

      it 'is expected to notify subscribers' do
        register
        expect(subscriber).to have_received(:on_color_registration).with(color_name)
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

  describe '.subscribe' do
    subject(:subscribe) { described_class.subscribe(subscriber) }

    before do
      allow(subscriber).to receive(:on_color_registration)
      subscribe
    end

    it 'is expected to notify the subscriber when colors are registered' do
      described_class.register(:test_color, [255, 0, 0])
      expect(subscriber).to have_received(:on_color_registration).with(:test_color)
    end

    it 'is expected to notify the subscriber for each registered color' do
      described_class.register(:color1, [255, 0, 0])
      described_class.register(:color2, [0, 255, 0])

      %i[color1 color2].each do |color_name|
        expect(subscriber).to have_received(:on_color_registration).with(color_name)
      end
    end

    context 'when subscriber does not respond to :on_color_registration' do
      let(:subscriber) { Class.new }

      it 'is expected not to raise an error on registration' do
        expect { described_class.register(:test_color, [255, 0, 0]) }.not_to raise_error
      end
    end
  end
end
