# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sitetap/version'

Gem::Specification.new do |spec|
  spec.name          = "sitetap"
  spec.version       = Sitetap::VERSION
  spec.authors       = ["Sean C Davis"]
  spec.email         = ["scdavis41@gmail.com"]
  spec.summary       = %q{Scrape content from a website.}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "nokogiri"
  spec.add_runtime_dependency "reverse_markdown"
  spec.add_runtime_dependency "sanitize"
end
