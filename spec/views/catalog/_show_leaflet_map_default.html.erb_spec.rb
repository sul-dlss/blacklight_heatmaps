require 'spec_helper'

describe 'catalog/_show_leaflet_map_default.html.erb' do
  let(:document) do
    SolrDocument.new(geo_srpt: 'ENVELOPE(1,2,4,3)', id: 'abc123')
  end
  let(:blacklight_config) { Blacklight::Configuration.new }
  before do
    allow(view).to receive(:document).and_return(document)
  end
  context 'when geojson is available' do
    it 'should render the leaflet container' do
      blacklight_config.configure do |config|
        config.geometry_field = :geo_srpt
      end
      render partial: 'catalog/show_leaflet_map_default',
             locals: { document: document, blacklight_config: blacklight_config }
      expect(rendered).to have_css '.blacklight-maps-show-map'
      expect(rendered).to have_css '#map-abc123'
      expect(rendered).to have_css '[data-basemap]'
      expect(rendered).to have_css '[data-show-map]'
      expect(rendered).to have_css '[data-features]'
    end
  end
  context 'when geojson is not available' do
    it 'renders nothing' do
      render partial: 'catalog/show_leaflet_map_default',
             locals: { document: document, blacklight_config: blacklight_config }
      expect(rendered).to eq "\n"
    end
  end
end
