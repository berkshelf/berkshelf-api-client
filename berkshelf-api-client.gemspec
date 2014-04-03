# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'berkshelf/api_client/version'

Gem::Specification.new do |spec|
  spec.name                      = "berkshelf-api-client"
  spec.version                   = Berkshelf::APIClient::VERSION
  spec.authors                   = [
    "Jamie Winsor",
    "Michael Ivey",
    "Seth Vargo"
  ]
  spec.email                     = [
    "jamie@vialstudios.com",
    "michael.ivey@riotgames.com",
    "sethvargo@gmail.com"
  ]
  spec.description               = %q{API Client for communicating with a Berkshelf API server}
  spec.summary                   = spec.description
  spec.homepage                  = "http://berkshelf.com"
  spec.license                   = "Apache 2.0"
  spec.required_ruby_version     = ">= 1.9.2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.9.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "fuubar",  "~> 1.1"
  spec.add_development_dependency "rspec",   "~> 2.13"
  spec.add_development_dependency "spork",   "~> 0.9"
  spec.add_development_dependency "yard",    "~> 0.8"
end
