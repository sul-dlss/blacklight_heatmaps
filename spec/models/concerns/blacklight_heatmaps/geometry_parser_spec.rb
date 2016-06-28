require 'spec_helper'

describe BlacklightHeatmaps::GeometryParser do
  describe '.parse' do
    context 'when parsing a CQL ENVELOPE' do
      it 'returns a BlacklightHeatmaps::BoundingBox' do
        expect(described_class.parse('ENVELOPE(1,2,4,3)'))
          .to be_an BlacklightHeatmaps::BoundingBox
      end
    end
    context 'when parsing an X Y coordinate' do
      it 'returns a BlacklightHeatmaps::Point' do
        expect(described_class.parse('-180 90')).to be_an BlacklightHeatmaps::Point
      end
    end
    context 'when parsing an unknown type' do
      it 'raises an exception' do
        expect do
          described_class.parse('123,23 32,123')
        end.to raise_error(BlacklightHeatmaps::Exceptions::UnknownSpatialDataType)
      end
    end
  end
end
