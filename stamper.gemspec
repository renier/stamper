# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stamper/version'

Gem::Specification.new do |spec|
  spec.name          = 'stamper'
  spec.version       = Stamper::VERSION
  spec.authors       = ['Renier Morales']
  spec.email         = ['renier@morales-rodriguez.net']
  spec.summary       = %q{You know. For file stamping.}
  spec.description   = %q{Prepends a blurb of text to any files you specify while respecting a list of includes and exclude patterns for maximum flexibility.}
  spec.homepage      = 'https://github.com/renier/stamper'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'colorize', '~> 0.7.3'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.3.0'
  spec.add_development_dependency 'rubocop', '~> 0.23.0'
  spec.add_development_dependency 'pry', '~> 0.10.0'
end
