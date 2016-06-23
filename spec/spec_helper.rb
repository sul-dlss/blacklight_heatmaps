ENV['RAILS_ENV'] ||= 'test'

require 'engine_cart'
EngineCart.load_application!

require 'rspec/rails'

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

require 'blacklight'
require 'blacklight_maps'

RSpec.configure do |c|
  c.infer_spec_type_from_file_location!
end
