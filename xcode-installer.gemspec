# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xcode-installer'

Gem::Specification.new do |spec|
  spec.name        = 'xcode-installer'
  spec.version     = XcodeInstaller::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Ben Chatelain']
  spec.email       = 'benchatelain@gmail.com'
  spec.summary     = %q{A gem for installing Xcode}
  spec.description = %q{Installs Xcode GUI or command-line}
  spec.homepage    = 'https://github.com/phatblat/xcode-installer'
  spec.license     = 'MIT'

  spec.files         = Dir["./**/*"].reject { |file| file =~ /(\.(dmg|gem))|(\.\/(bin|log|pkg|script|spec|test|vendor))/ }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'commander', '~> 4.1.2'
  spec.add_dependency 'terminal-table', '~> 1.4.5'
  spec.add_dependency 'mechanize', '~> 2.5.1'
  spec.add_dependency 'security', '~> 0.1.2'
  spec.add_dependency 'trash', '~> 0.2.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
end
