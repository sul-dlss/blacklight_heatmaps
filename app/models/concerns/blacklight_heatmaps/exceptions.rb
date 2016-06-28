module BlacklightHeatmaps
  module Exceptions
    class UnknownSpatialDataType < StandardError
      def message
        'BlacklightHeatmaps does not know how to parse that type of spatial data. '\
        'Please try using the CQL ENVELOPE or X Y syntax.'
      end
    end
  end
end
