# frozen_string_literal: true

require 'domainic/dev/test'
Domainic::Dev::Test::CoverageReporter.start if ENV['COVERAGE'] == 'true'
Domainic::Dev::Test.setup

require 'sai'

RSpec.configure do |config|
  config.before do
    Sai::Registry.instance_variable_set(:@lookup, {})
    Sai::Registry.instance_variable_set(:@names, nil)
  end

  config.after do
    Sai::Registry.instance_variable_set(:@lookup, {})
    Sai::Registry.instance_variable_set(:@names, nil)
  end
end
