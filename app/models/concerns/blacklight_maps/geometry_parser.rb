module BlacklightMaps
  ##
  # Parser that tries to understand the type of geospatial data stored in a
  # String and sends that to the correct parsing class.
  class GeometryParser
    ##
    # Utility method for determing the type of spatial data stored in a string
    # field
    # @param String
    def self.parse(geometry)
      case geometry
      when /^ENVELOPE\(.*\)$/
        BlacklightMaps::BoundingBox.from_envelope(geometry)
      when /^(\-?\d+(\.\d+)?) \w*(\-?\d+(\.\d+)?)$/
        BlacklightMaps::Point.from_lng_lat(geometry)
      else
        raise BlacklightMaps::Exceptions::UnknownSpatialDataType
      end
    end
  end
end
