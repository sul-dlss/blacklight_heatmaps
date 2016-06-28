module BlacklightHeatmaps
  class Engine < ::Rails::Engine
    isolate_namespace BlacklightHeatmaps
    initializer 'blacklight-maps.helpers' do |app|
      ActionView::Base.send :include, Blacklight::MapsHelper
    end
  end
end
