# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sock/drawer/version'

Gem::Specification.new do |spec|
  spec.name          = "sock-drawer"
  spec.version       = Sock::Drawer::VERSION
  spec.authors       = ["Adam Hess"]
  spec.email         = ["adamhess1991@gmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "redis"
  spec.add_dependency 'eventmachine'
  spec.add_dependency "em-hiredis"
  spec.add_dependency "em-websocket"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake", "~> 10.0"
end
