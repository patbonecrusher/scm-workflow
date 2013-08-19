# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scm-workflow/version'

Gem::Specification.new do |gem|

  gem.name          = "scm-workflow"
  gem.version       = File.exist?('VERSION') ? File.read('VERSION') : Scm::Workflow::VERSION
  gem.authors       = ["Pat Laplante"]
  gem.email         = ["pat@covenofchaos.com"]
  gem.description   = %q{""}
  gem.summary       = %q{""}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.licenses 		= ["MIT"]

  gem.add_development_dependency 'rspec' 
  gem.add_development_dependency 'cli-colorize'
  gem.add_development_dependency 'rdoc', '>= 3.12'
  gem.add_development_dependency 'cucumber', '>= 1.0'
  gem.add_development_dependency 'simplecov'

  gem.add_runtime_dependency 'bundler', '>= 1.0.0'
  gem.add_runtime_dependency 'ruby'
  gem.add_runtime_dependency 'gitit', '>= 0.5.0'
  gem.add_runtime_dependency 'highline'
  gem.add_runtime_dependency 'builder'
  gem.add_runtime_dependency 'kruptos', '>= 0.2.0'
  gem.add_runtime_dependency 'inflector'
  gem.add_runtime_dependency 'workflow'

end
