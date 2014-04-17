# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trello_lead_time/version'

Gem::Specification.new do |spec|
  spec.name = 'trello_lead_time'
  spec.version       = TrelloLeadTime::VERSION
  spec.authors       = ['Scott Baldwin']
  spec.email         = ['scottsbaldwin@gmail.com']
  spec.summary       = %q{Lead and cycle time calculator for Trello boards.}
  spec.description   = %q{}
  spec.homepage      = 'https://github.com/scottsbaldwin/trello_lead_time'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
