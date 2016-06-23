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

    def configuration
      inject_into_file 'app/controllers/catalog_controller.rb', after: 'configure_blacklight do |config|' do
        "\n    # BlacklightMaps configuration values" \
        "\n    config.geometry_field = :geo_srpt" \
        "\n    config.basemap = 'http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png'" \
        "\n    config.show.partials.insert(1, :show_leaflet_map)" \
        "\n"
      end
    end

    def add_model_mixin
      inject_into_file 'app/models/solr_document.rb', after: 'include Blacklight::Solr::Document' do
        "\n  include BlacklightMaps::GeometrySolrDocument\n"
      end
    end
  end
end
