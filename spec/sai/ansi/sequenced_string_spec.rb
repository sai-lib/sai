# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::ANSI::SequencedString do
  describe '.new' do
    subject(:sequenced_string) { described_class.new(input) }

    context 'when given an empty string' do
      let(:input) { '' }

      it 'is expected to create an empty SequencedString' do
        expect(sequenced_string).to be_empty
      end
    end

    context 'when given a plain string (no ANSI codes)' do
      let(:input) { 'Hello world' }

      it 'is expected to create one segment' do
        expect(sequenced_string.size).to eq(1)
      end

      it 'is expected to store the text in the segment' do
        expect(sequenced_string.first.text).to eq('Hello world')
      end
    end

    context 'when given a string with ANSI codes' do
      let(:input) { "Normal \e[31mred\e[0m" }

      it 'is expected to create multiple segments' do
        expect(sequenced_string.size).to eq(2)
      end

      it 'is expected to have a colored segment' do
        colored_segment = sequenced_string.detect { |seg| seg.foreground == '31' }
        expect(colored_segment.text).to eq('red')
      end

      it 'is expected to have a non-colored segment' do
        plain_segment = sequenced_string.detect { |seg| seg.text == 'Normal ' }
        expect(plain_segment.foreground).to be_nil
      end
    end
  end

  describe '#[]' do
    subject(:segment) { sequenced_string[index] }

    let(:sequenced_string) { described_class.new("\e[31mred\e[0m and \e[32mgreen\e[0m") }

    context 'when given a valid index' do
      let(:index) { 0 }

      it 'is expected to return the segment text at that index' do
        expect(segment.text).to eq('red')
      end

      it 'is expected to return the segment foreground at that index' do
        expect(segment.foreground).to eq('31')
      end
    end

    context 'when given an invalid index' do
      let(:index) { 999 }

      it 'is expected to return nil' do
        expect(segment).to be_nil
      end
    end
  end

  describe '#==' do
    subject(:sequence) { described_class.new("\e[31mred\e[0m") }

    context 'when compared to an identical ANSI string' do
      it 'is expected to be equal' do
        expect(sequence).to eq("\e[31mred\e[0m")
      end
    end

    context 'when compared to a different ANSI string' do
      it 'is expected to not be equal' do
        expect(sequence).not_to eq("\e[32mred\e[0m")
      end
    end

    context 'when compared to a plain string' do
      it 'is expected to not be equal' do
        expect(sequence).not_to eq('red')
      end
    end
  end

  describe '#stripped' do
    subject(:stripped) { sequenced_string.stripped }

    context 'with a single ANSI code' do
      let(:sequenced_string) { described_class.new("\e[1mBold\e[0m text") }

      it 'is expected to return the text without ANSI codes' do
        expect(stripped).to eq('Bold text')
      end
    end

    context 'with multiple ANSI codes' do
      let(:sequenced_string) { described_class.new("\e[31;1mColored Bold\e[0m") }

      it 'is expected to return the text without any ANSI codes' do
        expect(stripped).to eq('Colored Bold')
      end
    end
  end

  describe '#to_s' do
    subject(:string) { sequenced_string.to_s }

    context 'with a plain string' do
      let(:sequenced_string) { described_class.new('Hello') }

      it 'is expected to return the original string' do
        expect(string).to eq('Hello')
      end
    end

    context 'with combined color codes' do
      let(:sequenced_string) { described_class.new("\e[31;44mColored\e[0m") }

      it 'is expected to maintain combined sequences' do
        expect(string).to include("\e[31;44mColored\e[0m")
      end
    end

    context 'with style and color' do
      let(:sequenced_string) { described_class.new("\e[31;1mBold Red\e[0m") }

      it 'is expected to maintain combined style and color' do
        expect(string).to eq("\e[31;1mBold Red\e[0m")
      end
    end
  end

  describe '#without_background' do
    subject(:without_background) { sequenced_string.without_background }

    let(:sequenced_string) { described_class.new(input) }
    let(:input) { "\e[31;41mColored BG\e[0m \e[1;31mBold Red\e[0m" }

    it 'is expected to return a SequencedString' do
      expect(without_background).to be_a(described_class)
    end

    it 'is expected to return a new instance' do
      expect(without_background).not_to equal(sequenced_string)
    end

    it 'is expected to omit background color sequence' do
      expect(without_background.to_s).not_to include('41')
    end

    it 'is expected to preserve foreground color sequence' do
      expect(without_background.to_s).to include('31')
    end

    it 'is expected to preserve style sequence' do
      expect(without_background.to_s).to include('1')
    end

    it 'is expected to be chainable' do
      expect(without_background.without_style).to be_a(described_class)
    end

    it 'is expected to maintain correct sequences when chained' do
      chained = without_background.without_style.to_s
      expect(chained).to include('31')
    end
  end

  describe '#without_color' do
    subject(:without_color) { sequenced_string.without_color }

    let(:sequenced_string) { described_class.new(input) }
    let(:input) { "\e[31;42mColored\e[0m \e[1mBold\e[0m" }

    it 'is expected to return a SequencedString' do
      expect(without_color).to be_a(described_class)
    end

    it 'is expected to return a new instance' do
      expect(without_color).not_to equal(sequenced_string)
    end

    it 'is expected to omit background color sequence' do
      expect(without_color.to_s).not_to include('42')
    end

    it 'is expected to omit foreground color sequence' do
      expect(without_color.to_s).not_to include('31')
    end

    it 'is expected to preserve style sequence' do
      expect(without_color.to_s).to include('1')
    end
  end

  describe '#without_foreground' do
    subject(:without_foreground) { sequenced_string.without_foreground }

    let(:sequenced_string) { described_class.new(input) }
    let(:input) { "\e[31;44mColored\e[0m \e[1mBold\e[0m" }

    it 'is expected to return a SequencedString' do
      expect(without_foreground).to be_a(described_class)
    end

    it 'is expected to return a new instance' do
      expect(without_foreground).not_to equal(sequenced_string)
    end

    it 'is expected to omit foreground color sequence' do
      expect(without_foreground.to_s).not_to include('31')
    end

    it 'is expected to preserve background color sequence' do
      expect(without_foreground.to_s).to include('44')
    end

    it 'is expected to preserve style sequence' do
      expect(without_foreground.to_s).to include('1')
    end
  end

  describe '#without_style' do
    subject(:without_style) { sequenced_string.without_style(*styles) }

    let(:sequenced_string) { described_class.new(input) }
    let(:input) { "\e[1;4;37mStyled\e[0m" }

    context 'when called with no arguments' do
      let(:styles) { [] }

      it 'is expected to return a SequencedString' do
        expect(without_style).to be_a(described_class)
      end

      it 'is expected to return a new instance' do
        expect(without_style).not_to equal(sequenced_string)
      end

      it 'is expected to omit bold style sequence' do
        expect(without_style.to_s).not_to include('1')
      end

      it 'is expected to omit underline style sequence' do
        expect(without_style.to_s).not_to include('4')
      end

      it 'is expected to preserve color sequence' do
        expect(without_style.to_s).to include('37')
      end
    end

    context 'when called with specific style' do
      let(:styles) { [:bold] }

      it 'is expected to omit specified style sequence' do
        expect(without_style.to_s).not_to include('1')
      end

      it 'is expected to preserve other style sequences' do
        expect(without_style.to_s).to include('4')
      end

      it 'is expected to preserve color sequence' do
        expect(without_style.to_s).to include('37')
      end
    end

    context 'when called with multiple styles' do
      let(:styles) { %i[bold underline] }

      it 'is expected to omit first specified style sequence' do
        expect(without_style.to_s).not_to include('1')
      end

      it 'is expected to omit second specified style sequence' do
        expect(without_style.to_s).not_to include('4')
      end

      it 'is expected to preserve color sequence' do
        expect(without_style.to_s).to include('37')
      end
    end
  end
end
