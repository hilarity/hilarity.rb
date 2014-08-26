# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hilarity/api/version"

Gem::Specification.new do |s|
  s.name        = "hilarity-api"
  s.version     = Hilarity::API::VERSION
  s.authors     = ["Zane Shannon"]
  s.email       = ["zcs@hilarity.io"]
  s.homepage    = "http://github.com/hilarity/hilarity.rb"
  s.license     = 'MIT'
  s.summary     = %q{Ruby Client for the Hilarity API}
  s.description = %q{Ruby Client for the Hilarity API}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'excon', '~>0.38'
  s.add_runtime_dependency 'multi_json', '~>1.8'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'
end
