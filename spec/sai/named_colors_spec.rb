# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::NamedColors do
  before do
    described_class.instance_variable_set(:@registry, nil)
    described_class.instance_variable_set(:@names, nil)
  end

  after do
    described_class.instance_variable_set(
      :@registry,
      described_class::CSS.merge(described_class::XTERM).merge(described_class::ANSI)
    )
    described_class.names.each { |name| Sai::Decorator::NamedColors.install(name) }
    described_class.instance_variable_set(:@names, nil)
  end

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

    it 'is expected to memoize the result' do
      first_call = described_class.names.object_id
      second_call = described_class.names.object_id
      expect(first_call).to eq(second_call)
    end
  end

  describe '.register' do
    subject(:register) { described_class.register(name, value) }

    let(:name) { :test_color }
    let(:value) { [100, 100, 100] }
    let(:decorator) { Sai::Decorator.new }

    after do
      # Clean up test methods
      Sai::Decorator.undef_method(name) if Sai::Decorator.method_defined?(name)
      Sai::Decorator.undef_method(:"on_#{name}") if Sai::Decorator.method_defined?(:"on_#{name}")
    end

    it 'is expected to register a new color' do
      register
      expect(described_class[name]).to eq(value)
    end

    it 'is expected to add the color name to names list' do
      register
      expect(described_class.names).to include(name)
    end

    it 'is expected to install color methods on Decorator' do
      register
      expect(decorator).to respond_to(name).and(respond_to(:"on_#{name}"))
    end

    context 'when registering multiple colors concurrently' do
      after do
        # Clean up concurrent test methods
        50.times do |i|
          color_name = :"color_#{i}"
          Sai::Decorator.undef_method(color_name) if Sai::Decorator.method_defined?(color_name)
          Sai::Decorator.undef_method(:"on_#{color_name}") if Sai::Decorator.method_defined?(:"on_#{color_name}")
        end
      end

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
          described_class[color_name] == color_value &&
            described_class.names.include?(color_name) &&
            decorator.respond_to?(color_name) &&
            decorator.respond_to?(:"on_#{color_name}")
        end

        expect(registered_colors).to be true
      end
    end

    context 'when overriding an existing color' do
      let(:name) { :red }
      let(:value) { [255, 0, 0] }

      it 'is expected to override the existing color' do
        register
        expect(described_class[name]).to eq(value)
      end

      it 'is expected to not duplicate the name in the names list' do
        original_names = described_class.names
        register
        expect(described_class.names.length).to eq(original_names.length)
      end

      it 'is expected to update the existing color methods' do
        register
        expect(decorator.with_mode(Sai.mode.true_color).send(name).decorate('test').to_s).to(
          eq("\e[38;2;255;0;0mtest\e[0m")
        )
      end
    end
  end
end
