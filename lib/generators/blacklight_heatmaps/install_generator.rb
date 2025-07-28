require 'rails/generators'

module BlacklightHeatmaps
  class Install < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def copy_styles
      copy_file 'blacklight_heatmaps.scss', 'app/assets/stylesheets/blacklight_heatmaps.scss'
    end

    def inject_js_sprockets
      return unless File.exist?('app/assets/javascripts/application.js')

      inject_into_file 'app/assets/javascripts/application.js', after: '//= require blacklight/blacklight' do
        "\n// Required by BlacklightHeatmaps" \
        "\n//= require leaflet" \
        "\n//= require L.Control.Sidebar" \
        "\n//= require blacklight_heatmaps/default"
      end
    end

    def inject_js_propshaft
      return unless File.exist?('app/javascript/application.js')

      inject_into_file 'app/javascript/application.js' do
        <<~JS
          import 'leaflet-sidebar/src/L.Control.Sidebar'
          import BlacklightHeatmaps from 'blacklight-heatmaps/app/assets/javascripts/blacklight_heatmaps/default.esm.js'
          window.BlacklightHeatmaps = BlacklightHeatmaps

          BlacklightHeatmaps.Basemaps.positron = L.tileLayer(
            'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png', {
              attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
              detectRetina: true,
              noWrap: true,
            }
          );
        JS
      end
    end

    def configuration
      inject_into_file 'app/controllers/catalog_controller.rb', after: 'configure_blacklight do |config|' do
        "\n    # BlacklightHeatmaps configuration values" \
        "\n    config.geometry_field = :geo_srpt" \
        "\n    config.heatmap_distErrPct = 0.15 # Default Solr value" \
        "\n    # Basemaps configured include: 'positron', 'darkMatter', 'OpenStreetMap.HOT'" \
        "\n    config.basemap_provider = 'positron'" \
        "\n    config.show.partials.insert(1, :show_leaflet_map)" \
        "\n    config.index.respond_to.heatmaps = true" \
        "\n    config.view.heatmaps(partials: []," \
        "\n                         color_ramp: ['#ffffcc', '#a1dab4', '#41b6c4', '#2c7fb8', '#253494']," \
        "\n                         icon: BlacklightHeatmaps::Icons::HeatmapsComponent)" \
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
