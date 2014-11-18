# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'herdic/version'

Gem::Specification.new do |spec|
  spec.name          = 'herdic'
  spec.version       = Herdic::VERSION
  spec.authors       = ['Yuki Iwanaga']
  spec.email         = ['yuki@creasty.com']
  spec.summary       = 'A command line HTTP client intended to create and test API documentation with ease'
  spec.description   = 'A command line HTTP client intended to create and test API documentation with ease'
  spec.homepage      = 'https://github.com/creasty/herdic'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 4.1', '>= 3.2'
  spec.add_dependency "pygments.rb"

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.3'
end
