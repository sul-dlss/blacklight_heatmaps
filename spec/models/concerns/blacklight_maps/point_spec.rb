require 'spec_helper'

describe BlacklightMaps::Point do
  describe '#to_geojson' do
    it 'creates geojson from the point' do
      expect(described_class.new(-180, 90).to_geojson)
        .to eq '{"type":"Point","coordinates":[-180.0,90.0]}'
    end
  end
  describe '.from_lng_lat' do
    subject { described_class.from_lng_lat('-180 90') }
    it 'instantiates an instance from a lng lat string' do
      expect(subject).to be_an described_class
      expect(subject.to_geojson)
        .to eq '{"type":"Point","coordinates":[-180.0,90.0]}'
    end
  end
end
