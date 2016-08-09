require 'simplecov'

SimpleCov.minimum_coverage 80
SimpleCov.start { add_filter '/spec/' }

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'leeroy_jenkins'
