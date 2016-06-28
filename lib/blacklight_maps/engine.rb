module BlacklightMaps
  class Engine < ::Rails::Engine
    isolate_namespace BlacklightMaps
    initializer 'blacklight-maps.helpers' do |app|
      ActionView::Base.send :include, Blacklight::MapsHelper
    end
  end
end
