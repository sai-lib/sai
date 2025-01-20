# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sai::ANSI::SequenceProcessor do
  describe '.process' do
    subject(:process) { described_class.process(string) }

    context 'when string has no ANSI sequences' do
      let(:string) { 'Hello, world!' }

      it 'is expected to return an array with a single segment' do
        expect(process).to contain_exactly(
          hash_including(
            foreground: nil,
            background: nil,
            styles: [],
            text: 'Hello, world!',
            encoded_start: 0,
            encoded_end: 13,
            stripped_start: 0,
            stripped_end: 13
          )
        )
      end
    end

    context 'when string has a foreground color sequence' do
      let(:string) { "\e[31mRed text\e[0m" }

      it 'is expected to return an array with a segment containing foreground color' do
        expect(process).to contain_exactly(
          hash_including(
            text: 'Red text',
            stripped_start: 0,
            stripped_end: 8
          )
        )
      end
    end

    context 'when string has a background color sequence' do
      let(:string) { "\e[41mRed background\e[0m" }

      it 'is expected to return an array with a segment containing background color' do
        expect(process).to contain_exactly(
          hash_including(
            text: 'Red background',
            stripped_start: 0,
            stripped_end: 14
          )
        )
      end
    end

    context 'when string has multiple text segments' do
      let(:string) { "Normal \e[31mred\e[0m\e[1mbold\e[0m text" }
      let(:segments) { process }

      it 'is expected to return four segments' do
        expect(segments.size).to eq(4)
      end

      it 'is expected to have a plain text segment for "Normal "' do
        expect(segments[0]).to include(
          text: 'Normal ',
          foreground: nil,
          background: nil,
          styles: []
        )
      end

      it 'is expected to have a red segment for "red"' do
        expect(segments[1]).to include(
          text: 'red',
          foreground: '31',
          background: nil,
          styles: []
        )
      end

      it 'is expected to have a bold segment for "bold"' do
        expect(segments[2]).to include(
          text: 'bold',
          foreground: nil,
          background: nil,
          styles: ['1']
        )
      end

      it 'is expected to have a plain text segment for " text"' do
        expect(segments[3]).to include(
          text: ' text',
          foreground: nil,
          background: nil,
          styles: []
        )
      end
    end

    context 'when string has extended color codes' do
      context 'with 256 colors' do
        let(:string) { "\e[38;5;196mRed 256-color\e[0m" }

        it 'is expected to return a segment with the text content' do
          expect(process).to contain_exactly(
            hash_including(
              text: 'Red 256-color',
              stripped_start: 0,
              stripped_end: 13
            )
          )
        end
      end

      context 'with RGB colors' do
        let(:string) { "\e[38;2;255;0;0mRGB red\e[0m" }

        it 'is expected to return a segment with the text content' do
          expect(process).to contain_exactly(
            hash_including(
              text: 'RGB red',
              stripped_start: 0,
              stripped_end: 7
            )
          )
        end
      end
    end

    context 'when using different color modes' do
      context 'with true color (24-bit) mode' do
        let(:string) { "\e[38;2;255;0;0m\e[48;2;0;0;255mRGB colors\e[0m" }

        it 'is expected to capture RGB color sequences' do
          expect(process).to contain_exactly(
            hash_including(
              text: 'RGB colors',
              foreground: '38;2;255;0;0',
              background: '48;2;0;0;255',
              styles: []
            )
          )
        end
      end

      context 'with 256 color (8-bit) mode' do
        let(:string) { "\e[38;5;196m\e[48;5;21m256 colors\e[0m" }

        it 'is expected to capture 256 color sequences' do
          expect(process).to contain_exactly(
            hash_including(
              text: '256 colors',
              foreground: '38;5;196',
              background: '48;5;21',
              styles: []
            )
          )
        end
      end

      context 'with 16 color (4-bit) mode' do
        let(:string) { "\e[31m\e[44mANSI colors\e[0m" }

        it 'is expected to capture ANSI color sequences' do
          expect(process).to contain_exactly(
            hash_including(
              text: 'ANSI colors',
              foreground: '31',
              background: '44',
              styles: []
            )
          )
        end
      end

      context 'with 8 color (3-bit) mode' do
        let(:string) { "\e[31m\e[44mBasic colors\e[0m" }

        it 'is expected to capture basic color sequences' do
          expect(process).to contain_exactly(
            hash_including(
              text: 'Basic colors',
              foreground: '31',
              background: '44',
              styles: []
            )
          )
        end
      end
    end

    context 'when using multiple style attributes' do
      let(:string) { "\e[1m\e[3m\e[4mBold, italic and underline\e[0m" }

      it 'is expected to capture all style sequences' do
        expect(process).to contain_exactly(
          hash_including(
            text: 'Bold, italic and underline',
            foreground: nil,
            background: nil,
            styles: %w[1 3 4]
          )
        )
      end

      it 'is expected to maintain style sequence order' do
        styles = process.first[:styles]
        expect(styles).to eq(%w[1 3 4])
      end
    end

    context 'when using all ANSI styles' do
      let(:string) do
        Sai::ANSI::STYLES.reject { |name, _| name.to_s.start_with?('no_') }
                         .map { |name, code| "\e[#{code}m#{name}\e[0m" }
                         .join(' ')
      end

      it 'is expected to capture each style in its own segment' do
        styles_mapping = Sai::ANSI::STYLES.reject { |name, _| name.to_s.start_with?('no_') }
                                          .transform_values(&:to_s)

        segments = process.reject { |seg| seg[:text] == ' ' }

        segments.each do |segment|
          style_name = segment[:text].to_sym
          expected_styles = [styles_mapping[style_name].to_s]
          expect(segment[:styles]).to eq(expected_styles),
                                      "Expected #{segment[:text]} to have styles #{expected_styles}, " \
                                      "got #{segment[:styles]}"
        end
      end
    end
  end
end
