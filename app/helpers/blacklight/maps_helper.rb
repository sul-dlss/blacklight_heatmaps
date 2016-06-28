module Blacklight
  module MapsHelper
    def index_map_div
      content_tag(
        :div,
        nil,
        class: 'blacklight-maps-index-map',
        id: 'index-map',
        data: {
          index_map: true,
          basemap: blacklight_config.basemap,
          search_url: request.url,
          geometry_field: blacklight_config.geometry_field,
          sidebar_template: sidebar_template
        }
      )
    end

    ##
    # The Leaflet template used for constructing the sidebar documents.
    # Variables from returned docs should be keys within curly braces
    # e.g. {title_display}
    # @return String
    def sidebar_template
      <<-HTML
      <div class='media'>
        <div class='media-body'>
          <h3 class='media-heading'>
            <a href=\"#{document_path}\"}>
              {#{blacklight_config.index.title_field}}
            </a>
          </h3>
        </div>
      </div>
      HTML
    end

    private

    def document_path
      "#{search_catalog_path}/{#{blacklight_config.document_unique_id_param}}"
    end
  end
end
