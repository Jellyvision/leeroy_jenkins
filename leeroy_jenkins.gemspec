# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'leeroy_jenkins/version'

Gem::Specification.new do |spec|
  spec.name          = 'leeroy_jenkins'
  spec.version       = LeeroyJenkins::VERSION
  spec.authors       = ['Jeff Rabovsky']
  spec.email         = ['jeffr@jellyvision.com']

  spec.summary       = 'A CLI tool for managing Jenkins job configurations'
  spec.homepage      = 'https://github.com/Jellyvision/leeroy_jenkins'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'jenkins_api_client', '~> 1.4'
  spec.add_dependency 'nokogiri', '~> 1.6'
  spec.add_dependency 'parallel', '~> 1.6'
  spec.add_dependency 'thor', '~> 0.19.1'

  spec.add_development_dependency 'aruba', '~> 0.9.0'
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'cucumber', '~> 2.1'
  spec.add_development_dependency 'pry', '~> 0.10.1'
  spec.add_development_dependency 'pry-doc', '~> 0.8.0'
  spec.add_development_dependency 'pry-stack_explorer', '~> 0.4.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'rubocop', '~> 0.42.0'
  spec.add_development_dependency 'simplecov', '~> 0.12.0'
end
