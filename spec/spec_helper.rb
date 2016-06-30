ENV['RAILS_ENV'] ||= 'test'

if ENV['COVERAGE'] || ENV['CI']
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'engine_cart'
EngineCart.load_application!

require 'rspec/rails'

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

require 'blacklight'
require 'blacklight_heatmaps'

RSpec.configure do |c|
  c.infer_spec_type_from_file_location!
end
