# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sock/drawer/version'

Gem::Specification.new do |spec|
  spec.name          = 'sock-drawer'
  spec.version       = Sock::Drawer::VERSION
  spec.authors       = ['Adam Hess']
  spec.email         = ['adamhess1991@gmail.com']
  spec.summary       = 'Super simple websocket manager. '
  spec.description   = 'Provide a really simple interface '\
                       'to manage events in ruby and via websockets using ruby and event machine.'
  spec.homepage      = 'https://github.com/HParker/sock-drawer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>=2.0.0'

  spec.add_dependency 'redis'
  spec.add_dependency 'eventmachine'
  spec.add_dependency 'em-hiredis'
  spec.add_dependency 'em-websocket'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'em-websocket-client'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
