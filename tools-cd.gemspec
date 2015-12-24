# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tools/version'

Gem::Specification.new do |spec|
  spec.name          = 'Tools.CD'
  spec.version       = Tools::VERSION
  spec.authors       = ['Andrew Page']
  spec.email         = %w(andrew@andrewpage.me)

  spec.summary       = 'Collection of tools for automating a seedbox.'
  spec.summary       = 'Collection of tools for automating a seedbox.'
  spec.summary       = 'Collection of tools for automating a seedbox.'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
