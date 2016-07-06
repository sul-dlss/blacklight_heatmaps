require 'spec_helper'

describe Blacklight::MapsHelper do
  let(:blacklight_config) do
    Blacklight::Configuration.new(
      basemap: 'http://www.example.com/{z}/{x}/{y}.png',
      geometry_field: 'geo_srpt',
      index: Blacklight::OpenStructWithHashAccess.new(
        title_field: 'title_display'
      )
    )
  end
  before do
    allow(helper).to receive_messages(blacklight_config: blacklight_config)
  end
  describe '#index_map_div' do
    it 'renders html with the required elements/attributes' do
      expect(helper.index_map_div)
        .to have_css '#index-map.blacklight-heatmaps-index-map'
      expect(helper.index_map_div)
        .to have_css '[data-index-map="true"]'
      expect(helper.index_map_div)
        .to have_css '[data-search-url="http://test.host"]'
      expect(helper.index_map_div)
        .to have_css '[data-geometry-field="geo_srpt"]'
      expect(helper.index_map_div)
        .to have_css '[data-basemap="http://www.example.com/{z}/{x}/{y}.png"]'
      expect(helper.index_map_div).to have_css '[data-sidebar-template]'
      expect(helper.index_map_div).to have_css '[data-color-ramp]'
    end
  end
  describe '#sidebar_template' do
    it 'renders html template used in sidebar' do
      expect(helper.sidebar_template)
        .to have_css '.media .media-body h3.media-heading a', text: '{title_display}'
    end
  end
end
