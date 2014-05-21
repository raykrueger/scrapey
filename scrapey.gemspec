# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scrapey/version'

Gem::Specification.new do |spec|
  spec.name          = "scrapey"
  spec.version       = Scrapey::VERSION
  spec.authors       = ["Ray Krueger"]
  spec.email         = ["raykrueger@gmail.com"]
  spec.summary       = "A sample scraper app."
  spec.description   = "A sample scraper app. This serves no purose other than filler for my github profile."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 2.14"
end
