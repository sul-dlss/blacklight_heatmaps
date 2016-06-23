require 'spec_helper'

describe BlacklightMaps::GeometrySolrDocument do
  subject { SolrDocument.new(fields).to_geojson(blacklight_config) }

  context 'when configured' do
    let(:fields) { { some_field: 'ENVELOPE(1,2,4,3)' } }
    let(:blacklight_config) { double('BlacklightConfig', geometry_field: :some_field) }
    it 'returns the data from the document as geoJSON' do
      expect(subject).to eq '{"type":"Polygon","coordinates":[[[1.0,3.0],[1.0,4.0],[2.0,4.0],[2.0,3.0],[1.0,3.0]]]}'
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
    let(:fields) { { some_field: 'ENVELOPE(1,2,4,3)' } }
    let(:blacklight_config) { double('BlacklightConfig', geometry_field: :some_field) }
    it 'returns the data from the document as geoJSON' do
      expect(subject).to eq '{"type":"Polygon","coordinates":[[[1.0,3.0],[1.0,4.0],[2.0,4.0],[2.0,3.0],[1.0,3.0]]]}'
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
