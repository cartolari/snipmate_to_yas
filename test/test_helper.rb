$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'snipmate_to_yas'

require 'minitest/autorun'
require 'pry-byebug'

require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new(:color => true)
