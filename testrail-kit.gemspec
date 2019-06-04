
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'testrail/version'

Gem::Specification.new do |spec|
  spec.name          = 'testrail-kit'
  spec.version       = Testrail::VERSION
  spec.authors       = ['Dai FUJIHARA']
  spec.email         = ['daipresents@gmail.com']

  spec.summary       = %q{TestRail API Client for Ruby}
  spec.description   = %q{TestRail API Client for Ruby. You can load this library as gem.}
  spec.homepage      = 'https://github.com/daipresents/testrail-kit'
  spec.licenses      = ['MIT']
  spec.extra_rdoc_files = %w('LICENSE.txt' 'README.md')
  spec.files         = Dir['lib/*'] + Dir['lib/**/*'] + %w('Gemfile' 'Rakefile' 'README.md' 'LICENSE.txt')
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
end
