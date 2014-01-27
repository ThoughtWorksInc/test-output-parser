# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'test_output_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "test-output-parser"
  spec.version       = TestOutputParser::VERSION
  spec.authors       = ["Akshay Karle"]
  spec.email         = ["akshay.a.karle@gmail.com"]
  spec.summary       = %q{A gem to get the summary of test outputs for further processing}
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "rspec"
end
