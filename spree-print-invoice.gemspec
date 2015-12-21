# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_print_invoice'
  s.version     = '1.1.0'
  s.summary     = 'Print invoices from a spree order'
  s.homepage    = 'https://github.com/spree/spree_print_invoice'

  s.required_ruby_version = '>= 1.8.7'

  s.files        = Dir['README.md', 'lib/**/*', 'app/**/*', 'config/*']
  s.require_path = 'lib'
  s.requirements << 'none'
  s.authors      = 'Spree Community'

  s.add_dependency('barby', '~> 0.5.0')

  s.add_dependency('prawn', '2.0.2')

  s.add_dependency "solidus", [">= 1.1.0.pre", "< 1.2.0"]

  s.add_development_dependency 'rspec-rails', '~> 2.14.0'
end
