# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec_editor/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec_editor"
  spec.version       = RspecEditor::VERSION
  spec.authors       = ["Kurt Stephens"]
  spec.email         = ["ks.github@kurtstephens.com"]
  spec.summary       = %q{RSpec Formatter that interfaces with your editor.}
  spec.description   = %q{RSpec Formatter that interfaces with your editor.}
  spec.homepage      = "https://github.com/kstephens/rspec_editor"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "guard", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "guard", "~> 2.6"
  spec.add_development_dependency "guard-rspec", "~> 4.2"
  spec.add_development_dependency "simplecov", "~> 0.9"
end
