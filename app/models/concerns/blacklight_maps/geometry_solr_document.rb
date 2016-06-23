module BlacklightMaps
  ##
  # Provides methods to convert Solr geometry strings
  module GeometrySolrDocument
    def to_geojson(blacklight_config = nil)
      return unless blacklight_config.try(:geometry_field) && fetch(blacklight_config.geometry_field, nil)
      BlacklightMaps::BoundingBox.from_envelope(fetch(blacklight_config.geometry_field)).to_geojson
    end
  end
end
