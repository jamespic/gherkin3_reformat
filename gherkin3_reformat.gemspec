# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gherkin3_reformat/version'

Gem::Specification.new do |spec|
  spec.name          = "gherkin3_reformat"
  spec.version       = Gherkin3Reformat::VERSION
  spec.authors       = ["James Pickering"]
  spec.email         = ["james_pic@hotmail.com"]

  spec.summary       = %q{Tool to reformat Gherkin3 files}
  spec.description   = %q{Tool to reformat Gherkin3 files to a consistent style}
  spec.homepage      = "http://github.com/jamespic/gherkin3_reformat"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = `git ls-files -z -- {test,spec,features}/*`.split("\x0")
  spec.bindir        = "bin"
  spec.executables   = ['gherkin3_reformat']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3.0"
  spec.add_dependency "gherkin3", "~> 3.1.2"
end
