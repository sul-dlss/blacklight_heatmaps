module BlacklightHeatmaps
  class Engine < ::Rails::Engine
    isolate_namespace BlacklightHeatmaps
    initializer 'blacklight-maps.helpers' do |app|
      config.after_initialize do
        ActionView::Base.send :include, Blacklight::MapsHelper
      end

      Mime::Type.register 'application/vnd.heatmaps+json', :heatmaps
    end
  end
end
