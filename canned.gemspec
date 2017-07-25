# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "canned/version"

Gem::Specification.new do |spec|
  spec.name          = "canned"
  spec.version       = Canned::VERSION
  spec.authors       = ["Gustavo Canedo"]
  spec.email         = ["gknedo@gmail.com"]

  spec.summary       = "Communication between ruby and soap services"
  spec.homepage      = 'https://github.com/gknedo/canned'

  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency("xml-simple")
  spec.add_dependency("httpi")
end