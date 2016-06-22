require 'rails/generators'

module BlacklightMaps
  class Install < Rails::Generators::Base
    def add_gems
      gem 'blacklight_maps'
    end

    source_root File.expand_path('../templates', __FILE__)

    def assets
      copy_file 'blacklight_maps.scss', 'app/assets/stylesheets/blacklight_maps.scss'
      copy_file 'blacklight_maps.js', 'app/assets/javascripts/blacklight_maps.js'
    end
  end
end
