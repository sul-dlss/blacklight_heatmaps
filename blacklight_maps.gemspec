$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'blacklight_maps/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'blacklight_maps'
  s.version     = BlacklightMaps::VERSION
  s.authors     = ['Jack Reed']
  s.email       = ['phillipjreed@gmail.com']
  s.homepage    = 'https://github.com/sul-dlss/blacklight_maps'
  s.summary     = 'Search and view Blacklight resources on a map.'
  s.description = 'Search and view Blacklight resources on a map.'
  s.license     = 'Apache'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE.txt', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 4.2.6'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '>=3.4', '< 4'
  s.add_development_dependency 'engine_cart', '~> 0.8'
end
