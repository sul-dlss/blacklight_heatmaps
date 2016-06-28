require 'rails/generators'

module BlacklightHeatmaps
  class Install < Rails::Generators::Base
    def add_gems
      gem 'blacklight_heatmaps'
    end

    source_root File.expand_path('../templates', __FILE__)

    def assets
      copy_file 'blacklight_heatmaps.scss', 'app/assets/stylesheets/blacklight_heatmaps.scss'
      copy_file 'blacklight_heatmaps.js', 'app/assets/javascripts/blacklight_heatmaps.js'
    end

    def configuration
      inject_into_file 'app/controllers/catalog_controller.rb', after: 'configure_blacklight do |config|' do
        "\n    # BlacklightHeatmaps configuration values" \
        "\n    config.geometry_field = :geo_srpt" \
        "\n    config.basemap = 'http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png'" \
        "\n    config.show.partials.insert(1, :show_leaflet_map)" \
        "\n    config.view.heatmaps.partials = []" \
        "\n"
      end
    end

    def add_model_mixin
      inject_into_file 'app/models/solr_document.rb', after: 'include Blacklight::Solr::Document' do
        "\n  include BlacklightHeatmaps::GeometrySolrDocument\n"
      end
    end

    def inject_search_builder
      inject_into_file 'app/models/search_builder.rb', after: /include Blacklight::Solr::SearchBuilderBehavior.*$/ do
        "\n  include BlacklightHeatmaps::SolrFacetHeatmapBehavior\n"
      end
    end
  end
end
