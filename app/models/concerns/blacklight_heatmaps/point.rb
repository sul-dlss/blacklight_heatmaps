module BlacklightHeatmaps
  ##
  # A geometry class to characterize points. Can be longitude and latitude.
  class Point
    def initialize(x, y)
      @x = x.to_f
      @y = y.to_f
    end

    ##
    # @return String
    def to_geojson
      {
        type: 'Point',
        coordinates: [
          x, y
        ]
      }.to_json
    end

    ##
    # @param String
    def self.from_lng_lat(lng_lat)
      new(*lng_lat.split(' '))
    end

    private

    attr_reader :x, :y
  end
end
