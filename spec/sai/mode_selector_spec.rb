# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::ModeSelector do
  before do
    described_class.instance_variable_set(:@supported_color_mode, nil)
  end

  shared_context 'when 24-bit color is supported' do
    before do
      allow(Sai::Support).to receive(:twenty_four_bit?).and_return(true)
    end
  end

  shared_context 'when only 8-bit color is supported' do
    before do
      allow(Sai::Support).to receive_messages(twenty_four_bit?: false, eight_bit?: true)
    end
  end

  shared_context 'when only 4-bit color is supported' do
    before do
      allow(Sai::Support).to receive_messages(twenty_four_bit?: false, eight_bit?: false, four_bit?: true)
    end
  end

  shared_context 'when only 3-bit color is supported' do
    before do
      allow(Sai::Support).to receive_messages(
        twenty_four_bit?: false,
        eight_bit?: false,
        four_bit?: false,
        three_bit?: true
      )
    end
  end

  shared_context 'when color is not supported' do
    before do
      allow(Sai::Support).to receive_messages(
        twenty_four_bit?: false,
        eight_bit?: false,
        four_bit?: false,
        three_bit?: false,
        color?: false
      )
    end
  end

  describe '.auto' do
    subject(:auto) { described_class.auto }

    context 'when 24-bit color is supported' do
      include_context 'when 24-bit color is supported'

      it { is_expected.to eq(described_class::TWENTY_FOUR_BIT) }
    end

    context 'when only 8-bit color is supported' do
      include_context 'when only 8-bit color is supported'

      it { is_expected.to eq(described_class::EIGHT_BIT) }
    end

    context 'when only 4-bit color is supported' do
      include_context 'when only 4-bit color is supported'

      it { is_expected.to eq(described_class::FOUR_BIT) }
    end

    context 'when only 3-bit color is supported' do
      include_context 'when only 3-bit color is supported'

      it { is_expected.to eq(described_class::THREE_BIT) }
    end

    context 'when color is not supported' do
      include_context 'when color is not supported'

      it { is_expected.to eq(described_class::NO_COLOR) }
    end
  end

  describe '.eight_bit' do
    subject(:eight_bit) { described_class.eight_bit }

    it { is_expected.to eq(described_class::EIGHT_BIT) }
  end

  describe '.eight_bit_auto' do
    subject(:eight_bit_auto) { described_class.eight_bit_auto }

    context 'when 24-bit color is supported' do
      include_context 'when 24-bit color is supported'

      it { is_expected.to eq(described_class::EIGHT_BIT) }
    end

    context 'when only 8-bit color is supported' do
      include_context 'when only 8-bit color is supported'

      it { is_expected.to eq(described_class::EIGHT_BIT) }
    end

    context 'when only 4-bit color is supported' do
      include_context 'when only 4-bit color is supported'

      it { is_expected.to eq(described_class::FOUR_BIT) }
    end

    context 'when only 3-bit color is supported' do
      include_context 'when only 3-bit color is supported'

      it { is_expected.to eq(described_class::THREE_BIT) }
    end

    context 'when color is not supported' do
      include_context 'when color is not supported'

      it { is_expected.to eq(described_class::NO_COLOR) }
    end
  end

  describe '.four_bit' do
    subject(:four_bit) { described_class.four_bit }

    it { is_expected.to eq(described_class::FOUR_BIT) }
  end

  describe '.four_bit_auto' do
    subject(:four_bit_auto) { described_class.four_bit_auto }

    context 'when 24-bit color is supported' do
      include_context 'when 24-bit color is supported'

      it { is_expected.to eq(described_class::FOUR_BIT) }
    end

    context 'when only 8-bit color is supported' do
      include_context 'when only 8-bit color is supported'

      it { is_expected.to eq(described_class::FOUR_BIT) }
    end

    context 'when only 4-bit color is supported' do
      include_context 'when only 4-bit color is supported'

      it { is_expected.to eq(described_class::FOUR_BIT) }
    end

    context 'when only 3-bit color is supported' do
      include_context 'when only 3-bit color is supported'

      it { is_expected.to eq(described_class::THREE_BIT) }
    end

    context 'when color is not supported' do
      include_context 'when color is not supported'

      it { is_expected.to eq(described_class::NO_COLOR) }
    end
  end

  describe '.no_color' do
    subject(:no_color) { described_class.no_color }

    it { is_expected.to eq(described_class::NO_COLOR) }
  end

  describe '.three_bit' do
    subject(:three_bit) { described_class.three_bit }

    it { is_expected.to eq(described_class::THREE_BIT) }
  end

  describe '.three_bit_auto' do
    subject(:three_bit_auto) { described_class.three_bit_auto }

    context 'when 24-bit color is supported' do
      include_context 'when 24-bit color is supported'

      it { is_expected.to eq(described_class::THREE_BIT) }
    end

    context 'when only 8-bit color is supported' do
      include_context 'when only 8-bit color is supported'

      it { is_expected.to eq(described_class::THREE_BIT) }
    end

    context 'when only 4-bit color is supported' do
      include_context 'when only 4-bit color is supported'

      it { is_expected.to eq(described_class::THREE_BIT) }
    end

    context 'when only 3-bit color is supported' do
      include_context 'when only 3-bit color is supported'

      it { is_expected.to eq(described_class::THREE_BIT) }
    end

    context 'when color is not supported' do
      include_context 'when color is not supported'

      it { is_expected.to eq(described_class::NO_COLOR) }
    end
  end

  describe '.twenty_four_bit' do
    subject(:twenty_four_bit) { described_class.twenty_four_bit }

    it { is_expected.to eq(described_class::TWENTY_FOUR_BIT) }
  end
end
