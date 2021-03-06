# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hue_bridge/version'

Gem::Specification.new do |spec|
  spec.name          = "hue_bridge"
  spec.version       = HueBridge::VERSION
  spec.authors       = ["Kristopher Bredemeier"]
  spec.email         = ["k.bredemeier@gmail.com"]

  spec.summary       = %q{Gem to controll Philips hue lights with ruby}
  spec.description   = %q{Gem to controll Philips hue lights with ruby}
  spec.homepage      = %q{https://github.com/kbredemeier/hue_bridge}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry-byebug", "~> 3.4.0"
  spec.add_development_dependency "webmock", "~> 2.1.0"
  spec.add_development_dependency "vcr", "~> 3.0.0"
end
