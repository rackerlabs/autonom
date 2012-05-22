# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "autonom/version"

Gem::Specification.new do |s|
  s.name        = "autonom"
  s.version     = Autonom::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = %w("Daniel Zepeda")
  s.email       = %w(autohost@rackspace.com)
  s.homepage    = ""
  s.summary     = %q{Just Autonomous Components}
  s.description = %q{Just Autonomous Components}

  s.rubyforge_project = "autonom"

  s.add_dependency 'rake'
  s.add_dependency 'require_all'
  s.add_dependency 'amqp'
  s.add_dependency 'foreman'
  s.add_dependency 'virtus'
  s.add_dependency 'active_support'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-reporters'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w(lib)
end
