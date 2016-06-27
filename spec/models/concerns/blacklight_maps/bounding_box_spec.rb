require 'spec_helper'

describe BlacklightMaps::BoundingBox do
  describe '#initialize' do
    it 'handles multiple input types as arguments' do
      expect(described_class.new('1', '1', '1', '1')).to be_an described_class
      expect(described_class.new(1, 2, 3, 3)).to be_an described_class
      expect(described_class.new(1.1, 2.1, 3.1, 3.1)).to be_an described_class
    end
  end
  describe '#to_envelope' do
    let(:example_box) { described_class.new(-160, -80, 120, 70) }
    it 'creates an envelope syntax version of the bounding box' do
      expect(example_box.to_envelope).to eq 'ENVELOPE(-160.0, 120.0, 70.0, -80.0)'
    end
  end
  describe '#to_geojson' do
    let(:example_box) { described_class.new(-160, -80, 120, 70) }
    it 'creates a geoJSON string' do
      expect(example_box.to_geojson).to eq '{"type":"Polygon","coordinates":[[[-160.0,-80.0],[-160.0,70.0],[120.0,70.0],[120.0,-80.0],[-160.0,-80.0]]]}'
    end
  end
  describe '#from_rectangle' do
    let(:envelope) { 'ENVELOPE(-160.0, 120.0, 70.0, -80.0)' }
    let(:example_box) { described_class.from_envelope(envelope) }
    it 'parses and creates a Geoblacklight::BoundingBox from a Solr lat-lon' do
      expect(example_box).to be_an described_class
      expect(example_box.to_envelope).to eq envelope
    end
  end
end
