# encoding: UTF-8

$:.push File.expand_path("../lib", __FILE__)
require "histomatic/version"

Gem::Specification.new do |s|
  s.name        = "histomatic"
  s.version     = Histomatic::VERSION
  s.authors     = ["Christopher Meiklejohn"]
  s.email       = ["christopher.meiklejohn@gmail.com"]
  s.homepage    = "http://github.com/cmeiklejohn/histomatic"
  s.summary     = %q{Quick 'n dirty histograms.}
  s.description = %q{Quick 'n dirty histograms.}

  s.rubyforge_project = "histomatic"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency('rails')

  s.add_development_dependency('yard')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('redcarpet')

  s.add_development_dependency('rspec')
  s.add_development_dependency('rake')

  s.add_development_dependency('bundler')
  s.add_development_dependency('rspec') 
  s.add_development_dependency('rspec-rails') 
  s.add_development_dependency('guard')
  s.add_development_dependency('guard-rspec') 
  s.add_development_dependency('mysql2')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('factory_girl')
  s.add_development_dependency('factory_girl_rails')
  s.add_development_dependency('diesel') 
end
