module BlacklightHeatmaps
  ##
  # Used for creating and parsing bounding boxes from CQL Envelope syntax
  class BoundingBox
    ##
    # @param [String, Integer, Float] west
    # @param [String, Integer, Float] south
    # @param [String, Integer, Float] east
    # @param [String, Integer, Float] north
    def initialize(west, south, east, north)
      @west = west.to_f
      @south = south.to_f
      @east = east.to_f
      @north = north.to_f
    end

    ##
    # Returns a bounding box in ENVELOPE syntax
    # @return [String]
    def to_envelope
      "ENVELOPE(#{west}, #{east}, #{north}, #{south})"
    end

    ##
    # @return String
    def to_geojson
    {
      type: 'Polygon',
      coordinates: [
        [
          [west, south],
          [west, north],
          [east, north],
          [east, south],
          [west, south]
        ]
      ]
    }.to_json
    end

    def self.from_envelope(envelope)
      envelope = envelope[/.*ENVELOPE\(([^\)]*)/,1].split(',')
      new(envelope[0], envelope[3], envelope[1], envelope[2])
    end

    private

    attr_reader :west, :south, :east, :north
  end
end
