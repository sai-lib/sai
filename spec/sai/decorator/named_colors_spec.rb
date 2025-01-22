# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::Decorator::NamedColors do
  describe '.install' do
    subject(:install) { described_class.install(color_name) }

    let(:color_name) { :test_color }
    let(:color) { :test_color }
    let(:decorator) { Sai::Decorator.new }
    let(:background) { :background }
    let(:foreground) { :foreground }

    before do
      Sai::NamedColors.register(color_name, [255, 0, 0])
    end

    after do
      # Clean up test methods to avoid polluting other specs
      Sai::Decorator.undef_method(color_name) if Sai::Decorator.method_defined?(color_name)
      Sai::Decorator.undef_method(:"on_#{color_name}") if Sai::Decorator.method_defined?(:"on_#{color_name}")
    end

    context 'when the methods do not exist' do
      it 'is expected to add a foreground color method' do
        install
        allow(decorator).to receive(:apply_named_color)
        decorator.public_send(color_name)

        expect(decorator).to have_received(:apply_named_color).with(:foreground, color)
      end

      it 'is expected to add a background color method' do
        install
        allow(decorator).to receive(:apply_named_color)
        decorator.public_send(:"on_#{color_name}")

        expect(decorator).to have_received(:apply_named_color).with(:background, color)
      end
    end

    context 'when the methods already exist' do
      before do
        install
      end

      it 'is expected to redefine the foreground color method' do
        install
        allow(decorator).to receive(:apply_named_color)
        decorator.public_send(color_name)

        expect(decorator).to have_received(:apply_named_color).with(:foreground, color)
      end

      it 'is expected to redefine the background color method' do
        install
        allow(decorator).to receive(:apply_named_color)
        decorator.public_send(:"on_#{color_name}")

        expect(decorator).to have_received(:apply_named_color).with(:background, color)
      end
    end
  end
end
