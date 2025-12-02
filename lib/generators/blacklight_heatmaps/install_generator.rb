require 'rails/generators'

module BlacklightHeatmaps
  class Install < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)
    class_option :test, type: :boolean, default: false, aliases: '-t', desc: 'Indicates that app will be installed in a test environment'

    def copy_styles
      if defined?(Sprockets)
        copy_file 'blacklight_heatmaps.scss', 'app/assets/stylesheets/blacklight_heatmaps.scss'
      else
        copy_file 'blacklight_heatmaps.css', 'app/assets/stylesheets/blacklight_heatmaps.css'
      end
    end

    def inject_js_sprockets
      return unless File.exist?('app/assets/javascripts/application.js')

      inject_into_file 'app/assets/javascripts/application.js', after: '//= require blacklight/blacklight' do
        "\n// Required by BlacklightHeatmaps" \
        "\n//= require leaflet" \
        "\n//= require L.Control.Sidebar" \
        "\n//= require blacklight_heatmaps/default" \
        "\n//= require blacklight_heatmaps/init"
      end
    end

    def inject_js_propshaft
      return unless File.exist?('app/javascript/application.js')

      inject_into_file 'app/javascript/application.js' do
        <<~JS
          import BlacklightHeatmaps from 'blacklight-heatmaps/app/assets/javascripts/blacklight_heatmaps/default.esm.js'
          window.BlacklightHeatmaps = BlacklightHeatmaps

          Blacklight.onLoad(function () {
            BlacklightHeatmaps.init()
          })

        JS
      end
    end

    def add_packages
      return if defined?(Sprockets)

      run 'yarn add leaflet'
      run 'yarn add leaflet-sidebar@"^0.2.4"'

      if ENV['CI']
        run "yarn add file:#{BlacklightHeatmaps::Engine.root}"
      elsif options[:test]
        run 'yarn link "blacklight-heatmaps"'
      else
        run 'yarn add "blacklight-heatmaps"'
      end
    end

    def add_styles
      return unless File.exist?('app/assets/stylesheets/application.bootstrap.scss') && defined?(Propshaft)

      append_to_file 'app/assets/stylesheets/application.bootstrap.scss' do
        <<~CONTENT
          @import "leaflet/dist/leaflet";
          @import "leaflet-sidebar/src/L.Control.Sidebar";
          @import "./blacklight_heatmaps";
        CONTENT
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
