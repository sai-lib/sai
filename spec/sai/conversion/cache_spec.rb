# frozen_string_literal: true

require 'spec_helper'

# frozen_string_literal: true

RSpec.describe Sai::Conversion::Cache do
  describe '.fetch' do
    subject(:fetch_result) { described_class.fetch(operation_name, operation_variables, &block) }

    let(:operation_name) { :test_operation }
    let(:operation_variables) { [1, 2, 3] }
    let(:result) { [4, 5, 6] }
    let(:block) { -> { result } }

    it 'is expected to return the result of the block' do
      expect(fetch_result).to eq(result)
    end

    it 'is expected to cache the result' do
      first_result = described_class.fetch(operation_name, operation_variables, &block)
      second_result = described_class.fetch(operation_name, operation_variables, &block)

      expect(second_result).to equal(first_result)
    end

    context 'when using different operation names' do
      let(:other_operation) { :other_operation }

      it 'is expected to cache results separately' do
        first_result = described_class.fetch(operation_name, operation_variables, &block)
        other_result = described_class.fetch(other_operation, operation_variables, &block)

        expect(other_result).not_to equal(first_result)
      end
    end

    context 'when using different operation variables' do
      let(:other_variables) { [7, 8, 9] }

      it 'is expected to cache results separately' do
        first_result = described_class.fetch(operation_name, operation_variables, &block)
        other_result = described_class.fetch(operation_name, other_variables, &block)

        expect(other_result).not_to equal(first_result)
      end
    end
  end
end
