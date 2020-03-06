require 'spec_helper'

describe Blacklight::MapsHelper do
  let(:blacklight_config) do
    Blacklight::Configuration.new do |config|
      config.basemap_provider = 'positron'
      config.geometry_field = 'geo_srpt'
      config.index.title_field = 'title_display'
      config.view.heatmaps.color_ramp = ['#fef0d9', '#fdcc8a']
    end
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
        .to have_css '[data-basemap-provider="positron"]'
      expect(helper.index_map_div).to have_css '[data-sidebar-template]'
      expect(helper.index_map_div).to have_css '[data-color-ramp]'
      expect(helper.index_map_div).to have_css '[aria-label="heatmap"]'
    end
  end
  describe '#sidebar_template' do
    it 'renders html template used in sidebar' do
      expect(helper.sidebar_template)
        .to have_css '.media .media-body h3.media-heading a', text: '{title}'
    end
  end
end
