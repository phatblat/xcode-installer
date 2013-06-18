#!/usr/bin/env ruby

require 'pp'
require 'yaml'

puts Dir.pwd
data = YAML::load( File.open( 'lib/xcode-installer/xcode-versions.yml' ) )
puts data
