# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_tk/version'

Gem::Specification.new do |spec|
  spec.name          = 'simple_tk'
  spec.version       = SimpleTk::VERSION
  spec.authors       = ['Beau Barker']
  spec.email         = ['beau@barkerest.com']

  spec.summary       = 'A simple interface to the Ruby Tk bindings.'
  spec.homepage      = 'http://www.barkerest.com/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^((test|spec|features)/|simple_tk\.gemspec)})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency             'tk',           '~> 0.1.2'

  spec.add_development_dependency 'bundler',      '~> 1.14'
  spec.add_development_dependency 'rake',         '~> 10.0'
  spec.add_development_dependency 'minitest',     '~> 5.0'
end
