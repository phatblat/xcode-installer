# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'xcode-installer'

Gem::Specification.new do |s|
  s.name        = "xcode-installer"
  s.license     = "MIT"
  s.authors     = ["Ben Chatelain"]
  s.email       = "benchatelain@gmail.com"
  s.homepage    = "https://github.com/phatblat/xcode-installer"
  s.version     = XcodeInstaller::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "XcodeInstaller"
  s.description = "A command-line interface for the downloading Xcode"

  s.add_dependency "commander", "~> 4.1.2"
  s.add_dependency "terminal-table", "~> 1.4.5"
  s.add_dependency "mechanize", "~> 2.5.1"
  s.add_dependency "mechanize-progressbar", "~> 0.2.0"
  s.add_dependency "security", "~> 0.1.2"
  s.add_dependency "trash", "~> 0.2.0"

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"

  s.files         = Dir["./**/*"].reject { |file| file =~ /(\.(dmg|gem))|(\.\/(bin|log|pkg|script|spec|test|vendor))/ }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
