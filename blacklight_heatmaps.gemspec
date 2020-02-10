$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'blacklight_heatmaps/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'blacklight_heatmaps'
  s.version     = BlacklightHeatmaps::VERSION
  s.authors     = ['Jack Reed']
  s.email       = ['phillipjreed@gmail.com']
  s.homepage    = 'https://github.com/sul-dlss/blacklight_heatmaps'
  s.summary     = 'Search and view Blacklight resources on a map.'
  s.description = 'Search and view Blacklight resources on a map.'
  s.license     = 'Apache'

  s.files = Dir['{app,config,db,lib,vendor}/**/*', 'LICENSE.txt', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 5.2'
  s.add_dependency 'blacklight', '~> 7.0'
  s.add_dependency 'leaflet-rails', '~> 1.2.0'
  s.add_dependency 'leaflet-sidebar-rails', '~> 0.2'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '~> 3.4'
  s.add_development_dependency 'engine_cart', '~> 2.0'
  s.add_development_dependency 'solr_wrapper'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'webdrivers'
end
