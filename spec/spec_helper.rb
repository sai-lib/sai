# frozen_string_literal: true

require 'domainic/dev/test'
Domainic::Dev::Test::CoverageReporter.start if ENV['COVERAGE'] == 'true'
Domainic::Dev::Test.setup

require 'sai'
