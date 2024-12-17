# frozen_string_literal: true

module BlacklightHeatmaps
  module Icons
    # This is the gallery icon for the view type button.
    # You can override the default svg by setting:
    #   Blacklight::Gallery:Icons::SlideshowComponent.svg = '<svg>your SVG here</svg>'
    class HeatmapsComponent < Blacklight::Icons::IconComponent
      self.svg = <<~SVG
        <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" width="24" height="24" viewBox="0 0 24 24"><path d="M0 0h24v24H0z" fill="none"/><path d="M16 10h-2v2h2v-2zm0 4h-2v2h2v-2zm-8-4H6v2h2v-2zm4 0h-2v2h2v-2zm8-6H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 14H4V6h16v12z"/></svg>
      SVG
    end
  end
end
