# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snipmate_to_yas/version'

Gem::Specification.new do |spec|
  spec.name          = 'snipmate_to_yas'
  spec.version       = SnipmateToYas::VERSION
  spec.authors       = ['cartolari']
  spec.email         = ['bruno.cartolari@gmail.com']

  spec.summary       = 'Convert snippets from Vim Snipmate to Emacs YASnippet'
  spec.homepage      = 'http://github.com/cartolari/snipmate_to_yas'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'guard', '~> 2.14.1'
  spec.add_development_dependency 'guard-minitest', '~> 2.4.6'
  spec.add_development_dependency 'fakefs', '~> 0.6'
  spec.add_development_dependency 'minitest', '~> 5.8'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1.14'
  spec.add_development_dependency 'pry-byebug', '~> 3.2'
  spec.add_development_dependency 'rake', '~> 10.0'
end
