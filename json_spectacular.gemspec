# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json_spectacular/version'

Gem::Specification.new do |spec|
  spec.name          = 'json_spectacular'
  spec.version       = JSONSpectacular::VERSION
  spec.authors       = ['Aleck Greenham']
  spec.email         = ['greenhama13@gmail.com']
  spec.summary       = 'JSON assertions with noise-free reports on complex nested structures'
  spec.description   = 'JSON assertions that help you find exactly what has changed with ' \
                        'your JSON API without having to manually diff large objects'
  spec.homepage      = 'https://github.com/greena13/json_spectacular'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'hashdiff', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'guard', '~> 2.1'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency 'rspec', '~> 3.5'
end
