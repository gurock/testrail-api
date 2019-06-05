
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'testrail/version'

Gem::Specification.new do |spec|
  spec.name          = 'testrail-kit'
  spec.version       = Testrail::VERSION
  spec.authors       = ['Dai FUJIHARA']
  spec.email         = ['daipresents@gmail.com']

  spec.summary       = 'TestRail API Client for Ruby'
  spec.description   = 'TestRail API Client for Ruby. You can load this library as gem.'
  spec.homepage      = 'https://github.com/daipresents/testrail-kit'
  spec.licenses      = ['MIT']
  spec.extra_rdoc_files = %w[LICENSE.txt README.md]
  spec.files         = Dir['lib/*'] + Dir['lib/**/*'] + %w[Gemfile Rakefile README.md LICENSE.txt]
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 3.1'

  spec.add_development_dependency 'bundler', '~> 2.0.1'
  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'rake', '~> 12.3.2'
  spec.add_development_dependency 'rspec', '~> 3.8.0'
  spec.add_development_dependency 'rspec-expectations', '~> 3.8.3'
  spec.add_development_dependency 'rubocop', '~> 0.71'
end
