
require "rails/generators"

module BlacklightHeatmaps
    class Assets < Rails::Generators::Base
      source_root BlacklightHeatmaps::Engine.root.join("lib", "generators", "blacklight_heatmaps", "templates")

      desc <<-DESCRIPTION
        .....TODO
      DESCRIPTION

      def pmessage
        puts "GENERATING IMPORTMAP ASSETS assets_generator"
      end

      # NOTE: in say exhibits these could come from that app, or npm
      def insert_styles
        append_to_file "app/assets/stylesheets/application.sass.scss", <<~STYLES
          /* Dependencies CSS */
          @import url("https://cdn.skypack.dev/leaflet@1.9.4/dist/leaflet.css");
        STYLES
      end

      # Ensure import of Blacklight's JS uses the name that importmap has pinned
      def update_blacklight_import
        append_to_file "app/javascript/application.js", "import Blacklight from \"blacklight\";\n"      
      end

      # Import BlacklightHeatmaps's JS using the name that importmap has pinned
      def add_blacklight_heatmaps_js
        append_to_file "app/javascript/application.js", "import BlacklightHeatmaps from \"blacklight_heatmaps\";\n"
      end
    end
end