# frozen_string_literal: true

require 'bundler/setup'
require 'benchmark/ips'
require 'sai'
require_relative '../support/result_store'

SHORT_STRING = 'Hello, World!'
LONG_STRING = 'Hello, World!' * 1000
CUSTOM_COLOR = [:benchmark, [1, 2, 3]]

results = {}

report = Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report('Raw ANSI') do
    "\e[31m#{SHORT_STRING}\e[0m"
  end

  x.report('named color') do
    Sai.red.decorate(SHORT_STRING)
  end

  x.report('named background color') do
    Sai.on_red.decorate(SHORT_STRING)
  end

  x.report('rbg color') do
    Sai.rgb(255, 0, 0).decorate(SHORT_STRING)
  end

  x.report('hex color') do
    Sai.hex('#FF0000').decorate(SHORT_STRING)
  end

  x.report('multiple styles') do
    Sai.red.bold.underline.decorate(SHORT_STRING)
  end

  x.report('long string') do
    Sai.red.decorate(LONG_STRING)
  end

  x.report('darken_text') do
    Sai.darken_text(0.5).decorate(SHORT_STRING)
  end

  x.report('lighten_text') do
    Sai.lighten_text(0.5).decorate(SHORT_STRING)
  end

  x.report('gradient') do
    Sai.gradient(:red, :blue, 10).decorate(SHORT_STRING)
  end

  x.report('rainbow') do
    Sai.rainbow(10).decorate(SHORT_STRING)
  end

  x.report('color stripping') do
    Sai.red.decorate(SHORT_STRING).stripped
  end

  x.report('color sequence parsing') do
    Sai.sequence("\e[31m#{SHORT_STRING}\e[0m")
  end

  x.report('color registration') do
    Sai.register(*CUSTOM_COLOR)
  end

  x.compare!
end

# Capture results from the report data
report.entries.each do |entry|
  results[entry.label] = {
    ips: entry.ips,
    stddev: entry.stats.error,
    stddev_percentage: entry.stats.error_percentage,
    microseconds_per_op: (1_000_000.0 / entry.ips),
    iterations: entry.iterations,
    samples: entry.stats.samples.size
  }
end

# Store the results
filepath = ResultStore.store('speed', results)
puts "\nResults stored in: #{filepath}"
