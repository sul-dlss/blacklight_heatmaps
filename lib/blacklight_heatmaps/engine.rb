module BlacklightHeatmaps
  class Engine < ::Rails::Engine
    isolate_namespace BlacklightHeatmaps
    initializer 'blacklight-maps.helpers' do |app|
      config.after_initialize do
        ActionView::Base.send :include, Blacklight::MapsHelper
      end

      Mime::Type.register 'application/vnd.heatmaps+json', :heatmaps
      if Blacklight::VERSION > '8'
        Blacklight::Configuration.default_configuration do
          Blacklight::Configuration.default_values[:search_state_fields] ||= []
          Blacklight::Configuration.default_values[:search_state_fields] += %i[bbox]
        end
      end
    end

    initializer "blacklight_heatmaps.importmap", before: "importmap" do |app|
      app.config.importmap.paths << Engine.root.join("config/importmap.rb") if app.config.respond_to?(:importmap)
    end
  end
end
