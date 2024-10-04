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

  s.add_dependency 'rails', '>= 7.1.4', '< 8'
  s.add_dependency 'blacklight'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'engine_cart', '~> 2.0'
  s.add_development_dependency 'solr_wrapper'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'selenium-webdriver', '~> 4.11'
end
