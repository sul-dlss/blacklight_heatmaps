
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


    initializer 'blacklight_heatmaps.importmap', before: 'importmap' do |app|
      app.config.importmap.paths << Engine.root.join("config/importmap.rb") if app.config.respond_to?(:importmap)
    end

    # Make the source JS and CSS available to built apps
    # External sass compiler doesn't know about rails asset paths
    initializer "blacklight_heatmaps.assets" do |app|
      app.config.assets.paths << BlacklightHeatmaps::Engine.root.join("app/assets/stylesheets")
      app.config.assets.paths << BlacklightHeatmaps::Engine.root.join("vendor/stylesheets")
      app.config.assets.paths << BlacklightHeatmaps::Engine.root.join("app/assets/images")
      app.config.assets.paths << BlacklightHeatmaps::Engine.root.join("app/javascript")
      app.config.assets.paths << BlacklightHeatmaps::Engine.root.join("vendor/javascript")
    end
  end
end