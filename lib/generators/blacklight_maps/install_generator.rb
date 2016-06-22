require 'rails/generators'

module BlacklightMaps
  class Install < Rails::Generators::Base
    def add_gems
      gem 'blacklight_maps'
    end
  end
end
