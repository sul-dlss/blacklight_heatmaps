require 'spec_helper'

describe BlacklightHeatmaps::GeometrySolrDocument, :include_fixtures do
  subject { SolrDocument.new(fields).to_geojson(blacklight_config) }

  context 'when configured' do
    let(:fields) { { some_field: 'ENVELOPE(-0.0005, 0.000379, 0.000309, -0.000282)' } }
    let(:blacklight_config) { double('BlacklightConfig', geometry_field: :some_field) }
    it 'returns the data from the document as GeoJson FeatureCollection' do
      expect(subject).to eq null_island.gsub(/\s/, '')
    end
  end
  context 'when not configured' do
    let(:fields) { { some_field: 'ENVELOPE(1,2,4,3)' } }
    let(:blacklight_config) { double('BlacklightConfig') }
    it 'returns nil' do
      expect(subject).to be_nil
    end
  end
  context 'when the document has the field' do
    let(:fields) { { some_field: 'ENVELOPE(-0.0005, 0.000379, 0.000309, -0.000282)' } }
    let(:blacklight_config) { double('BlacklightConfig', geometry_field: :some_field) }
    it 'returns the data from the document as GeoJson FeatureCollection' do
      expect(subject).to eq null_island.gsub(/\s/, '')
    end
  end
  context 'when the document does not have the field' do
    let(:fields) { { some_other_field: 'ENVELOPE(1,2,4,3)' } }
    let(:blacklight_config) { double('BlacklightConfig', geometry_field: :some_field) }
    it 'returns nil' do
      expect(subject).to be_nil
    end
  end
end
