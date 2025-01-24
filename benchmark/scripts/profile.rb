# frozen_string_literal: true

require 'bundler/setup'
require 'stackprof'
require 'sai'

SHORT_STRING = 'Hello, World!'
LONG_STRING = 'Hello, World!' * 1000
CUSTOM_COLOR = [:benchmark, [1, 2, 3]].freeze

StackProf.run(mode: :cpu, raw: true, out: File.expand_path('../../tmp/stackprof-cpu.dump', File.dirname(__FILE__))) do
  100_000.times do
    Sai.red.decorate(SHORT_STRING)
    Sai.on_red.decorate(SHORT_STRING)
    Sai.rgb(255, 0, 0).decorate(SHORT_STRING)
    Sai.hex('#FF0000').decorate(SHORT_STRING)
    Sai.red.bold.underline.decorate(SHORT_STRING)
    Sai.red.decorate(LONG_STRING)
    Sai.darken_text(0.5).decorate(SHORT_STRING)
    Sai.lighten_text(0.5).decorate(SHORT_STRING)
    Sai.gradient(:red, :blue, 10).decorate(SHORT_STRING)
    Sai.rainbow(10).decorate(SHORT_STRING)
    Sai.red.decorate(SHORT_STRING).stripped
    Sai.sequence("\e[31m#{SHORT_STRING}\e[0m")
    Sai.register(*CUSTOM_COLOR)
    Sai.rgb(255, 0, 0).on_rgb(0, 255, 0).decorate(SHORT_STRING)
    Sai.red.on_blue.darken_text(0.3).lighten_background(0.2).decorate(SHORT_STRING)
    Sai.on_gradient(:red, :blue, 10).decorate(SHORT_STRING)
    Sai.hex('#FF0000').on_hex('#00FF00').decorate(SHORT_STRING)
    Sai.red.decorate(SHORT_STRING).without_background.without_foreground.to_s
  end
end
