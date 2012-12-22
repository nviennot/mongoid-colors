# encoding: utf-8
$:.unshift File.expand_path("../lib", __FILE__)
$:.unshift File.expand_path("../../lib", __FILE__)

require 'mongoid-colors/version'

Gem::Specification.new do |s|
  s.name        = "mongoid-colors"
  s.version     = MongoidColors::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nicolas Viennot"]
  s.email       = ["nicolas@viennot.biz"]
  s.homepage    = "http://github.com/nviennot/rspec-console"
  s.summary     = "Colorize your Mongoid traces"
  s.description = "Colorize your Mongoid debug statments"

  s.add_dependency 'mongoid'
  s.add_dependency 'coderay'

  s.files        = Dir["lib/**/*"] + ['README.md']
  s.require_path = 'lib'
  s.has_rdoc     = false
end
